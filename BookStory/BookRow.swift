//
//  BookRow.swift
//  BookStory
//
//  Created by Jesus Sanz on 19/2/23.
//

import SwiftUI

struct BookRow: View {
    @ObservedObject var detailVM:DetailViewModel
    
    var body: some View {
        HStack {
            AsyncImage(url: detailVM.book.cover) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70)
            } placeholder: {
                Image(systemName: "book.closed.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
            }
            VStack(alignment: .leading) {
                Text("\(detailVM.book.title)")
                    .font(.headline)
                Text("\(detailVM.author)")
                    .font(.caption)
            }
        }
    }
}

struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        BookRow(detailVM: DetailViewModel(book: .bookTest))
    }
}
