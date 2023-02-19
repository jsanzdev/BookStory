//
//  Extensions.swift
//  BookStory
//
//  Created by Jesus Sanz on 19/2/23.
//

import Foundation

extension Double {
    
    func toInt() -> Int? {
        let roundedValue = rounded(.toNearestOrEven)
        return Int(exactly: roundedValue)
    }
    
}
