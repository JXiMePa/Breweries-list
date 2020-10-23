//
//  BreweriesListService.swift
//  Breweries list
//
//  Created by Tarasenko Jurik on 23.10.2020.
//  Copyright © 2020 Tarasenko Yurii. All rights reserved.
//

import Foundation

struct BreweriesListService {
    
    static func getData(searchName: String = "", completion: @escaping (Result<[Brewery], Error>) -> Void) {
        let searchEndpoint = "breweries?by_name=\(searchName.replacingOccurrences(of: " ", with: "%20"))"
        let endpoint = searchName == "" ? "breweries" : searchEndpoint
        NetworkController.get(endpoint: endpoint) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    do {
                        let models = try JSONDecoder.mainDecoder.decode([Brewery].self, from: data)
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
}
