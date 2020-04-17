//
//  RentaMapViewController.swift
//  RentaSuit
//
//  Created by BACEM Ben Afia on 10/14/18.
//  Copyright © 2018 MacBook Pro. All rights reserved.
//

import UIKit
import GoogleMaps

class RentaMapViewController: BaseViewController, GMSMapViewDelegate {

    @IBOutlet weak var gMapView: GMSMapView!
    @IBOutlet weak var subHeaderBtn: UIButton!
    @IBOutlet weak var requestButton: UIButton!
    
    var cleanersList = [Cleaner]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gMapView.delegate = self
    }
    
    @IBAction func didTapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // map delegate
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        // TODO once data ready (fill view with real data)
        let windowInfo = RentaInfoWindow.clone()
        windowInfo.setUp(marker.userData as! Cleaner)
        return windowInfo
    }

    @IBAction func didTapRequestButton(_ sender: Any) {
        self.gMapView.clear()
        self.cleanersList = [Cleaner]()
        self.startLoading()
        Cleaner.cleanersAroundMe { (cleanersList, code) in
            self.stopLoading()
            if cleanersList != nil {
                self.cleanersList = cleanersList!
                self.updateMap()
            }
        }
    }
    
    func updateMap(){
        for cleaner in cleanersList {
            // Creates a marker in the center of the map.
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake((cleaner.latitude?.toDouble)!,
                                                         cleaner.longitude!.toDouble!)
            marker.icon = UIImage.init(named: "ic_custom_marker")
            marker.infoWindowAnchor = CGPoint(x: 11.5, y: 2.5)
            marker.userData = cleaner
            marker.map = gMapView
            
        }
    }
}
