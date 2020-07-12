//
//  UIButton+.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/13.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit

extension UIButton {
  func puls(){
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 0.95
    pulse.fromValue = 0.97
    pulse.toValue = 1.0
    pulse.autoreverses = true
    pulse.repeatCount = Float.infinity
    layer.add(pulse,forKey:nil)
  }
}
