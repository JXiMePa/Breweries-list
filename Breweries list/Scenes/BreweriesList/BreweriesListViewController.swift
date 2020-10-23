//
//  BreweriesListViewController.swift
//  Breweries list
//
//  Created by Tarasenko Jurik on 22.10.2020.
//  Copyright © 2020 Tarasenko Yurii. All rights reserved.
//

import UIKit
import SafariServices

final class BreweriesListViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: Property
    private var breweries = [Brewery]() {
        didSet { tableView.reloadData() }
    }
    private var breweriesSearchResult = [Brewery]() {
        didSet { tableView.reloadData() }
    }
    private var currentData: [Brewery] {
        return breweriesSearchResult.isEmpty ? breweries : breweriesSearchResult
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
        if #available(iOS 13.0, *) {
           searchBar.searchTextField.backgroundColor = .white
        }
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
        if searchText == "" {
            breweriesSearchResult.removeAll()
        }
        
        guard Connectivity.isConnectedToInternet() else {
            breweriesSearchResult = breweries.filter({ brewery -> Bool in
                return brewery.name?.contains(searchText) ?? false
            })
            return
        }
        
        BreweriesListService.getData(searchName: searchText) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let models):
                self.breweriesSearchResult = models
            case .failure(let error):
                self.showAlert()
                print(error)
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension BreweriesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BreweryCell.identifier, for: indexPath) as! BreweryCell
        cell.configure(currentData[indexPath.row])

        cell.showOnMapDidTap = { [weak self] in
            guard let self = self else { return }
            let mapViewController = MapViewController.instance(.map)
            self.navigationController?.pushViewController(mapViewController, animated: true)
        }
        cell.webSiteDidTap = { [weak self] urlString in
            guard let self = self,
                let url = URL(string: urlString) else {
                return
            }
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
            safariVC.delegate = self
        }
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension BreweriesListViewController: UITableViewDelegate {
    
}

//MARK: - SFSafariViewControllerDelegate
extension BreweriesListViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
