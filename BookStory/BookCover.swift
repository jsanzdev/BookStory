//
//  BookCover.swift
//  BookStory
//
//  Created by Jesus Sanz on 25/2/23.
//

import SwiftUI

struct BookCover: View {
    @ObservedObject var detailVM:DetailViewModel
    @EnvironmentObject var vm:BooksViewModel
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
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
                ZStack {
                    Rectangle()
                        .frame(height: 30)
                        .foregroundColor(.red)
                        .opacity(0.8)
                        .shadow(radius: 20)
                        .cornerRadius(10)
                    Text("\(detailVM.book.price, specifier: "%.2f")$")
                        .font(.title3)
                        .foregroundColor(.white)
                        .bold()
                }
                .padding()
                
            }
            
        }
        .padding(5)
    }
}

struct BookCover_Previews: PreviewProvider {
    static var previews: some View {
        BookCover(detailVM: DetailViewModel(book: .bookTest, booksVM: BooksViewModel()))
            .environmentObject(BooksViewModel())
    }
}
