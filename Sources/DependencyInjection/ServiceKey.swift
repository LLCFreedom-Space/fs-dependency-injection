//
//  ServiceKey.swift
//  
//
//  Created by Mykhailo Bondarenko on 25.01.2024.
//

import Foundation

struct ServiceKey: Hashable {
    let type: Any.Type
    
    func hash(into hasher: inout Hasher) {
        hasher.combine("\(type)")
    }
    
    static func == (lhs: ServiceKey, rhs: ServiceKey) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
