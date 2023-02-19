//
//  NetworkInterface.swift
//  BookStory
//
//  Created by Jesus Sanz on 9/2/23.
//

import Foundation

extension Notification.Name {
    static let loading = Notification.Name("LOADINGSCREEN")
}

enum APIErrors:Error {
    case general(Error)
    case json(Error)
    case nonHTTP
    case status(Int)
    case invalidData
    
    var description:String {
        switch self {
        case .general(let error):
            return "General error: \(error)."
        case .json(let error):
            return "JSON Error: \(error)."
        case .nonHTTP:
            return "Non HTTP connection."
        case .status(let int):
            return "Status error: Code \(int)."
        case .invalidData:
            return "Invalid data."
        }
    }
}

enum HTTPMethod:String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

let serverURL = URL.productionServer

extension URL {
    static let productionServer = URL(string: "https://trantorapi-acacademy.herokuapp.com/api")!
    static let bookAPI = "books"
    static let getBooks = serverURL.appending(component: "\(bookAPI)").appending(component: "list")
    static let getLatest = serverURL.appending(component: "books/latest")
    
    static func findBook(search:String) -> URL {
        serverURL.appending(component: "find").appending(component: "\(search.lowercased())")
    }
}


extension URLRequest {
    static func request(url:URL, method:HTTPMethod = .get) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    static func request<T:Codable>(url:URL, method:HTTPMethod, body:T) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = try? JSONEncoder().encode(body)
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
