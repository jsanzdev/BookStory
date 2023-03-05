//
//  FavouritesView.swift
//  BookStory
//
//  Created by Jesus Sanz on 19/2/23.
//

import SwiftUI

struct ReadView: View {
    @EnvironmentObject var booksVM:BooksViewModel
    
    let loading = NotificationCenter.default
        .publisher(for: .loading)
        .compactMap{ $0.object as? Bool }
        .receive(on: RunLoop.main)
    
    var body: some View {
        NavigationStack {
            if booksVM.read.isEmpty {
                Text("Mark some books as read!")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .bold()
                    .navigationTitle("Your Read Books")
            } else {
                ScrollView {
                    ForEach(booksVM.read, id:\.self) { read in
                        if let book = booksVM.getBookByID(id: read) {
                            NavigationLink(value: book) {
                                BookRow(detailVM: DetailViewModel(book: book, booksVM: booksVM))
                            }
                        }
                    }
                }
                .padding()
                .buttonStyle(.plain)
                .navigationTitle("Your Read Books")
                .navigationDestination(for: Book.self) { book in
                    BookDetailView(detailVM: DetailViewModel(book: book, booksVM: booksVM))
                }
                .refreshable {
                    await booksVM.getReadBooks()
                }
            }
        }
        .onAppear {
            Task {
                do {
                    await booksVM.getReadBooks()
                }
            }
        }
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

struct ReadView_Previews: PreviewProvider {
    static var previews: some View {
        ReadView()
            .environmentObject(BooksViewModel())
    }
}
