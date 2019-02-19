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
    
    lazy var mapView: MKMapView = {
        let mv = MKMapView()
        mv.showsUserLocation = true
        mv.userTrackingMode = .follow
        mv.showsCompass = false
        mv.delegate = self
        return mv
    }()
    
    lazy var compassButton: MKCompassButton = {
        let cb = MKCompassButton(mapView: mapView)
        cb.compassVisibility = .adaptive
        return cb
    }()
    
    lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.delegate = self
        return lm
    }()
    
    let slider = Slider()
    
    let centerMapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "arrow").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = .blue
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleCenterLocation), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.alpha = 0.8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        button.layer.masksToBounds = false
        return button
    }()
    
    let temperatureLabel: UILabel = {
        let lb = UILabel()
        lb.backgroundColor = .white
        lb.layer.cornerRadius = 5
        lb.clipsToBounds = true
        lb.textAlignment = .center
        lb.alpha = 0.8
        return lb
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableLocationServices()
        setupSubviews()
        fetchWeatherData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        centerMapOnUserLocation()
    }
    
    fileprivate func setupSubviews() {
        setupMapView()
        setupCenterButton()
        setupSlider()
        setupTemperatureLabel()
        setupCompassButton()
    }
    
    func fetchWeatherData() {
        
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        WeatherDataManager.shared.getWeatherDataAt(latitude: coordinate.latitude, longitude: coordinate.longitude) { (data, err) in
            if let err = err {
                print(err)
            } else if let data = data {
                DispatchQueue.main.async {
                    self.temperatureLabel.text = String(format:"%.0f °C", data.currently.temperature.toCelsius())
                }
            }
        }
    }
    
    func setupTemperatureLabel() {
        view.addSubview(temperatureLabel)
        temperatureLabel.anchor(top: nil, leading: nil, bottom: slider.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 8, right: 8), size: .init(width: 60, height: 25))
    }
    
    func setupCenterButton() {
        view.addSubview(centerMapButton)
        centerMapButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 16), size: .init(width: 35, height: 35))
    }
    
    @objc func handleCenterLocation() {
        centerMapOnUserLocation()
    }
    
    func setupSlider() {
        view.addSubview(slider)
        slider.delegate = self
        slider.mapController = self
        slider.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: view.frame.height - 80, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: view.frame.height))

    }
    
    func setupCompassButton() {
        view.addSubview(compassButton)
        compassButton.anchor(top: centerMapButton.bottomAnchor, leading: nil, bottom: nil, trailing: centerMapButton.trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
    }
    
    func setupMapView() {
        view.addSubview(mapView)
        mapView.fillSuperview()
    }
    
    func centerMapOnUserLocation() {
        guard let coordinates = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func removeAnnotations() {
        mapView.annotations.forEach { mapView.removeAnnotation($0)}
    }
    
    func searchBy(naturalLanguageQuery: String, region: MKCoordinateRegion, coordinates: CLLocationCoordinate2D, completion: @escaping (_ response: MKLocalSearch.Response?, _ error: NSError?) -> ()) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = naturalLanguageQuery
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                completion(nil, error! as NSError)
                return
            }
            completion(response, nil)
        }
    }
}


extension MapViewController: SliderDelegate {
    func didSelectMapItem(annotation: MKMapItem) {
        mapView.annotations.forEach {
            if annotation.name == $0.title {
                mapView.selectAnnotation($0, animated: true)
                mapView.setCenter($0.coordinate, animated: true)
            }
        }
    }
    
    func cancelButtonTapped() {
        removeAnnotations()
    }
    
    func handleSearch(by text: String) {
        
        removeAnnotations()
        
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        
        searchBy(naturalLanguageQuery: text, region: region, coordinates: coordinate) { (response, error) in
            guard let response = response else { return }
            response.mapItems.forEach {
                let annotation = MKPointAnnotation()
                annotation.title = $0.name
                annotation.coordinate = $0.placemark.coordinate
                self.mapView.addAnnotation(annotation)
            }
            self.slider.searchResult = response.mapItems
            self.slider.tableView.reloadData()
        }
    }
    
    func animateTemperatureLabel(targetPosotion: CGFloat, targetHeight: SliderHeight) {
        let y = targetPosotion - self.temperatureLabel.frame.height - 8
        
        switch targetHeight {
        case .low:
            showAccessoryButtons()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.temperatureLabel.frame.origin.y = y
            })
        case .medium:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.temperatureLabel.frame.origin.y = y
            })
            showAccessoryButtons()
        case .high:
            temperatureLabel.isHidden = true
            centerMapButton.isHidden = true
            compassButton.isHidden = true
            self.temperatureLabel.frame.origin.y = y
        }
    }
    
    func showAccessoryButtons() {
        temperatureLabel.isHidden = false
        centerMapButton.isHidden = false
    }
}

extension MapViewController: SearchCellDelegate {
    func userDistance(from location: CLLocation) -> CLLocationDistance? {
        guard let userLocation = locationManager.location else { return nil }
        let distance = userLocation.distance(from: location)
        return distance
    }
}


