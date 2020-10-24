//
//  BaseViewController.swift
//  Breweries list
//
//  Created by Tarasenko Jurik on 22.10.2020.
//  Copyright © 2020 Tarasenko Yurii. All rights reserved.
//

import UIKit
import JGProgressHUD

class BaseViewController: UIViewController {
    
    //MARK: - Property
    var refreshControl: UIRefreshControl?
    let hud = JGProgressHUD(style: .dark)

    //MARK: - RefreshControl
    func setupRefreshControl(_ tableView: UITableView) {
        refreshControl = UIRefreshControl()
        if let refreshControl = refreshControl {
            refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
            tableView.addSubview(refreshControl)
        }
    }
    
    //MARK: - Load Data
    @objc func loadData() {
        
    }
}
