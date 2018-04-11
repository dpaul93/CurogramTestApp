//
//  ListPresenter.swift
//  CurogramTestApp
//
//  Created Pavlo Deynega on 10.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation

// MARK: - Output

protocol ListPresenterOutput: class {
    func handleDataDidUpdate()
}

// MARK: - Protocol

protocol ListPresenter: class {
    var output: ListPresenterOutput? { get set }
    var viewModels: [ListTableViewCellViewModel] { get }
    
    func handleAddNumber(with progress: @escaping (Double) -> ())
    func handleRemoveNumber(with viewModel: ListTableViewCellViewModel)
    func hasItemsToRestore() -> Bool
    func handleRestoreNumber(with progress: @escaping (Double) -> ())
}

// MARK: - Implementation

private final class ListPresenterImpl: ListPresenter, ListInteractorOutput {
    private let interactor: ListInteractor
    private let router: ListRouter
    
    weak var output: ListPresenterOutput?
    var viewModels = [ListTableViewCellViewModel]()
    
    init(
        interactor: ListInteractor,
        router: ListRouter
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - ListPresenter
    
    func handleAddNumber(with progress: @escaping (Double) -> ()) {
        interactor.handleAddNumber { [weak self] (currentProgress, isFinished, number) in
            if isFinished {
                self?.updateViewModels()
                self?.output?.handleDataDidUpdate()
            }
            progress(currentProgress)
        }
    }
    
    func handleRemoveNumber(with viewModel: ListTableViewCellViewModel) {
        interactor.handleRemoveNumber(with: viewModel) { [weak self] _ in
            self?.updateViewModels()
            self?.output?.handleDataDidUpdate()
        }
    }
    
    func hasItemsToRestore() -> Bool {
        return interactor.hasItemsToRestore()
    }
    
    func handleRestoreNumber(with progress: @escaping (Double) -> ()) {
        interactor.handleRestoreNumber { [weak self] (currentProgress, isFinished, number) in
            if isFinished {
                self?.updateViewModels()
                self?.output?.handleDataDidUpdate()
            }
            progress(currentProgress)
        }
    }
    
    // MARK: - Helpers
    
    private func updateViewModels() {
        let count = interactor.numbers.count
        viewModels = interactor.numbers.enumerated().map { (offset, number) in
            return ListTableViewCellViewModelFactory.default(
                value: number.value,
                position: "\(offset + 1)/\(count)",
                color: number.color,
                id: number.id
            )
        }
    }
}

// MARK: - Factory

final class ListPresenterFactory {
    static func `default`(
        interactor: ListInteractor = ListInteractorFactory.default(),
        router: ListRouter
    ) -> ListPresenter {
        let presenter = ListPresenterImpl(
            interactor: interactor,
            router: router
        )
        interactor.output = presenter
        return presenter
    }
}
