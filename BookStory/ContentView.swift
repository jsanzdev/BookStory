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
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Latest Books")
                        .font(.title2)
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: [GridItem(.adaptive(minimum:90))]) {
                            ForEach(vm.latest, id:\.self) { book in
                                NavigationLink(value: book) {
                                    BookCover(detailVM: DetailViewModel(book: book, booksVM: vm))
                                }
                            }
                        }
                    }
                    .frame(height: 150)
                }
                .padding()
                LazyVStack {
                    if vm.search.isEmpty {
                        ForEach(vm.books, id:\.self) { book in
                            NavigationLink(value: book) {
                                BookRow(detailVM: DetailViewModel(book: book, booksVM: vm))
                            }
                        }
                    } else {
                        ForEach(vm.bookSearch, id:\.self) { book in
                            NavigationLink(value: book) {
                                BookRow(detailVM: DetailViewModel(book: book, booksVM: vm))
                            }
                        }
                    }
                }
                .padding()
                .buttonStyle(.plain)
            }
            .navigationTitle("BookStory")
            .navigationDestination(for: Book.self) { book in
                BookDetailView(detailVM: DetailViewModel(book: book, booksVM: vm))
            }
        }
        .refreshable {
            await vm.getBooks()
            await vm.getLatest()
        }
        .searchable(text: $vm.search)
        .onAppear {
            Task {
                do {
                    await vm.getLatest()
                    await vm.getBooks()
                }
            }
        }
        .onChange(of: vm.search) { newValue in
            if newValue != "" {
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
