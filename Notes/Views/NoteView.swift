//
//  NoteView.swift
//  Notes
//
//  Created by Вадим Мартыненко on 13.12.2023.
//

import SwiftUI

struct NoteView: View {
    @StateObject private var viewModel: ChangingViewModel
    
    @ObservedObject var noteViewModel: NoteViewModel
    
    let note: NoteModel
    
    init(
        note: NoteModel,
        noteViewModel: NoteViewModel,
        updateNote: @escaping (_ text: String, _ id: Int) -> Void
    ) {
        self.note = note
        self.noteViewModel = noteViewModel
        self._viewModel = StateObject(wrappedValue: ChangingViewModel(
            note: note,
            updateNote: updateNote)
        )
    }
    
    @FocusState private var textEditorFocus: Bool
    
    var body: some View {
        TextEditor(text: $viewModel.text)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .navigationTitle(note.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if noteViewModel.isLoading {
                        ProgressView()
                    }
                }
            }
            .focused($textEditorFocus)
            .onAppear {
                textEditorFocus = true
            }
    }
}

#Preview {
    NavigationStack {
        NoteView(note: NoteModel(title: "title", text: "12f3", idFolder: 1), noteViewModel: NoteViewModel(idFolder: 1, service: DataService())) { _, _ in
            
        }
    }
}
