//
//  DataService_Tests.swift
//  Notes_Tests
//
//  Created by Вадим Мартыненко on 18.12.2023.
//

import XCTest
@testable import Notes

final class DataService_Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func test_DataService_fetchFolders_returnFolders() async throws {
        let service = DataService()
        
        let folders = try await service.fetchFolders()
        
        XCTAssertFalse(folders.isEmpty)
    }
    
    func test_DataService_addFolder_addedFolder() async throws {
        let service = DataService()
        
        let name = "test folder"
        
        let folder = FolderModel(title: name)
        
        do {
            try await service.addFolder(folder: folder)
            
            XCTAssertTrue(true)
        } catch  {
            if error.localizedDescription != "The network connection was lost." {
                print(error.localizedDescription)
                XCTFail()
            }
        }
    }
    
    func test_DataService_addFolder_notAddEmptyString() async throws {
        let service = DataService()
        
        let emptyString = ""
        
        let folder = FolderModel(title: emptyString)
        
        do {
            try await service.addFolder(folder: folder)
            
            XCTFail()
        } catch {
            
        }
    }
    
    func test_DataService_deleteFolder_deletedFolder() async throws {
        let service = DataService()
        
        do {
            let folders = try await service.fetchFolders()
            
            guard let folder = folders.randomElement() else { XCTFail(); return }
            
            try await service.deleteFolder(id: folder.id)
            
            print("Deleted: \(folder.id)")
            
            let newFolders = try await service.fetchFolders()
            
            XCTAssertGreaterThan(folders.count, newFolders.count)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            
            if error.localizedDescription != "The network connection was lost." {
                XCTFail()
            }
        }
    }
    
    func test_DataService_updateTitleFolder_updatedTitleFolder() async throws {
        let service = DataService()
        
        do {
            let folders = try await service.fetchFolders()
            
            guard let folder = folders.randomElement() else { XCTFail(); return }
            
            let newTitle = UUID().uuidString
            
            try await service.updateTitleFolder(newTitle: newTitle, id: folder.id)
            
            let newFolders = try await service.fetchFolders()
            
            guard let updatedFolder = newFolders.first(where: {$0.id == folder.id}) else { XCTFail(); return }
            
            XCTAssertEqual(updatedFolder.title, newTitle)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            
            if error.localizedDescription != "The network connection was lost." {
                XCTFail()
            }
        }
    }
    
    func test_DataService_fetchNotes_returnNotes() async throws {
        let service = DataService()
        
        do {
            let folders = try await service.fetchFolders()
            
            guard let folder = folders.randomElement() else { XCTFail(); return }
            
            let notes = try await service.fetchNotes(idFolder: folder.id)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            
            if error.localizedDescription != "The network connection was lost." {
                XCTFail()
            }
        }
    }
    
    func test_DataService_addNote_addedNote() async throws {
        let service = DataService()
        
        do {
            let folders = try await service.fetchFolders()
            
            guard let folder = folders.randomElement() else { XCTFail(); return }
            
            let title = UUID().uuidString
            
            let note =  NoteModel(title: title, idFolder: folder.id)
            
            try await service.addNote(note: note)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            
            if error.localizedDescription != "The network connection was lost." {
                XCTFail()
            }
        }
    }
    
    func test_DataService_deleteNote_deletedNote() async throws {
        let service = DataService()
        
        do {
            let folders = try await service.fetchFolders()
            
            guard let folder = folders.randomElement() else { XCTFail(); return }
            
            let notes = try await service.fetchNotes(idFolder: folder.id)
            
            guard let note = notes.randomElement() else { XCTFail(); return }
            
            try await service.deleteNote(id: note.id)
            
            print("Deleted note: title - \(note.title), idFolder - \(folder.id)")
        } catch {
            print("ERROR: \(error.localizedDescription)")
            
            if error.localizedDescription != "The network connection was lost." {
                XCTFail()
            }
        }
    }
    
    func test_DataService_updateTitleNote_updateTitleNote() async throws {
        let service = DataService()
        
        do {
            let folders = try await service.fetchFolders()
            
            guard let folder = folders.randomElement() else { XCTFail(); return }
            
            let note = NoteModel(title: "old title", idFolder: folder.id)
            
            try await service.addNote(note: note)
            
            let notes = try await service.fetchNotes(idFolder: folder.id)

            let newTitle = UUID().uuidString
            
            try await service.deleteNote(id: note.id)
            
            print("Updated note: new title - \(newTitle), idFolder - \(folder.id)")
            
            try await service.updateTitleNote(newTitle: newTitle, id: note.id)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            
            if error.localizedDescription != "The network connection was lost." {
                XCTFail()
            }
        }
    }
    
    func test_DataService_updateNote_updatedNote() async throws {
        let service = DataService()
        
        do {
            let folders = try await service.fetchFolders()
            
            guard let folder = folders.randomElement() else { XCTFail(); return }
            
            let note = NoteModel(title: "test title", text: "old text", idFolder: folder.id)
            
            try await service.addNote(note: note)
            
            let notes = try await service.fetchNotes(idFolder: folder.id)

            let newText = UUID().uuidString
            
            try await service.updateNote(text: newText, id: note.id)
            
            print("Updated note: new text - \(newText), idFolder - \(folder.id)")
            
            let newNotes = try await service.fetchNotes(idFolder: folder.id)
            
            guard let updatedNote = newNotes.randomElement() else { XCTFail(); return }
            
            XCTAssertEqual(updatedNote.text, newText)
        } catch {
            print("ERROR: \(error.localizedDescription)")
            
            if error.localizedDescription != "The network connection was lost." {
                XCTFail()
            }
        }
    }
}
