//
//  ListInteractor.swift
//  CurogramTestApp
//
//  Created Pavlo Deynega on 10.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation

// MARK: - Output

protocol ListInteractorOutput: class {}

// MARK: - Protocol

protocol ListInteractor: class {
    var output: ListInteractorOutput? { get set }
    var numbers: [NumberDTO] { get }
    
    func handleAddNumber(_ completion: @escaping NumbersServiceProgress)
    func handleRemoveNumber(with viewModel: ListTableViewCellViewModel, completion: @escaping (Bool) -> ())
    func hasItemsToRestore() -> Bool
    func handleRestoreNumber(completion: @escaping NumbersServiceProgress)
}

// MARK: - Implementation

private final class ListInteractorImpl: ListInteractor {
    weak var output: ListInteractorOutput?
    var numbers: [NumberDTO] {
        return numbersService.numbers
    }
    private let numbersService: NumbersService
    
    init(numbersService: NumbersService) {
        self.numbersService = numbersService
    }
    
    // MARK: - ListInteractor
    
    func handleAddNumber(_ completion: @escaping NumbersServiceProgress) {
        numbersService.addNumber(progress: completion)
    }
    
    func handleRemoveNumber(with viewModel: ListTableViewCellViewModel, completion: @escaping (Bool) -> ()) {
        numbersService.deleteNumber(with: viewModel, completion: completion)
    }
    
    func hasItemsToRestore() -> Bool {
        return numbersService.hasItemsToRestore()
    }
    
    func handleRestoreNumber(completion: @escaping NumbersServiceProgress) {
        numbersService.restoreNumber(progress: completion)
    }
}

// MARK: - Factory

final class ListInteractorFactory {
    static func `default`(
        numbersService: NumbersService = NumbersServiceFactory.default()
    ) -> ListInteractor {
        return ListInteractorImpl(numbersService: numbersService)
    }
}
