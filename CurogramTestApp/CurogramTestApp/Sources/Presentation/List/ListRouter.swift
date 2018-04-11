//
//  ListRouter.swift
//  CurogramTestApp
//
//  Created Pavlo Deynega on 10.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Protocol

protocol ListRouter {
    
}

// MARK: - Implementation

private final class ListRouterImpl: NavigationRouter, ListRouter {
    
}

// MARK: - Factory

final class ListRouterFactory {
    static func `default`(
        navigationController: UINavigationController
    ) -> ListRouter {
        return ListRouterImpl(
            with: navigationController
        )
    }
}
