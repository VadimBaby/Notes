//
//  FolderViewComponents.swift
//  Notes
//
//  Created by Вадим Мартыненко on 14.12.2023.
//

import SwiftUI

extension FolderView {
    @ViewBuilder var noDataView: some View {
        Text("У вас нет заметок")
            .font(.title)
            .fontWeight(.medium)
    }
}
