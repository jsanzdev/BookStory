//
//  ContentView.swift
//  BookStory
//
//  Created by Jesus Sanz on 6/2/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm:BooksViewModel
    
    let loading = NotificationCenter.default
        .publisher(for: .loading)
        .compactMap{ $0.object as? Bool }
        .receive(on: RunLoop.main)
    
    var body: some View {
        NavigationStack {
            if vm.search.isEmpty {
                List(vm.books) { book in
                    NavigationLink(value: book) {
                        BookRow(detailVM: DetailViewModel(book: book))
                    }
                }
                .navigationTitle("BookStory")
                .navigationDestination(for: Book.self) { book in
                    BookDetailView(detailVM: DetailViewModel(book: book))
                }
                .refreshable {
                    await vm.getBooks()
                }
            } else {
                List(vm.bookSearch) { book in
                    NavigationLink(value: book) {
                        BookRow(detailVM: DetailViewModel(book: book))
                    }
                }
                .navigationTitle("BookStory")
                .navigationDestination(for: Book.self) { book in
                    BookDetailView(detailVM: DetailViewModel(book: book))
                }
            }
        }
        .searchable(text: $vm.search)
        .onChange(of: vm.search) { newValue in
            if newValue == "" {
                
            } else {
                Task {
                    do {
                        await vm.findBook(search: vm.search)
                    }
                }
            }
        }
        .alert("Connection Error", isPresented: $vm.showAlert) {
            Button(action: {}) {
                Text("OK")
            }
        } message: {
            Text(vm.errorMsg)
        }
        .overlay {
            if vm.loading {
            LoadingView()
                    .transition(.opacity)
            }
        }
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static let vm = BooksViewModel()
    static var previews: some View {
        ContentView()
            .environmentObject(vm)
            .task {
                await vm.getBooks()
            }
    }
}
