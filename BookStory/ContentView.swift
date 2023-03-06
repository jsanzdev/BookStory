//
//  ContentView.swift
//  BookStory
//
//  Created by Jesus Sanz on 6/2/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var booksVM:BooksViewModel
    
    let loading = NotificationCenter.default
        .publisher(for: .loading)
        .compactMap{ $0.object as? Bool }
        .receive(on: RunLoop.main)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Latest Books")
                        .font(.title2)
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem(.adaptive(minimum:90))]) {
                            ForEach(booksVM.latest, id:\.self) { book in
                                NavigationLink(value: book) {
                                    BookCover(detailVM: DetailViewModel(book: book, booksVM: booksVM))
                                }
                            }
                        }
                    }
                    .frame(height: 150)
                }
                .padding()
                LazyVStack {
                    if booksVM.search.isEmpty {
                        ForEach(booksVM.books, id:\.self) { book in
                            NavigationLink(value: book) {
                                BookRow(detailVM: DetailViewModel(book: book, booksVM: booksVM))
                            }
                        }
                    } else {
                        ForEach(booksVM.bookSearch, id:\.self) { book in
                            NavigationLink(value: book) {
                                BookRow(detailVM: DetailViewModel(book: book, booksVM: booksVM))
                            }
                        }
                    }
                }
                .padding()
                .buttonStyle(.plain)
            }
            .navigationTitle("BookStory")
            .navigationDestination(for: Book.self) { book in
                BookDetailView(detailVM: DetailViewModel(book: book, booksVM: booksVM))
            }
        }
        .refreshable {
            await booksVM.getBooks()
            await booksVM.getLatest()
            await booksVM.getReadBooks()
        }
        .searchable(text: $booksVM.search)
        .onAppear {
            Task {
                do {
                    await booksVM.getLatest()
                    await booksVM.getBooks()
                    await booksVM.getReadBooks()
                }
            }
        }
        .onChange(of: booksVM.search) { newValue in
            if newValue != "" {
                Task {
                    do {
                        await booksVM.findBook(search: booksVM.search)
                    }
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

struct ContentView_Previews: PreviewProvider {
    static let booksVM = BooksViewModel()
    static var previews: some View {
        ContentView()
            .environmentObject(booksVM)
            .task {
                await booksVM.getBooks()
            }
    }
}
