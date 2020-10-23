//
//  RealmManager.swift
//  Breweries list
//
//  Created by Tarasenko Jurik on 22.10.2020.
//  Copyright © 2020 Tarasenko Yurii. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmManager<T: Object & RealmObject> {
    
    @discardableResult static func toRealm(_ object: T) -> T {
        let realm = try! Realm()
        let optionalObject = realm.objects(T.self).filter("id == %@", object.id).first
        var updatedObject: T
        
        if let existingObject = optionalObject {
            updatedObject = existingObject
            try! realm.write {
                existingObject.update(with: object, in: realm)
                realm.add(updatedObject, update: .all)
            }
        } else {
            updatedObject = object
            try! realm.write {
                realm.add(updatedObject, update: .all)
            }
        }
        return updatedObject
    }
    
    static func allObjects() -> [T] {
        let realm = try! Realm()
        return realm.objects(T.self).map {$0}
    }
    
    static func deleteAllObjects() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(T.self))
        }
    }
}
