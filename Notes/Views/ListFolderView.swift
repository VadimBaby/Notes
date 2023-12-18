//
//  FolderView.swift
//  Notes
//
//  Created by Вадим Мартыненко on 13.12.2023.
//

import SwiftUI

struct ListFoldersView: View {
    
    @State private var showAddFolderSheet: Bool = false
    @State private var showEditFolderSheet: Bool = false
    
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
                            NavigationLink(folder.title) {
                                FolderView(
                                    folder: folder,
                                    service: service
                                )
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button("Удалить") {
                                    viewModel.deleteFolder(id: folder.id)
                                }
                                .tint(Color.red)
                                
                                Button("Редактировать") {
                                    self.showEditFolderSheet.toggle()
                                }
                                .tint(Color.yellow)
                            }
                            .sheet(isPresented: $showEditFolderSheet, content: {
                                EditEntitySheet(text: folder.title) { text in
                                    viewModel.updateTitleFolder(newTitle: text, id: folder.id)
                                }
                            })
                        }
                    }
                    .refreshable {
                        await viewModel.asyncFetchFolders()
                    }
                } else {
                    noDataMessageView
                }
            }
            .onAppear {
                viewModel.fetchFolders()
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
                    viewModel.addFolders(title: title)
                }
                    .presentationCompactAdaptation(.sheet)
            }
            .navigationTitle("Папки")
            .onDisappear {
                viewModel.cancelAllTasks()
            }
        }
    }
}

#Preview {
    ListFoldersView(service: MockDataService())
}
