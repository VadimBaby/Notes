//
//  FolderView.swift
//  Notes
//
//  Created by Вадим Мартыненко on 13.12.2023.
//

import SwiftUI

struct ListFolderView: View {
    
    @State private var showAddFolderSheet: Bool = false
    
    @StateObject private var viewModel: FolderViewModel
    
    private let service: DataServiceProtocol
    
    init(service: DataServiceProtocol) {
        self._viewModel = StateObject(
            wrappedValue: FolderViewModel(service: service)
        )
        self.service = service
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                   ProgressView()
                } else if !viewModel.folders.isEmpty {
                    List {
                        ForEach(viewModel.sortedFolders) { folder in
                            NavigationLink(folder.name) {
                                FolderView(
                                    folder: folder,
                                    service: service
                                )
                            }
                        }
                        .onDelete(perform: viewModel.deleteFolder)
                    }
                    .refreshable {
                        await viewModel.asyncFetchFolders()
                    }
                } else {
                    noDataMessageView
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        self.showAddFolderSheet.toggle()
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .popover(isPresented: $showAddFolderSheet) {
                CreateEntitySheet { title in
                    viewModel.addFolders(name: title)
                }
                    .presentationCompactAdaptation(.sheet)
            }
            .navigationTitle("Папки")
            .onAppear {
                viewModel.fetchFolders()
            }
            .onDisappear {
                viewModel.cancelAllTasks()
            }
        }
    }
}

#Preview {
    ListFolderView(service: DataService())
}
