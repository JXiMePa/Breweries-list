//
//  NetworkController.swift
//  Breweries list
//
//  Created by Tarasenko Jurik on 22.10.2020.
//  Copyright © 2020 Tarasenko Yurii. All rights reserved.
//

import UIKit

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case notFound
    case unknown
}

enum HTTPMethod: String {
    case get
}

struct NetworkController {
    
    typealias NetworkResult = (Result<Data, NetworkError>) -> Void
    private static let baseUrl = "https://api.openbrewerydb.org/"
    
    public static func get(endpoint: String, callback: @escaping NetworkResult) {
        request(endpoint: endpoint, method: .get, callback: callback)
    }
    
    private static func request(endpoint: String, method: HTTPMethod, params: [String: Any]? = nil, callback: @escaping NetworkResult) {
        guard let url = URL(string: "\(baseUrl)\(endpoint)") else {
            callback(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let params = params,
            let body = try? JSONSerialization.data(withJSONObject: params) {
            request.httpBody = body
        }
        let urlConfig = URLSessionConfiguration.default
        urlConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        urlConfig.urlCache = nil

        let session = URLSession(configuration: urlConfig)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                callback(.failure(.invalidResponse))
                return
            }
            guard let response = response as? HTTPURLResponse,
                let data = data else {
                    callback(.failure(.invalidResponse))
                    return
            }
            switch response.statusCode {
            case 200...299:
                callback(.success(data))
            case 404:
                callback(.failure(.notFound))
            default:
                callback(.failure(.unknown))
            }
        }
        task.resume()
    }
}
