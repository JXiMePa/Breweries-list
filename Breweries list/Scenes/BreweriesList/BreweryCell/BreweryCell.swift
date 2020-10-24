//
//  BreweryCell.swift
//  Breweries list
//
//  Created by Tarasenko Jurik on 23.10.2020.
//  Copyright © 2020 Tarasenko Yurii. All rights reserved.
//

import UIKit
import JGProgressHUD

final class BreweryCell: UITableViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var countryStack: UIStackView!
    @IBOutlet private weak var stateLabel: UILabel!
    @IBOutlet private weak var stateStack: UIStackView!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var cityStack: UIStackView!
    @IBOutlet private weak var streetLabel: UILabel!
    @IBOutlet private weak var streetStack: UIStackView!
    @IBOutlet private weak var showOnMapButton: UIButton!
    @IBOutlet private weak var showOnMapUnderView: UIView!
    @IBOutlet private weak var webSiteButton: UnderlineTextButton!
    @IBOutlet private weak var webSiteStackView: UIStackView!
    
    //MARK: - Property
    var showOnMapDidTap: (() -> Void)?
    var webSiteDidTap:  ((String) -> Void)?
    private var webSiteUrl: String?

    override func prepareForReuse() {
        super.prepareForReuse()
        [nameLabel, countryLabel, stateLabel, cityLabel, streetLabel].forEach { $0?.text = "" }
        webSiteButton.setTitle("", for: .normal)
    }
    
    func configure(_ model: Brewery) {
        nameLabel.text = model.name
        countryLabel.text = model.country
        stateLabel.text = model.state
        cityLabel.text = model.city
        streetLabel.text = model.street
        webSiteUrl = model.websiteUrl
        webSiteButton.setTitle(model.websiteUrl, for: .normal)
        showOnMapUnderView.isHidden = model.longitude?.isEmpty ?? true && model.latitude?.isEmpty ?? true
        countryStack.isHidden = model.country?.isEmpty ?? true
        stateStack.isHidden = model.state?.isEmpty ?? true
        cityStack.isHidden = model.city?.isEmpty ?? true
        streetStack.isHidden = model.street?.isEmpty ?? true
        webSiteStackView.isHidden = model.websiteUrl?.isEmpty ?? true
    }
    
    @IBAction func showOnMapAction(_ sender: UIButton) {
        showOnMapDidTap?()
    }
    
    @IBAction func webSiteAction(_ sender: UIButton) {
        guard let urlString = webSiteUrl else {
            return
        }
        webSiteDidTap?(urlString)
    }
}
