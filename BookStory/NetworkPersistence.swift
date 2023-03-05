//
//  Network.swift
//  BookStory
//
//  Created by Jesus Sanz on 9/2/23.
//

import SwiftUI

final class NetworkPersistence {
    static let shared = NetworkPersistence()
    
    func getBooks() async throws -> [Book] {
        try await queryJSON(request: .request(url: .getBooks), type: [Book].self)
    }
    
    func getLatest() async throws -> [Book] {
        try await queryJSON(request: .request(url: .getLatest), type: [Book].self)
    }
    
    func getAuthors() async throws -> [Author] {
        try await queryJSON(request: .request(url: .getAuthors), type: [Author].self)
    }

    func findBooks(search:String) async throws -> [Book] {
        try await queryJSON(request: .request(url: .findBook(search: search)), type: [Book].self)
    }
    
    func findAuthor(id:String) async throws -> Author {
        try await queryJSON(request: .request(url: .findAuthor(id: id)), type: Author.self)
    }
    
    func getUser(email:String) async throws -> User {
        let user = User(email: email)
        return try await queryJSON(request: .request(url: .findUser, method: .post, body: user), type: User.self)
    }
    
    func createUser(user: User) async throws -> Bool {
        try await queryJSON(request: .request(url: .user, method: .post, body: user))
    }
    
//    func getReadBooks(email: String) async throws -> [Book] {
//        let readBooks:[Int] = []
//        try await queryJSON(request: .request(url: .getReadBooks), type: readBooks.self)
//    }
    
    
    func queryJSON<T:Codable>(request:URLRequest, type:T.Type, decoder:JSONDecoder = JSONDecoder(), statusOK:Int = 200) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw APIErrors.nonHTTP }
            if response.statusCode == statusOK {
                do {
                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw APIErrors.json(error)
                }
            } else {
                throw APIErrors.status(response.statusCode)
            }
        } catch let error as APIErrors {
            throw error
        } catch {
            throw APIErrors.general(error)
        }
    }
    
    func queryJSON(request:URLRequest, statusOK:Int = 200) async throws -> Bool {
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else { throw APIErrors.nonHTTP }
            if response.statusCode == statusOK {
                return true
            } else {
                throw APIErrors.status(response.statusCode)
            }
        } catch let error as APIErrors {
            throw error
        } catch {
            throw APIErrors.general(error)
        }
    }
}
