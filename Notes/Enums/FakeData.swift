//
//  FakeData.swift
//  Notes
//
//  Created by Вадим Мартыненко on 17.12.2023.
//

import Foundation

enum FakeData {
    static let folders: [FolderModel] = [
        FolderModel(title: "Работа"),
        FolderModel(title: "Личное"),
        FolderModel(title: "Учеба"),
        FolderModel(title: "Проекты")
    ]
    static let notes: [NoteModel] = [
        NoteModel(title: "Биология", idFolder: 1),
        NoteModel(title: "Математика", idFolder: 1),
        NoteModel(title: "Литература", idFolder: 1),
        NoteModel(title: "Химия", idFolder: 1)
    ]
}
