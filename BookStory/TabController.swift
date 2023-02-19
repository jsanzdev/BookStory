//
//  TabView.swift
//  BookStory
//
//  Created by Jesus Sanz on 19/2/23.
//

import SwiftUI

struct TabController: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Store", systemImage: "books.vertical.fill")
                }
            LatestView()
                .tabItem {
                    Label("Latest", systemImage: "book.closed.fill")
                }
            FavoritesView()
                .tabItem {
                    Label("Favourites", systemImage: "star")
                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}

struct TabController_Preview: PreviewProvider {
    static var previews: some View {
        TabController()
            .environmentObject(BooksViewModel())
    }
}
