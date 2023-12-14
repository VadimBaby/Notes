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
    
    private let client = SupabaseClient(supabaseURL: "https://jmsufvnxjbspcjobtpyx.supabase.co", supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imptc3Vmdm54amJzcGNqb2J0cHl4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDI0NTU4MzQsImV4cCI6MjAxODAzMTgzNH0.8N1WRvwbmsJEMfXNMCNyOQFW8Wuag4ilpJY6ke_ZoQg")
    
    func fetchFolders() async throws -> [FolderModel] {
        return try await client.database.from(folderDatabase).select().execute().value
    }
    
    func addFolder(folder: FolderModel) async throws {
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
