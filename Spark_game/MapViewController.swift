//
//  MapViewController.swift
//  Spark_game
//
//  Created by jackl3 on 30/7/2017.
//  Copyright © 2017 jackl3. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: UIViewController {
    var mapView: MKMapView!
    override func loadView() {
        mapView = MKMapView()
        view = mapView
        let segmentedControl = UISegmentedControl(items: ["Standart", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged), for: .valueChanged)
        view.addSubview(segmentedControl)
        //let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.topAnchor)
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        //let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        //let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        
    }
    func mapTypeChanged(segControl: UISegmentedControl)  {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Map View loaded")
    }
    
}
