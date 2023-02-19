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
    
    let book:Book
    
    @Published var author = ""
    
    init(book:Book) {
        self.book = book
        author = booksVM.getAuthorByID(id: book.author)?.name ?? "Author not found"
    }
}
