//
//  BookRow.swift
//  BookStory
//
//  Created by Jesus Sanz on 19/2/23.
//

import SwiftUI

struct BookRow: View {
    @ObservedObject var detailVM:DetailViewModel
    @EnvironmentObject var vm:BooksViewModel
    
    var body: some View {
        VStack {
            HStack {
                AsyncImage(url: detailVM.book.cover) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Image(systemName: "book.closed.fill")
                        .resizable()
                        .scaledToFit()
                }
                .cornerRadius(10)
                .shadow(radius: 10)
                VStack(alignment: .leading) {
                    Text("\(detailVM.book.title)")
                        .font(.headline)
                    Text("\(detailVM.authorName)")
                        .font(.callout)
                    Text("\(detailVM.book.plot ?? "")")
                        .font(.caption2)
                    Spacer()
                    HStack {
                        RatingView(rating: detailVM.book.rating?.toInt() ?? 0)
                        Spacer()
                        Text("Year: \(detailVM.book.year)")
                    }
                    .font(.caption)
                }
            }
        }
        .frame(height: 110)
        .padding(5)
    }
}

struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        BookRow(detailVM: DetailViewModel(book: .bookTest, booksVM: BooksViewModel()))
            .environmentObject(BooksViewModel())
    }
}
