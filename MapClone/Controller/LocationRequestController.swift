//
//  LocationRequestController.swift
//  MapClone
//
//  Created by Tieda Wei on 2019-02-07.
//  Copyright © 2019 Tieda Wei. All rights reserved.
//

import UIKit
import CoreLocation

class LocationRequestController: UIViewController {
    
    // MARK: - Properties
    
    var locationManager: CLLocationManager?
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "blue-pin")
        return iv
    }()
    
    let allowLocationLabel: UILabel = {
        let label = UILabel()
        
        let attributedText = NSMutableAttributedString(string: "Allow Location\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 24)])
        
        attributedText.append(NSAttributedString(string: "Please enable location services so that we can track your movements", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)]))
        
        label.numberOfLines = 0
        label.textAlignment = .center
        label.attributedText = attributedText
        
        return label
    }()
    
    let enableLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Enable Location", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = .mainBlue()
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleRequestLocation), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponents()
    }
    
    // MARK: - Selectors
    
    @objc func handleRequestLocation() {
        guard let locationManager = self.locationManager else { return }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Helper Functions
    
    func configureViewComponents() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 140, left: 0, bottom: 0, right: 0), size: .init(width: 200, height: 200))
        imageView.centerX(in: view)
        
        view.addSubview(allowLocationLabel)
        allowLocationLabel.anchor(top: imageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 32, left: 32, bottom: 0, right: 32))
        allowLocationLabel.centerX(in: view)
        
        view.addSubview(enableLocationButton)
        enableLocationButton.anchor(top: allowLocationLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 24, left: 32, bottom: 0, right: 32), size: .init(width: 0, height: 50))
    }
}

extension LocationRequestController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard locationManager?.location != nil else {
            print("Error setting location..")
            return
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

