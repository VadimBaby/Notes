//
//  FolderViewModel.swift
//  Notes
//
//  Created by Вадим Мартыненко on 13.12.2023.
//

import Foundation
import Combine

final class FolderViewModel: ObservableObject {
    @Published private(set) var folders: [FolderModel] = []
    @Published private(set) var sortedFolders: [FolderModel] = []
    @Published private(set) var isLoading: Bool = false
    
    private var tasks: [Task<Void, Never>] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(service: DataServiceProtocol) {
        self.service = service
        
        addSubscriber()
    }
    
    deinit {
        cancellables.forEach{ $0.cancel() }
        
        cancellables = []
    }
    
    private let service: DataServiceProtocol
    
    func fetchFolders() {
        let task = Task {
            if folders.isEmpty {
                await MainActor.run {
                    self.isLoading = true
                }
                
                await asyncFetchFolders()
            }
        }
        
        tasks.append(task)
    }
    
    func asyncFetchFolders() async {
        do {
            let folders = try await service.fetchFolders()
            
            await MainActor.run {
                self.folders = folders
                self.isLoading = false
            }
        } catch {
            print(error)
            
            await MainActor.run {
                self.folders = []
                self.isLoading = false
            }
        }
    }
    
    func addFolders(title: String) {
        let task = Task {
            do {
                let folder = FolderModel(title: title)
                
                try await service.addFolder(folder: folder)
                
                await MainActor.run {
                    self.folders.append(folder)
                }
            } catch {
                print(error)
            }
        }
        
        tasks.append(task)
    }
    
    func deleteFolder(indexSet: IndexSet) {
        let oldFolders = sortedFolders
        
        sortedFolders.remove(atOffsets: indexSet)
        
        folders = sortedFolders
        
        indexSet.forEach { index in
            Task {
                do {
                    try await service.deleteFolder(id: oldFolders[index].id)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func updateTitleFolder(newTitle: String, id: Int) {
        guard let index = folders.firstIndex(where: { folder in
            return folder.id == id
        }) else { return }
        
        folders[index].title = newTitle
        
        Task {
            do {
                try await service.updateTitleFolder(newTitle: newTitle, id: id)
            } catch {
                print(error)
            }
        }
    }
    
    func cancelAllTasks() {
        tasks.forEach{ $0.cancel() }
        
        tasks = []
    }
    
    private func addSubscriber() {
        $folders
            .sink { folders in
                self.sortedFolders = folders.sorted{ $0.created_at > $1.created_at }
            }
            .store(in: &cancellables)
    }
}
