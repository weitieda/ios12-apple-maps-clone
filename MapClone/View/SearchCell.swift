//
//  SearchCell.swift
//  MapClone
//
//  Created by Tieda Wei on 2019-02-08.
//  Copyright © 2019 Tieda Wei. All rights reserved.
//

import UIKit
import MapKit

protocol SearchCellDelegate {
    func userDistance(from location: CLLocation) -> CLLocationDistance?
    func getDirections(forMapItem mapItem: MKMapItem)
}

class SearchCell: UITableViewCell {
    
    // MARK: - Properties
    
    var delegate: SearchCellDelegate?
    
    var mapItem: MKMapItem? {
        didSet {
            placeInfoLabel.text = mapItem?.name ?? "n/a"
            
            let distanceFormatter = MKDistanceFormatter()
            distanceFormatter.unitStyle = .abbreviated
            distanceFormatter.units = .metric
            
            guard let mapItemLocation = mapItem?.placemark.location else { return }
            guard let distance = delegate?.userDistance(from: mapItemLocation) else {return}
            let distanceAsString = distanceFormatter.string(fromDistance: distance)
            distanceLabel.text = distanceAsString
        }
    }
    
    lazy var directionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Go", for: .normal)
        button.backgroundColor = .directionsGreen()
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleGetDirections), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.alpha = 0
        return button
    }()
    
    lazy var locationImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .mainPink()
        iv.tintColor = .white
        iv.image = UIImage(named: "location4")?.withRenderingMode(.alwaysOriginal)
        return iv
    }()
    
    let placeInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            placeInfoLabel,
            distanceLabel
            ])
        sv.axis = .vertical
        sv.spacing = 0
        return sv
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
//        contentView.backgroundColor = .red
        
        contentView.addSubview(locationImageView)
        let dimension: CGFloat = 35
        locationImageView.anchor(top: nil, leading: contentView.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0), size: .init(width: dimension, height: dimension))
        locationImageView.layer.cornerRadius = dimension / 2
        locationImageView.centerY(in: contentView)
        
        contentView.addSubview(verticalStackView)
        verticalStackView.anchor(top: nil, leading: locationImageView.trailingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        verticalStackView.centerY(in: contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Selectors
    
    @objc func handleGetDirections() {
        guard let mapItem = self.mapItem else { return }
        delegate?.getDirections(forMapItem: mapItem)
    }
    
    // MARK: - Helper Functions
    
    func animateButtonIn() {
        directionsButton.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.directionsButton.alpha = 1
            self.directionsButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
            self.directionsButton.transform = .identity
        }
    }
}

