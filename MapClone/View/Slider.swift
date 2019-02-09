//
//  Slider.swift
//  MapClone
//
//  Created by Tieda Wei on 2019-02-08.
//  Copyright © 2019 Tieda Wei. All rights reserved.
//

import UIKit

class Slider: UIView {
    
    enum SliderHeight {
        case low
        case medium
        case high
    }
    
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
//        sb.backgroundColor = .red
        sb.delegate = self
//        sb.barTintColor = .lightGray
        return sb
    }()
    
    let cellId = "cellId"
    let tableView: UITableView = {
        let tb = UITableView()
        tb.rowHeight = 72
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
        
        
        tableView.register(SearchCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
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
                animateSlider(targetPosition: frame.height / 5 * 3) { (_) in
                    self.currentSliderHeight = .medium
                }
            }
            
            if currentSliderHeight == .medium {
                animateSlider(targetPosition: 60) { (_) in
                    self.currentSliderHeight = .high
                }
            }
            
        } else if gesture.direction == .down {
            if currentSliderHeight == .medium {
                animateSlider(targetPosition: frame.height - 80) { (_) in
                    self.currentSliderHeight = .low
                }
            }
            if currentSliderHeight == .high {
                self.searchBar.endEditing(true)
                self.searchBar.showsCancelButton = false
                animateSlider(targetPosition: frame.height / 5 * 3) { (_) in
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
//        guard let searchResults = searchResults else { return 0 }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchCell
        return cell
    }
}

extension Slider: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        animateSlider(targetPosition: 60) { (_) in
            self.currentSliderHeight = .high
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        
        animateSlider(targetPosition: frame.height / 5 * 3) { (_) in
            self.currentSliderHeight = .medium
        }
    }
}
