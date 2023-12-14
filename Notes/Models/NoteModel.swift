//
//  NoteModel.swift
//  Notes
//
//  Created by Вадим Мартыненко on 13.12.2023.
//

import Foundation


struct NoteModel: Identifiable, Codable {
    let id: Int
    var text: String
    let title: String
    let idFolder: Int
    let created_at: Date
    
    init(id: Int = .random(in: 0...9999), title: String, text: String = "", idFolder: Int, created_at: Date = Date()) {
        self.id = id
        self.text = text
        self.idFolder = idFolder
        self.created_at = created_at
        self.title = title
    }
}
