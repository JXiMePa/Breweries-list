//
//  MapViewController.swift
//  Breweries list
//
//  Created by Tarasenko Jurik on 23.10.2020.
//  Copyright © 2020 Tarasenko Yurii. All rights reserved.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet private weak var mapView: MKMapView!
    
    //MARK: - Property
    var brewery: Brewery?
    
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapBy(brewery)
    }
    
    private func setupMapBy(_ model: Brewery?) {
        guard let latitudeString = model?.latitude, let lat = Double(latitudeString),
            let longitudeString = model?.longitude, let lon = Double(longitudeString) else {
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.title = model?.name
        if let phone = model?.phone {
            annotation.subtitle = "Phone - \(phone)"
        }
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }

}
