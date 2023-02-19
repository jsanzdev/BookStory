//
//  BooksViewModel.swift
//  BookStory
//
//  Created by Jesus Sanz on 9/2/23.
//

import SwiftUI
import Combine

final class BooksViewModel:ObservableObject {
    let persistence = NetworkPersistence.shared
    
    @Published var books:[Book] = []
    @Published var latest:[Book] = []
    @Published var authors:[Author] = []
    
    @Published var showAlert = false
    @Published var errorMsg = ""
    
    @Published var selected:Book.ID?
    
    @Published var loading = false
    
    @Published var search = ""
    @Published var bookSearch:[Book] = []
    
    
    var subscribers = Set<AnyCancellable>()
    
    init() {
        NotificationCenter.default
            .publisher(for: .loading)
            .compactMap { $0.object as? Bool }
            .receive(on: RunLoop.main)
            .assign(to: \.loading, on: self)
            .store(in: &subscribers)
    }
    
    @MainActor func getBooks() async {
        loading = true
        do {
            authors = try await persistence.getAuthors()
            books = try await persistence.getBooks().sorted {$0.id < $1.id }
        } catch let error as APIErrors {
            errorMsg = error.description
            showAlert.toggle()
        } catch {
            errorMsg = error.localizedDescription
            showAlert.toggle()
        }
        loading = false
    }
    
    @MainActor func getLatest() async {
        loading = true
        do {
            authors = try await persistence.getAuthors()
            latest = try await persistence.getLatest().sorted {$0.id < $1.id }
        } catch let error as APIErrors {
            errorMsg = error.description
            showAlert.toggle()
        } catch {
            errorMsg = error.localizedDescription
            showAlert.toggle()
        }
        loading = false
    }
    
    @MainActor func findBook(search:String) async {
        loading = true
        do {
            bookSearch = try await persistence.findBooks(search: search)
        } catch let error as APIErrors {
            errorMsg = error.description
            showAlert.toggle()
        } catch {
            errorMsg = error.localizedDescription
            showAlert.toggle()
        }
        loading = false
    }
    
    
    func getAuthorByID(id:String) -> Author? {
        authors.first(where: { $0.id == id })
    }
}
