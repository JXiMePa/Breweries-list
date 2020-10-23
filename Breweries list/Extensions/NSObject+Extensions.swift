//
//  NSObject+Extensions.swift
//  Breweries list
//
//  Created by Tarasenko Jurik on 22.10.2020.
//  Copyright © 2020 Tarasenko Yurii. All rights reserved.
//

import Foundation

extension NSObject {
    
    class var identifier: String {
        return String(describing: self)
    }
}
