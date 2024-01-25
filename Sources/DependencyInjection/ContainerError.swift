//
//  ContainerError.swift
//  
//
//  Created by Mykhailo Bondarenko on 25.01.2024.
//

import Foundation

public enum ContainerError: Error {
    case notRegistered(type: Any.Type)
}
