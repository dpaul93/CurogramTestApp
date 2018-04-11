//
//  StoryboardExtensions.swift
//  CurogramTestApp
//
//  Created by Pavlo Deynega on 06.04.18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import UIKit

extension UIStoryboard {
    enum ViewController: String {
        case list = "ListViewController"
    }
    
    static func main() -> UIStoryboard {
        return UIStoryboard.init(name: "Main", bundle: nil)
    }
    
    static func instantiateViewController(type: ViewController) -> UIViewController? {
        return main().instantiateViewController(withIdentifier: type.rawValue)
    }
}
