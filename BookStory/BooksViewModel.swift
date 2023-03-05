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
    @Published var email = ""
    
    @Published var user:User = User(email: "")
    
    @Published var showAlert = false
    @Published var errorMsg = ""
    
    @Published var screenState:screenState = .loginScreen
    
    @Published var selected:Book.ID?
    
    @Published var loading = false
    
    @Published var search = ""
    @Published var bookSearch:[Book] = []
    
    @Published var read:[Int] = []
    
    
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
    
    @MainActor func loginUser(email:String) async -> Bool {
        do {
            user = try await persistence.getUser(email: email)
            //read = try await persistence.getReadBooks(email: user.email).books
            return true
        } catch let error as APIErrors {
            errorMsg = error.description
            showAlert.toggle()
            return false
        } catch {
            errorMsg = error.localizedDescription
            showAlert.toggle()
            return false
        }
    }
    
    @MainActor func createUser(user: User) async -> Bool {
        do {
            return try await persistence.createUser(user: user)
        } catch let error as APIErrors {
            errorMsg = error.description
            showAlert.toggle()
            return false
        } catch {
            errorMsg = error.localizedDescription
            showAlert.toggle()
            return false
        }
    }
    
    @MainActor func getReadBooks() async {
        loading = true
        do {
            read = try await persistence.getReadBooks(email: user.email).books
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
    
    func getBookByID(id:Int) -> Book? {
        books.first(where: { $0.id == id })
    }
    
    // MARK: - validations
    func validateEmpty(value:String) -> String? {
        if value.isEmpty {
            return "Field cannot be empty."
        } else {
            return nil
        }
    }
    
    func validatePassword(value:String) -> String? {
        if value.count < 8 {
            return "Password doesn't meet the requirements."
        } else {
            return nil
        }
    }
    
    func validateEmail(email:String) -> String? {
        do {
            let regex = try
            Regex(#"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"#)
            let email = try regex.wholeMatch(in: email)
            if let _ = email {
                return nil
            } else {
                return "This is not a valid email."
            }
        } catch {
            return "This is not a valid email."
        }
    }
    
    
}
