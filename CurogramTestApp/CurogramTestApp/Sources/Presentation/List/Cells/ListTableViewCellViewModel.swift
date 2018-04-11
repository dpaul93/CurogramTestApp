//
//  ListTableViewCellViewModel.swift
//  CurogramTestApp
//
//  Created by Pavlo Deynega on 10.04.18.
//Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation

// MARK: Protocol

protocol ListTableViewCellViewModel {
    var value: Int { get }
    var position: String { get }
    var color: String { get }
    var id: Int { get }
}

// MARK: Implementation

private class ListTableViewCellViewModelImpl: ListTableViewCellViewModel {
    let value: Int
    let position: String
    let color: String
    let id: Int
    
    init(
        value: Int,
        position: String,
        color: String,
        id: Int
    ) {
        self.value = value
        self.position = position
        self.color = color
        self.id = id
    }
}

// MARK: Factory

class ListTableViewCellViewModelFactory {
    static func `default`(
        value: Int,
        position: String,
        color: String,
        id: Int
    ) -> ListTableViewCellViewModel {
        return ListTableViewCellViewModelImpl(
            value: value,
            position: position,
            color: color,
            id: id
        )
    }
}

