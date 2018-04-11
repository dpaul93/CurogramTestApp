//
//  AppDelegateRouter.swift
//  CurogramTestApp
//
//  Created by Pavlo Deynega on 10.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import UIKit

// MARK: Protocol

protocol AppDelegateRouter {
    func routeToList()
}

// MARK: Implementation

private final class AppDelegateRouterImpl: AppDelegateRouter {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - AppDelegateRouter
    
    func routeToList() {
        guard let navController = window.rootViewController as? UINavigationController else { return }
        let router = ListRouterFactory.default(navigationController: navController)
        let presenter = ListPresenterFactory.default(router: router)
        if let controller = ListViewControllerFactory.new(presenter: presenter) {
            navController.setViewControllers([controller], animated: false)
        }
    }
}

// MARK: Factory

class AppDelegateRouterFactory {
    static func `default`(window: UIWindow) -> AppDelegateRouter {
        return AppDelegateRouterImpl(window: window)
    }
}
