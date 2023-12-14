//
//  FolderModel.swift
//  Notes
//
//  Created by Вадим Мартыненко on 13.12.2023.
//

import Foundation

struct FolderModel: Identifiable, Codable {
    let id: Int
    var title: String
    let created_at: Date
    
    init(id: Int = Int.random(in: 0...9999), title: String, created_at: Date = Date()) {
        self.id = id
        self.title = title
        self.created_at = created_at
    }
}
