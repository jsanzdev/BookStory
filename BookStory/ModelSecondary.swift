//
//  ModelSecondary.swift
//  BookStory
//
//  Created by Jesus Sanz on 5/3/23.
//

import Foundation

enum DetailField {
    case name, email, location
    
    mutating func next() {
        switch self {
        case .name:
            self = .email
        case .email:
            self = .location
        case .location:
            self = .name
        }
    }
    
    mutating func prev() {
        switch self {
        case .name:
            self = .location
        case .location:
            self = .email
        case .email:
            self = .name
        }
    }
}
