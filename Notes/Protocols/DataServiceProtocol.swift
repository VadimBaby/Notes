//
//  ServiceDataProtocol.swift
//  Notes
//
//  Created by Вадим Мартыненко on 13.12.2023.
//

import Foundation

protocol DataServiceProtocol {
    func fetchFolders() async throws -> [FolderModel]
    
    func addFolder(folder: FolderModel) async throws
    
    func deleteFolder(id: Int) async throws
    
    func fetchNotes(idFolder: Int) async throws -> [NoteModel]
    
    func addNote(note: NoteModel) async throws
    
    func deleteNote(id: Int) async throws
    
    func updateNote(text: String, id: Int) async throws
    
    func updateTitleFolder(newTitle: String, id: Int) async throws
    
    func updateTitleNote(newTitle: String, id: Int) async throws
}
