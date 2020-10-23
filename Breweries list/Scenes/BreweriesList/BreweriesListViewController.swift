//
//  BreweriesListViewController.swift
//  Breweries list
//
//  Created by Tarasenko Jurik on 22.10.2020.
//  Copyright © 2020 Tarasenko Yurii. All rights reserved.
//

import UIKit

final class BreweriesListViewController: BaseViewController {
    
    private var breweries = [Brewery]() {
        didSet { print(breweries.count) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    private func loadData() {
        if let models = RealmManager<Brewery>.allObjects() {
            breweries =  models
        }
        BreweriesListService.getData { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let models):
                    self.breweries = models
                case .failure(let error):
                    self.showAlert()
                    print(error)
                }
            }
        }
    }
    
}

