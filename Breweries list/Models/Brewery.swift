//
//  Brewery.swift
//  Breweries list
//
//  Created by Tarasenko Jurik on 22.10.2020.
//  Copyright © 2020 Tarasenko Yurii. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

final class Brewery: Object, Codable, RealmObject {
    
    @objc dynamic var id = Int()
    @objc dynamic var name: String?
    @objc dynamic var street: String?
    @objc dynamic var city: String?
    @objc dynamic var state: String?
    @objc dynamic var country: String?
    @objc dynamic var longitude: String?
    @objc dynamic var latitude: String?
    @objc dynamic var phone: String?
    @objc dynamic var websiteUrl: String?
    
    override class func primaryKey() -> String? { return "id" }
    
    func update<T>(with item: T, in realm: Realm) -> T where T: Object, T : RealmObject {
        guard let updatedItem = item as? Brewery else { return item }
        self.name = updatedItem.name
        self.street = updatedItem.street
        self.city = updatedItem.city
        self.state = updatedItem.state
        self.country = updatedItem.country
        self.longitude = updatedItem.longitude
        self.latitude = updatedItem.latitude
        self.phone = updatedItem.phone
        self.websiteUrl = updatedItem.websiteUrl
        return self as! T
    }
    
}
