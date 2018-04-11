//
//  NumbersService.swift
//  CurogramTestApp
//
//  Created by Pavlo Deynega on 10.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation

typealias NumbersServiceProgress = (_ progress: Double, _ isFinished: Bool, _ number: NumberDTO) -> ()

// MARK: - Protocol

protocol NumbersService {
    var numbers: [NumberDTO] { get }
    
    func addNumber(progress: @escaping NumbersServiceProgress)
    func deleteNumber(with viewModel: ListTableViewCellViewModel, completion:  ((Bool) -> ())?)
    func hasItemsToRestore() -> Bool
    func restoreNumber(progress: @escaping NumbersServiceProgress)
}

// MARK: - Implementation

private final class NumbersServiceImpl: NumbersService {
    var numbers: [NumberDTO]

    private let delayDuration: Double
    private let tickInterval: TimeInterval
    private var removed: [NumberDTO]
    private let generator: UniqueIDGenerator
    
    init(
        delayDuration: Double,
        tickInterval: TimeInterval,
        numbers: [NumberDTO],
        removed: [NumberDTO],
        generator: UniqueIDGenerator
    ) {
        self.delayDuration = delayDuration
        self.tickInterval = tickInterval
        self.numbers = numbers
        self.removed = removed
        self.generator = generator
    }
    
    // MARK: - NumbersService
    
    func addNumber(progress: @escaping NumbersServiceProgress) {
        let color = randomHex()
        let presentNumbers = numbers.map { return $0.id }
        let number = NumberDTO(value: Int(arc4random_uniform(100)), id: generator.generateID(from: presentNumbers), color: color)
        
        instantiateDelay(with: number) { [weak self] (currentProgress, isFinished, number) in
            if isFinished {
                self?.addNumber(number: number) { progress(currentProgress, $0, number) }
            } else {
                progress(currentProgress, isFinished, number)
            }
        }
    }
    
    func deleteNumber(with viewModel: ListTableViewCellViewModel, completion: ((Bool) -> ())?) {
        guard let number = numbers.filter ({ $0.id == viewModel.id }).first else {
            completion?(false)
            return
        }
        deleteNumber(number: number) { completion?($0) }
    }
    
    func hasItemsToRestore() -> Bool {
        return removed.count > 0
    }
    
    func restoreNumber(progress: @escaping NumbersServiceProgress) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let last = self?.removed.last else { return }
            self?.removed.removeLast()
            
            DispatchQueue.main.async {
                self?.instantiateDelay(with: last) { [weak self] (currentProgress, isFinished, number) in
                    if isFinished {
                        self?.addNumber(number: number) { progress(currentProgress, $0, number) }
                    } else {
                        progress(currentProgress, isFinished, number)
                    }
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func instantiateDelay(with number: NumberDTO, completion: @escaping NumbersServiceProgress) {
        var currentProgress = 0.0
        Timer.scheduledTimer(withTimeInterval: tickInterval, repeats: true) { [weak self] timer in
            guard let strongSelf = self else {
                timer.invalidate()
                return
            }
            
            let isFinished = currentProgress >= strongSelf.delayDuration
            let percentage = currentProgress / strongSelf.delayDuration
            completion(percentage, isFinished, number)
            
            if isFinished{
                timer.invalidate()
            } else {
                currentProgress += strongSelf.tickInterval
            }
        }
    }
    
    private func addNumber(number: NumberDTO, completion: @escaping (Bool) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            strongSelf.numbers.append(number)
            strongSelf.numbers = strongSelf.numbers.sorted(by: { $0.value < $1.value })
            
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
    
    private func deleteNumber(number: NumberDTO, completion: @escaping (Bool) -> ()) {
        let failure = {
            DispatchQueue.main.async {
                completion(false)
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let strongSelf = self else {
                failure()
                return
            }

            if let index = strongSelf.numbers.index(where: ({ $0.id == number.id })) {
                strongSelf.numbers.remove(at: index)
                strongSelf.removed.append(number)
                
                DispatchQueue.main.async {
                    completion(true)
                }
            } else {
                failure()
            }
        }
    }
    
    private func randomHex() -> String {
        let colors = ["232637", "30e3b7", "3BE5A3", "42E695", "1BE1E1", "9BA4BF", "B5B5B5", "FBDA61", "FF5ACD", "FE78B3", "3B5998", "000105", "D4D9E3", "c3c8d9", "9BA4C0", "FE78B3"]
        return colors[safe: Int(arc4random_uniform(UInt32(colors.count)))] ?? "FFFFFF"
    }
}

// MARK: - Factory

class NumbersServiceFactory {
    static func `default`(
        delayDuration: Double = 2.0,
        tickInterval: TimeInterval = 0.1,
        numbers: [NumberDTO] = [],
        removed: [NumberDTO] = [],
        generator: UniqueIDGenerator = UniqueIDGeneratorFactory.default()
    ) -> NumbersService {
        return NumbersServiceImpl(
            delayDuration: delayDuration,
            tickInterval: tickInterval,
            numbers: numbers,
            removed: removed,
            generator: generator
        )
    }
}
