//
//  BlurView.swift
//  MapClone
//
//  Created by Tieda Wei on 2019-02-19.
//  Copyright © 2019 Tieda Wei. All rights reserved.
//

import UIKit

class BlurView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurView()
    }

    func setupBlurView() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
