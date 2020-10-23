//
//  BreweryCell.swift
//  Breweries list
//
//  Created by Tarasenko Jurik on 23.10.2020.
//  Copyright © 2020 Tarasenko Yurii. All rights reserved.
//

import UIKit
import MapKit

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
    
    private var location = CLLocationCoordinate2D()

    override func prepareForReuse() {
        super.prepareForReuse()
        [nameLabel, countryLabel, stateLabel, cityLabel, streetLabel].forEach { $0?.text = "" }
    }
    
    func configure(_ model: Brewery) {
        var model = model
        model.country = ""
        nameLabel.text = model.name
        countryLabel.text = model.country
        countryStack.isHidden = model.country == String()
        stateLabel.text = model.state
        stateStack.isHidden = model.state == String()
        cityLabel.text = model.city
        cityStack.isHidden = model.city == String()
        streetLabel.text = model.street
        stateStack.isHidden = model.street == String()
        if let latitude = Double(model.latitude),
            let longitude = Double(model.longitude) {
            location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    @IBAction func showOnMapAction(_ sender: UIButton) {
        print(#function)
    }
    
}
