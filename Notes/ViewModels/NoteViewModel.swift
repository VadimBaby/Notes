//
//  NoteViewModel.swift
//  Notes
//
//  Created by Вадим Мартыненко on 13.12.2023.
//

import Foundation
import Combine

final class NoteViewModel: ObservableObject {
    @Published private(set) var notes: [NoteModel] = []
    @Published private(set) var sortedNotes: [NoteModel] = []
    @Published private(set) var isLoading: Bool = false
    
    private let idFolder: Int
    
    private let service: DataServiceProtocol
    
    private var tasks: [Task<Void, Never>] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(idFolder: Int, service: DataServiceProtocol) {
        self.idFolder = idFolder
        self.service = service
        
        addSubcriber()
    }
    
    deinit {
        cancellables.forEach{ $0.cancel() }
        
        cancellables = []
    }
    
    func fetchNotes() {
        let task = Task {
            await MainActor.run {
                self.isLoading = true
            }
            
            await asyncFetchNotes()
        }
        
        tasks.append(task)
    }
    
    func asyncFetchNotes() async {
        do {
            let notes = try await service.fetchNotes(idFolder: idFolder)
            
            await MainActor.run {
                self.notes = notes
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.notes = []
                self.isLoading = false
            }
        }
    }
    
    func addNote(title: String) {
        let task = Task {
            do {
                let note = NoteModel(title: title, idFolder: idFolder)
                
                try await service.addNote(note: note)
                
                await MainActor.run {
                    self.notes.append(note)
                }
            } catch {
                print(error)
            }
        }
        
        tasks.append(task)
    }
    
    func deleteNote(indexSet: IndexSet) {
        let oldNotes = sortedNotes
        
        sortedNotes.remove(atOffsets: indexSet)
        
        notes = sortedNotes
        
        indexSet.forEach { index in
            Task {
                do {
                    try await service.deleteNote(id: oldNotes[index].id)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func cancelAllTasks() {
        tasks.forEach{ $0.cancel() }
        
        tasks = []
    }
    
    func updateNote(text: String, id: Int) {
        let task = Task {
            await MainActor.run {
                self.isLoading = true
            }
            
            do {
                try await service.updateNote(text: text, id: id)
                
                await MainActor.run {
                    self.isLoading = false
                    updateLocalNotes(text: text, id: id)
                }
            } catch {
                print(error)
                
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
        
        tasks.append(task)
    }
    
    func updateTitleNote(newTitle: String, id: Int) {
        guard let index = notes.firstIndex(where: { note in
            return note.id == id
        }) else { return }
        
        notes[index].title = newTitle
        
        Task {
            do {
                try await service.updateTitleNote(newTitle: newTitle, id: id)
            } catch {
                print(error)
            }
        }
    }
    
    private func updateLocalNotes(text: String, id: Int) {
        guard let index = notes.firstIndex(where: { loopNote in
            return loopNote.id == id
        }) else { return }
        
        notes[index].text = text
    }
    
    private func addSubcriber() {
        $notes
            .sink { notes in
                self.sortedNotes = notes.sorted{ $0.created_at > $1.created_at }
            }
            .store(in: &cancellables)
    }
}
