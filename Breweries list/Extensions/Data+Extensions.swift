//
//  Data+Extensions.swift
//  Breweries list
//
//  Created by Tarasenko Jurik on 22.10.2020.
//  Copyright © 2020 Tarasenko Yurii. All rights reserved.
//

import Foundation

extension Data {
    
    func printJSON() {
        if let jsonString = String(data: self, encoding: .utf8) {
            print(jsonString)
        }
    }
}
