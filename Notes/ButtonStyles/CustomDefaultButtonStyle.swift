//
//  CustomDefaultButtonStyle.swift
//  Notes
//
//  Created by Вадим Мартыненко on 13.12.2023.
//

import Foundation
import SwiftUI

struct CustomDefaultButtonStyle: ButtonStyle {
    
    let disable: Bool
    
    init(disable: Bool = false) {
        self.disable = disable
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .fontWeight(.medium)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background{
                disable ? Color.gray : configuration.isPressed ? Color.blue.opacity(0.7 ):  Color.blue
            }
            .clipShape(.rect(cornerRadius: 15))
    }
}

#Preview {
    Button("Button") { }
        .buttonStyle(CustomDefaultButtonStyle())
}
