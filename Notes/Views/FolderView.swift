//
//  FolderView.swift
//  Notes
//
//  Created by Вадим Мартыненко on 13.12.2023.
//

import SwiftUI

struct FolderView: View {
    @State private var showAddNoteSheet: Bool = false
    @State private var showEditNoteSheet: Bool = false
    
    @StateObject private var viewModel: NoteViewModel
    
    private let folder: FolderModel
    private let service: DataServiceProtocol
    
    init(folder: FolderModel, service: DataServiceProtocol) {
        self._viewModel = StateObject(wrappedValue: NoteViewModel(
            idFolder: folder.id,
            service: service)
        )
        self.folder = folder
        self.service = service
    }
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else if !viewModel.notes.isEmpty {
                List {
                    ForEach(viewModel.sortedNotes) { note in
                        NavigationLink(note.title) {
                            NoteView(note: note, noteViewModel: viewModel) { text, id in
                                viewModel.updateNote(text: text, id: id)
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Удалить") {
                                viewModel.deleteNote(id: note.id)
                            }
                            .tint(Color.red)
                            
                            Button("Редактировать") {
                                self.showEditNoteSheet.toggle()
                            }
                            .tint(Color.yellow)
                        }
                        .sheet(isPresented: $showEditNoteSheet, content: {
                            EditEntitySheet(text: note.title) { newTitle in
                                viewModel.updateTitleNote(newTitle: newTitle, id: note.id)
                            }
                        })
                    }
                }
            } else {
                noDataView
            }
        }
        .onAppear {
            if viewModel.notes.isEmpty {
                viewModel.fetchNotes()
            }
        }
        .popover(isPresented: $showAddNoteSheet, content: {
            CreateEntitySheet { title in
                viewModel.addNote(title: title)
            }
            .presentationCompactAdaptation(.sheet)
        })
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    self.showAddNoteSheet.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .onDisappear {
            viewModel.cancelAllTasks()
        }
        .navigationTitle(folder.title)
    }
}

#Preview {
    NavigationStack {
        FolderView(folder: FolderModel(title: "Name"), service: MockDataService())
    }
}
