//
//  BreweriesListViewController.swift
//  Breweries list
//
//  Created by Tarasenko Jurik on 22.10.2020.
//  Copyright © 2020 Tarasenko Yurii. All rights reserved.
//

import UIKit

final class BreweriesListViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: Property
    private var breweries = [Brewery]() {
        didSet { tableView.reloadData() }
    }
    private var refreshControl: UIRefreshControl?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
        setupRefreshControl()
    }
    
    private func setupUI() {
        breweries = RealmManager<Brewery>.allObjects()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        tableView.register(UINib(nibName: BreweryCell.identifier, bundle: nil), forCellReuseIdentifier: BreweryCell.identifier)
        tableView.refreshControl = refreshControl
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
            tableView.addSubview(refreshControl)
        }
    }
    
    @objc private func loadData() {
        BreweriesListService.getData { [weak self] result in
            guard let self = self else { return }
            self.refreshControl?.endRefreshing()
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

//MARK: - UISearchBarDelegate
extension BreweriesListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

//MARK: - UITableViewDataSource
extension BreweriesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breweries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BreweryCell.identifier, for: indexPath) as! BreweryCell
        cell.configure(breweries[indexPath.row])
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension BreweriesListViewController: UITableViewDelegate {
    
}
