//
//  EditEntitySheet.swift
//  Notes
//
//  Created by Вадим Мартыненко on 14.12.2023.
//

import SwiftUI

struct EditEntitySheet: View {
    @State private var text: String
    
    private let editAction: (_ text: String) -> Void
    
    private let initialText: String
    
    init(text: String, editAction: @escaping (_ text: String) -> Void) {
        self._text = State(wrappedValue: text)
        self.editAction = editAction
        self.initialText = text
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Название", text: $text)
                .textFieldStyle(CustomTextFieldStyle())
            
            Button("Изменить") {
                editAction(text)
                dismiss()
            }
            .buttonStyle(CustomDefaultButtonStyle(disable: text.isEmpty || text == initialText))
        }
        .padding()
    }
}

#Preview {
    EditEntitySheet(text: "123") { _ in
        
    }
}
