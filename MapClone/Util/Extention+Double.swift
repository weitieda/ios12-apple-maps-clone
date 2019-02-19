//
//  Extention+Double.swift
//  MapClone
//
//  Created by Tieda Wei on 2019-02-18.
//  Copyright © 2019 Tieda Wei. All rights reserved.
//

import Foundation

extension Double {
    func toCelsius() -> Double {
        return (self - 32.0) / 1.8
    }
}
