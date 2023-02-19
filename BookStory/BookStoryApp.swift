//
//  BookStoryApp.swift
//  BookStory
//
//  Created by Jesus Sanz on 6/2/23.
//

import SwiftUI
import WebKit

@main
struct BookStoryApp: App {
    @StateObject var booksVM = BooksViewModel()
    @StateObject var monitorNetwork = NetworkStatus()
    
    var body: some Scene {
        WindowGroup {
            VStack {
                TabController()
            }
            .overlay {
                if monitorNetwork.status == .offline {
                    AppOfflineView()
                        .transition(.opacity)
                }
            }
            .task {
                await booksVM.getBooks()
            }
            .animation(.default, value: monitorNetwork.status)
            .environmentObject(booksVM)
        }
    }
}
