//
//  LatestView.swift
//  BookStory
//
//  Created by Jesus Sanz on 19/2/23.
//  This is deprecated, we are using a different view inside content view

import SwiftUI

struct LatestView: View {
    @EnvironmentObject var vm:BooksViewModel
    
    let loading = NotificationCenter.default
        .publisher(for: .loading)
        .compactMap{ $0.object as? Bool }
        .receive(on: RunLoop.main)
    
    var body: some View {
        NavigationStack {
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 130))]) {
                    ForEach(vm.latest, id:\.self) { book in
                        NavigationLink(value: book) {
                            BookCover(detailVM: DetailViewModel(book: book, booksVM: vm))
                        }
                    }
                }
                .navigationTitle("Latest Books")
                .navigationDestination(for: Book.self) { book in
                    // Add detail view here :)
                }
                .refreshable {
                    await vm.getLatest()
                }
            }
        }
        .onAppear {
            Task {
                do {
                    await vm.getLatest()
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

struct LatestView_Previews: PreviewProvider {
    static let vm = BooksViewModel()
    static var previews: some View {
        LatestView()
            .environmentObject(vm)
            .task {
                await vm.getLatest()
            }
    }
}
