//
//  Storyboard+Extensions.swift
//  Breweries list
//
//  Created by Tarasenko Jurik on 23.10.2020.
//  Copyright © 2020 Tarasenko Yurii. All rights reserved.
//

import UIKit

enum Storyboards: String {
    case main = "Main"
    case map = "Map"
}

extension UIViewController {
    class func instance(_ storyboard: Storyboards = .main) -> Self {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let viewController = storyboard.instantiateViewController(self)
        return viewController
    }
}

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(_ type: T.Type) -> T {
        let id = NSStringFromClass(T.self).components(separatedBy: ".").last!
        return self.instantiateViewController(withIdentifier: id) as! T
    }
}
