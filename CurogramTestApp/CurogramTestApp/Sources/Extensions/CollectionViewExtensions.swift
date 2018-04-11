//
//  CollectionViewExtensions.swift
//  CurogramTestApp
//
//  Created by Pavlo Deynega on 10.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import UIKit

extension UICollectionReusableView {
    static func nib() -> UINib {
        return UINib(nibName: self.className, bundle: nil)
    }
    
    static func reuseIdentifier() -> String {
        return className
    }
}

extension UITableViewCell {
    static func nib() -> UINib {
        return UINib(nibName: self.className, bundle: nil)
    }
    
    static func reuseIdentifier() -> String {
        return className
    }
}
