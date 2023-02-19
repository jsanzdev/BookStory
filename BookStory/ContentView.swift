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
            List(vm.books) { book in
                NavigationLink(value: book) {
                    BookRow(book: book)
                }
            }
            .navigationTitle("BookStory")
            .navigationDestination(for: Book.self) { book in
                // Add detail view here :)
            }
            .refreshable {
                await vm.getBooks()
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
