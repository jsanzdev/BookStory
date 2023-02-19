//
//  SearchView.swift
//  BookStory
//
//  Created by Jesus Sanz on 19/2/23.
//
// Search was integrated into the content view :)

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var booksVM:BooksViewModel
    
    var body: some View {
        NavigationStack {
            if booksVM.search.isEmpty {
                Text("Search for a Book Title")
                    .bold()
            } else {
                List(booksVM.bookSearch) { book in
                    NavigationLink(value: book) {
                        BookRow(detailVM: DetailViewModel(book: book))
                    }
                }
                .navigationTitle("BookStory")
                .navigationDestination(for: Book.self) { book in
                    BookDetailView(detailVM: DetailViewModel(book: book))
                }
                .refreshable {
                    await booksVM.findBook(search: booksVM.search)
                }
            }
        }
        .searchable(text: $booksVM.search)
        .alert("Connection Error", isPresented: $booksVM.showAlert) {
            Button(action: {}) {
                Text("OK")
            }
        } message: {
            Text(booksVM.errorMsg)
        }
        .overlay {
            if booksVM.loading {
                LoadingView()
                    .transition(.opacity)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(BooksViewModel())
    }
}
