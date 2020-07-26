//
//  CGFloat+.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/23.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit

extension CGFloat {
    func HSBRandomColor() -> UIColor {
        let saturation: CGFloat = 0.45
        let brigtness: CGFloat = 0.85
        let randomHue = self
        return UIColor(
            hue: CGFloat(randomHue),
            saturation: saturation,
            brightness: brigtness,
            alpha: 1
        )
    }
}
