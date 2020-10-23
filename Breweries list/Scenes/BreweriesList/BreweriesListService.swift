//
//  BreweriesListService.swift
//  Breweries list
//
//  Created by Tarasenko Jurik on 23.10.2020.
//  Copyright © 2020 Tarasenko Yurii. All rights reserved.
//

import Foundation

struct BreweriesListService {
    
    static func getData(_ completion: @escaping (Result<[Brewery], Error>) -> Void) {
        NetworkController.get(endpoint: "breweries") { result in
            switch result {
            case .success(let data):
                do {
                    let models = try JSONDecoder.mainDecoder.decode([Brewery].self, from: data)
                    RealmManager<Brewery>.deleteAllObjects()
                    let realmModels = models.map { RealmManager<Brewery>.toRealm($0) }
                    completion(.success(realmModels))
                } catch (let error) {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
