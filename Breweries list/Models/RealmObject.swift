//
//  RealmObject.swift
//  Breweries list
//
//  Created by Tarasenko Jurik on 22.10.2020.
//  Copyright © 2020 Tarasenko Yurii. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmObject {
    
    typealias T = Object & RealmObject
    var id: Int { get set }
    
    @discardableResult func update<T: Object & RealmObject>(with item: T, in realm: Realm) -> T
}

extension RealmObject {

    static func == (left: RealmObject, right: RealmObject) -> Bool {
        return left.id == right.id
    }
}
