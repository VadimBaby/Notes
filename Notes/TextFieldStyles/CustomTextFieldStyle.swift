//
//  CustomTextFieldStyle.swift
//  Notes
//
//  Created by Вадим Мартыненко on 13.12.2023.
//

import SwiftUI

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(uiColor: .systemGray5))
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
    }
}

#Preview {
    struct Preview_TextField: View {
        
        @State private var text: String = ""
        
        var body: some View {
            TextField("Placeholder", text: $text)
                .textFieldStyle(CustomTextFieldStyle())
                .padding()
        }
    }
    
    return Preview_TextField()
}
