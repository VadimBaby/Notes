//
//  DataService.swift
//  Notes
//
//  Created by Вадим Мартыненко on 13.12.2023.
//

import Foundation
import Supabase

actor DataService: DataServiceProtocol {
    
    private let folderDatabase = "Folders"
    private let noteDatabase = "Notes"
    
    private let client = SupabaseClient(supabaseURL: "https://vdyyplvwizpsoyabsqre.supabase.co", supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZkeXlwbHZ3aXpwc295YWJzcXJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDI4NjcyOTcsImV4cCI6MjAxODQ0MzI5N30.p5sX4CBVMt-Xt_bKfu80mPDt9mxgrFYyluTmZsEpZ0k")
    
    func fetchFolders() async throws -> [FolderModel] {
        return try await client.database.from(folderDatabase).select().execute().value
    }
    
    func addFolder(folder: FolderModel) async throws {
        if folder.title.isEmpty {
            throw URLError(.badServerResponse)
        }
        
        try await client.database.from(folderDatabase).insert(folder).execute()
    }
    
    func deleteFolder(id: Int) async throws {
        try await client.database.from(folderDatabase).delete().eq("id", value: id).execute()
        
        try await client.database.from(noteDatabase).delete().eq("idFolder", value: id).execute()
    }
    
    func fetchNotes(idFolder: Int) async throws -> [NoteModel] {
        try await client.database.from(noteDatabase).select().eq("idFolder", value: idFolder).execute().value
    }
    
    func addNote(note: NoteModel) async throws {
        if note.title.isEmpty {
            throw URLError(.badServerResponse)
        }
        try await client.database.from(noteDatabase).insert(note).execute()
    }
    
    func deleteNote(id: Int) async throws {
        try await client.database.from(noteDatabase).delete().eq("id", value: id).execute()
    }
    
    func updateNote(text: String, id: Int) async throws {
        try await client.database.from(noteDatabase).update(["text": text]).eq("id", value: id).execute()
    }
    
    func updateTitleFolder(newTitle: String, id: Int) async throws {
        try await client.database.from(folderDatabase).update(["title": newTitle]).eq("id", value: id).execute()
    }
    
    func updateTitleNote(newTitle: String, id: Int) async throws {
        try await client.database.from(noteDatabase).update(["title": newTitle]).eq("id", value: id).execute()
    }
}
