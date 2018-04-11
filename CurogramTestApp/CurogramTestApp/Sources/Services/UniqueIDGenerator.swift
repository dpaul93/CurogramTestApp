//
//  UniqueIDGenerator.swift
//  CurogramTestApp
//
//  Created by Pavlo Deynega on 10.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation

// MARK: - Protocol

protocol UniqueIDGenerator {
    func generateID(from array: [Int]) -> Int
}

// MARK: - Implementation

private final class UniqueIDGeneratorImpl: UniqueIDGenerator {
    func generateID(from array: [Int]) -> Int {
        var id = Int(arc4random())
        
        while array.contains(id) {
            id = Int(arc4random())
        }
        
        return id
    }
}

// MARK: - Factory

class UniqueIDGeneratorFactory {
    static func `default`() -> UniqueIDGenerator {
        return UniqueIDGeneratorImpl()
    }
}
