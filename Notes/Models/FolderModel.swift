//
//  FolderModel.swift
//  Notes
//
//  Created by Вадим Мартыненко on 13.12.2023.
//

import Foundation

struct FolderModel: Identifiable, Codable {
    let id: Int
    let name: String
    let created_at: Date
    
    init(id: Int = Int.random(in: 0...9999), name: String, created_at: Date = Date()) {
        self.id = id
        self.name = name
        self.created_at = created_at
    }
}
