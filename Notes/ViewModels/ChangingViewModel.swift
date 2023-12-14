//
//  ChangingViewModel.swift
//  Notes
//
//  Created by Вадим Мартыненко on 14.12.2023.
//

import Foundation
import Combine

class ChangingViewModel: ObservableObject {
    @Published var text: String
    
    private let note: NoteModel
    private let updateNote: (_ text: String, _ id: Int) -> Void
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        note: NoteModel,
        updateNote: @escaping (_ text: String, _ id: Int) -> Void
    ) {
        self._text = Published(initialValue: note.text)
        self.note = note
        self.updateNote = updateNote
        
        addSubscriber()
    }
    
    deinit {
        cancellables.forEach{ $0.cancel() }
        
        cancellables = []
    }
    
    func addSubscriber() {
        $text
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { text in
                print(text)
                self.updateNote(text, self.note.id)
            }
            .store(in: &cancellables)
    }
}
