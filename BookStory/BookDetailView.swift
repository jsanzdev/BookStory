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
    
    var readedIcon:String {
        if booksVM.isReaded(id: detailVM.book.id) {
            return "bookmark.fill"
        } else {
            return "bookmark.slash"
        }
    }
    
    @State var showAlert = false
    @State var alertMsg = ""
    
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
                                HStack {
                                    Text("\(detailVM.authorName)")
                                        .font(.title)
                                    Spacer()
                                    Button {
                                        Task {
                                            do {
                                                if await booksVM.readBookToggle(id: detailVM.book.id) {
                                                    await booksVM.getReadBooks()
                                                } else {
                                                    showAlert.toggle()
                                                    alertMsg = "Error, try again later"
                                                }
                                            }
                                            
                                        }
                                    } label: {
                                        Image(systemName: "\(readedIcon)")
                                            .font(.system(size: 40, weight: .bold))
                                    }
                                    
                                }
                                Text("\(detailVM.book.price, specifier: "%.2f")$")
                                    .font(.title)
                                Spacer()
                                Text("Year: \(detailVM.book.year)")
                                Text("Pages: \(detailVM.book.pages ?? 0)")
                                HStack {
                                    RatingView(rating: detailVM.book.rating?.toInt() ?? 0)
                                        .font(.system(size: 20))
                                }
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
