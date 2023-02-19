//
//  AppOfflineView.swift
//  BookStory
//
//  Created by Jesus Sanz on 19/2/23.
//

import SwiftUI

struct AppOfflineView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.regularMaterial)
                .ignoresSafeArea()
            VStack {
                Text("No Network Connection")
                    .font(.headline)
                Text("App requires internet connection to work")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct AppOfflineView_Previews: PreviewProvider {
    static var previews: some View {
        AppOfflineView()
    }
}
