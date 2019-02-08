//
//  ViewController.swift
//  MapClone
//
//  Created by Tieda Wei on 2019-02-07.
//  Copyright © 2019 Tieda Wei. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
    
    let mapView: MKMapView = {
        let mv = MKMapView()
        mv.showsUserLocation = true
        mv.userTrackingMode = .follow
        return mv
    }()
    
    let locationManager: CLLocationManager = {
       let lm = CLLocationManager()
        
       return lm
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        locationManager.delegate = self
        
        setupMapView()
        enableLocationServices()
    }
    
    func setupMapView() {
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.fillSuperview()
    }
    
}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func enableLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("Location auth status is NOT DETERMINED")
            
            DispatchQueue.main.async {
                let controller = LocationRequestController()
                controller.locationManager = self.locationManager
                self.present(controller, animated: true, completion: nil)
            }
            
        case .restricted:
            print("Location auth status is RESTRICTED")
        case .denied:
            print("Location auth status is DENIED")
        case .authorizedAlways:
            print("Location auth status is AUTHORIZED ALWAYS")
        case .authorizedWhenInUse:
            print("Location auth status is AUTHORIZED WHEN IN USE")
        }
    }
}


