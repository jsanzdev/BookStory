//
//  TabView.swift
//  BookStory
//
//  Created by Jesus Sanz on 19/2/23.
//

import SwiftUI

struct TabController: View {
    @EnvironmentObject var booksVM:BooksViewModel
    
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Store", systemImage: "books.vertical.fill")
                }
            ReadView()
                .tabItem {
                    Label("Read", systemImage: "bookmark.fill")
                }
            UserView(userVM: UserViewModel(user: booksVM.user))
                .tabItem {
                    Label("Account", systemImage: "person.fill")
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
