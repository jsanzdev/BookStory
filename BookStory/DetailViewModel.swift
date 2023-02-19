//
//  DetailViewModel.swift
//  BookStory
//
//  Created by Jesus Sanz on 9/2/23.
//

import SwiftUI
import Combine

final class DetailViewModel:ObservableObject {
    
    let booksVM = BooksViewModel()
    let persistence = NetworkPersistence()
    
    let book:Book
    
    @Published var authorName = ""
    
    init(book:Book) {
        self.book = book
        authorName = booksVM.getAuthorByID(id: book.author)?.name ?? "Author not found"
    }
}
