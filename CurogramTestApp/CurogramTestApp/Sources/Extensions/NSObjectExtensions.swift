//
//  NSObjectExtensions.swift
//  CurogramTestApp
//
//  Created by Pavlo Deynega on 10.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return String(describing: self)
    }
}
