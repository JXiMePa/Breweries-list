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
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
        setupRefreshControl(tableView)
    }
    
    //MARK: - Func
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
    
    @objc override func loadData() {
        guard Connectivity.isConnectedToInternet() else {
            showAlert("No internet connection", message: "Application working in offline mode. Please check your internet connection and pull reload.", completion: { [weak self] in
                self?.refreshControl?.endRefreshing()
            })
            return
        }
        BreweriesListService.getData { [weak self] result in
            guard let self = self else { return }
            self.refreshControl?.endRefreshing()
            switch result {
            case .success(let models):
                self.breweries = models
            case .failure(let error):
                self.showAlert()
                print(error.localizedDescription)
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
        let cleanSearchText = searchText.replacingOccurrences(of: "[^A-Za-z0-9]+", with: "", options: [.regularExpression])
        hud.show(in: view)
        BreweriesListService.getData(searchName: cleanSearchText) { [weak self] result in
            guard let self = self else { return }
            self.hud.dismiss()
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
            mapViewController.brewery = self.currentData[indexPath.row]
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
