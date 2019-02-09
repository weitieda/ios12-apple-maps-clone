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
        mv.showsCompass = false
        return mv
    }()
    
    lazy var compassButton: MKCompassButton = {
        let cb = MKCompassButton(mapView: mapView)
        cb.compassVisibility = .adaptive
        return cb
    }()
    
    let locationManager: CLLocationManager = {
       let lm = CLLocationManager()
       return lm
    }()
    
    let slider = Slider()
    
    let centerMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "location-arrow-flat").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleCenterLocation), for: .touchUpInside)
        return button
    }()
    
    let temperatureLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .red
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupMapView()
        enableLocationServices()
        setupCenterButton()
        setupSlider()
        setupTemperatureLabel()
    }
    
    func setupTemperatureLabel() {
        view.addSubview(temperatureLabel)
        temperatureLabel.anchor(top: nil, leading: nil, bottom: slider.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 8), size: .init(width: 50, height: 20))
    }
    
    func setupCenterButton() {
        view.addSubview(centerMapButton)
        centerMapButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 16), size: .init(width: 35, height: 35))
    }
    
    @objc func handleCenterLocation() {
        centerMapOnUserLocation(shouldLoadAnnotations: true)
    }
    
    func setupSlider() {
        view.addSubview(slider)
        slider.delegate = self
        slider.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: view.frame.height - 80, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: view.frame.height))
        
        view.addSubview(compassButton)
        compassButton.anchor(top: centerMapButton.bottomAnchor, leading: nil, bottom: nil, trailing: centerMapButton.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        centerMapOnUserLocation(shouldLoadAnnotations: true)
    }
    
    func setupMapView() {
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.fillSuperview()
    }
    
    func centerMapOnUserLocation(shouldLoadAnnotations: Bool) {
        guard let coordinates = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(coordinateRegion, animated: true)
        
//        if shouldLoadAnnotations {
//            loadAnnotations(withSearchQuery: "Coffee Shops")
//        }
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

// MARK: - SliderDelegate

extension MapViewController: SliderDelegate {
    func animateTemperatureLabel(targetPosotion: CGFloat, targetHeight: SliderHeight) {
        let y = targetPosotion - self.temperatureLabel.frame.height - 8
        
        switch targetHeight {
        case .low:
            temperatureLabel.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.temperatureLabel.frame.origin.y = y
            })
        case .medium:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.temperatureLabel.frame.origin.y = y
            })
            self.temperatureLabel.isHidden = false
        case .high:
            temperatureLabel.isHidden = true
            self.temperatureLabel.frame.origin.y = y
        }
    }
    
}


