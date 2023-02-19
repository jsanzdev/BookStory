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
    
    @Published var showAlert = false
    @Published var errorMsg = ""
    
    @Published var selected:Book.ID?
    
    @Published var loading = false
    
    
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
}