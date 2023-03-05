//
//  UserViewModel.swift
//  BookStory
//
//  Created by Jesus Sanz on 4/3/23.
//

import SwiftUI

final class UserViewModel:ObservableObject {
    
    let persistence = NetworkPersistence.shared
    
    @Published var showAlert = false
    @Published var errorMsg = ""
    
    @Published var loading = false
    
    @Published var user:User
    
    @Published var email = ""
    @Published var name = ""
    @Published var location = ""
    //@Published var readBooks:Books = []
    
    init(user:User) {
        self.user = user
        email = user.email
        name = user.name ?? ""
        location = user.location ?? ""
    }
    
}
