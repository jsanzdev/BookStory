//
//  BookDetailView.swift
//  BookStory
//
//  Created by Jesus Sanz on 19/2/23.
//

import SwiftUI

struct BookDetailView: View {
    @EnvironmentObject var booksVM:BooksViewModel
    @ObservedObject var detailVM:DetailViewModel
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    ZStack (alignment: .bottom) {
                        HStack {
                            AsyncImage(url: detailVM.book.cover) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130)
                            } placeholder: {
                                Image(systemName: "book.closed.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 130)
                            }
                            .cornerRadius(10)
                            .shadow(radius:10)
                            VStack (alignment: .leading){
                                Text("\(detailVM.authorName)")
                                    .font(.title)
                                Text("\(detailVM.book.price, specifier: "%.2f")$")
                                    .font(.title)
                                Spacer()
                                Text("Year: \(detailVM.book.year)")
                                Text("Pages: \(detailVM.book.pages ?? 0)")
                                RatingView(rating: detailVM.book.rating?.toInt() ?? 0)
                            }
                        }
                    }
                    Text("Summary")
                        .font(.title)
                    Text("\(detailVM.book.summary ?? "No summary found")")
                }
            }
        }
        .padding()
        .navigationTitle(detailVM.book.title)
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BookDetailView(detailVM: DetailViewModel(book: .bookTest, booksVM: BooksViewModel()))
                .environmentObject(BooksViewModel())
        }
    }
}
