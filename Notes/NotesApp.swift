//
//  NotesApp.swift
//  Notes
//
//  Created by Вадим Мартыненко on 13.12.2023.
//

import SwiftUI

@main
struct NotesApp: App {
    
    private let service: DataServiceProtocol = DataService()
    
    var body: some Scene {
        WindowGroup {
            ListFolderView(service: service)
        }
    }
}
