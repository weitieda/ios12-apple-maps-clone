//
//  Slider.swift
//  MapClone
//
//  Created by Tieda Wei on 2019-02-08.
//  Copyright © 2019 Tieda Wei. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol SliderDelegate {
    func animateTemperatureLabel(targetPosotion: CGFloat, targetHeight: SliderHeight)
    func handleSearch(by text: String)
    func cancelButtonTapped()
}

enum SliderHeight {
    case low
    case medium
    case high
}

class Slider: UIView {
    
    var mapController: MapViewController?
    
    var searchResult = [MKMapItem]()
    
    lazy var highPosition: CGFloat = 60
    lazy var mediumPosition = frame.height / 5 * 3
    lazy var lowPosition = frame.height - 80
    
    var delegate: SliderDelegate?
    
    var currentSliderHeight: SliderHeight = .low
    
    let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 3
        view.alpha = 0.5
        return view
    }()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search for a place or address"
        sb.barStyle = .black
        sb.backgroundImage = UIImage()
        sb.delegate = self
        return sb
    }()
    
    let cellId = "cellId"
    lazy var tableView: UITableView = {
        let tb = UITableView()
        return tb
    }()


    // MARK: -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSlider()
        setupSubviews()
        setupSwipeGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -
    fileprivate func setupSlider() {
        layer.cornerRadius = 15
        clipsToBounds = true
        backgroundColor = .white
    }
    
    fileprivate func setupSubviews() {
        addSubview(indicatorView)
        indicatorView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 0, right: 0),  size: .init(width: 40, height: 5))
        indicatorView.centerX(in: self)
        
        addSubview(searchBar)
        searchBar.anchor(top: indicatorView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 50))
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.black
            textfield.backgroundColor = UIColor.init(white: 0.3, alpha: 0.2)
        }
        
        
        tableView.register(SearchCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        addSubview(tableView)
        tableView.anchor(top: searchBar.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 100, right: 0))
    }
    
    // MARK: -
    fileprivate func setupSwipeGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUp.direction = .up
        addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer){
        if gesture.direction == .up {
            if currentSliderHeight == .low {
                
                delegate?.animateTemperatureLabel(targetPosotion: mediumPosition, targetHeight: .medium)
                
                animateSlider(targetPosition: mediumPosition) { (_) in
                    self.currentSliderHeight = .medium
                }
            }
            
            if currentSliderHeight == .medium {
                delegate?.animateTemperatureLabel(targetPosotion: highPosition, targetHeight: .high)
                animateSlider(targetPosition: highPosition) { (_) in
                    self.currentSliderHeight = .high
                }
            }
        } else if gesture.direction == .down {
            if currentSliderHeight == .medium {
                delegate?.animateTemperatureLabel(targetPosotion: lowPosition, targetHeight: .low)
                animateSlider(targetPosition: lowPosition) { (_) in
                    self.currentSliderHeight = .low
                }
            }
            if currentSliderHeight == .high {
                self.searchBar.endEditing(true)
                if let text = self.searchBar.text {
                    if !text.isEmpty {  self.searchBar.showsCancelButton = true }
                }
                delegate?.animateTemperatureLabel(targetPosotion: mediumPosition, targetHeight: .medium)
                animateSlider(targetPosition: mediumPosition) { (_) in
                    self.currentSliderHeight = .medium
                }
            }
        }
    }
    
    func animateSlider(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.frame.origin.y = targetPosition
        }, completion: completion)
    }
}

extension Slider: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchCell
        if let mVC = mapController { cell.delegate = mVC }
        cell.mapItem = searchResult[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        animateSlider(targetPosition: mediumPosition) { (_) in
            self.currentSliderHeight = .medium
        }
    }
}

extension Slider: UISearchBarDelegate {
    func dismissSearch() {
        searchBar.endEditing(true)
        
        animateSlider(targetPosition: frame.height / 5 * 3) { (_) in
            self.currentSliderHeight = .medium
        }
        delegate?.animateTemperatureLabel(targetPosotion: mediumPosition, targetHeight: .medium)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        delegate?.handleSearch(by: text)
        dismissSearch()
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        animateSlider(targetPosition: 60) { (_) in
            self.currentSliderHeight = .high
        }
        delegate?.animateTemperatureLabel(targetPosotion: highPosition, targetHeight: .high)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate?.cancelButtonTapped()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchResult.removeAll()
        tableView.reloadData()
    }
}
