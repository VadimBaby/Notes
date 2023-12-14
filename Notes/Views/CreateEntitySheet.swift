//
//  CreateFolderSheet.swift
//  Notes
//
//  Created by Вадим Мартыненко on 13.12.2023.
//

import SwiftUI

struct CreateEntitySheet: View {
    
    @State private var text: String = ""
    
    let addAction: (_ title: String) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Название", text: $text)
                .textFieldStyle(CustomTextFieldStyle())
            
            Button("Добавить") {
                addAction(text)
                dismiss()
            }
            .buttonStyle(CustomDefaultButtonStyle(disable: text.isEmpty))
        }
        .padding()
    }
}

#Preview {
    CreateEntitySheet { _ in
        
    }
}
