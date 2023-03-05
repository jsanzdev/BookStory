//
//  ModelOperations.swift
//  BookStory
//
//  Created by Jesus Sanz on 5/3/23.
//

import Foundation


struct UserQuery:Codable {
    var email:String?
}

struct UserUpdate:Codable {
    var name:String?
    var email:String
    var location:String?
    var role:userRole?
}
