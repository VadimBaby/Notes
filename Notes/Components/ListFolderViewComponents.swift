//
//  ListFolderViewComponents.swift
//  Notes
//
//  Created by Вадим Мартыненко on 13.12.2023.
//

import SwiftUI

extension ListFoldersView {
    @ViewBuilder var noDataMessageView: some View {
        Text("У вас нет папок")
            .font(.title)
            .fontWeight(.medium)
    }
}
