//
//  TabbarController.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/07/27.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

var hasTopNotch: Bool {
  if #available(iOS 11.0, tvOS 11.0, *) {
    // with notch: 44.0 on iPhone X, XS, XS Max, XR.
    // without notch: 24.0 on iPad Pro 12.9" 3rd generation, 20.0 on iPhone 8 on iOS 12+.
    return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 24
  }
  return false
}

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {
  
  private let tabbarItemCount = 2
  private var currentTab = 0
  private var firstCheck = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self

    view.backgroundColor = .white
    self.tabBar.barTintColor = .white
    self.tabBar.tintColor = UIColor.black
    self.tabBar.isTranslucent = false

    let tabOne = UINavigationController(rootViewController: HomeMainViewController())
    let image1 = resizedImageWith(image: UIImage(named: "home (1)")!, targetSize: CGSize(width: 24, height: 24))
    let tabOneBarItem = UITabBarItem(title: nil, image: image1, selectedImage: image1)
    tabOneBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    tabOne.tabBarItem = tabOneBarItem
    
    let tabTwo = UINavigationController(rootViewController: PastTripViewController())
    
    let image2 = resizedImageWith(image: UIImage(named: "menu (1)")!, targetSize: CGSize(width: 24, height: 24))
    let tabTwoBarItem2 = UITabBarItem(title: nil, image: image2, selectedImage: image2)
    tabTwoBarItem2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    tabTwo.tabBarItem = tabTwoBarItem2

    self.viewControllers = [tabOne, tabTwo]
  }

  @objc func hideTabBarAnimated(hide:Bool, completion: ((Bool) -> Void)? = nil ) {
    if (tabBarIsVisible() == !hide) {
      if let completion = completion {
        return completion(true)
      }
      return
    }

    // get a frame calculation ready
    let height = self.tabBar.frame.size.height
    let offsetY = (!hide ? -height : height)
    // zero duration means no animation
    let duration = 0.33
    UIView.animate(withDuration: duration, animations: {
      let frame = self.tabBar.frame
      self.tabBar.frame = frame.offsetBy(dx: 0, dy: offsetY)
      self.view.setNeedsDisplay()
      self.view.layoutIfNeeded()
    }, completion: { (_) in
      self.tabBarController?.tabBar.isHidden = !(self.tabBarController?.tabBar.isHidden)!
    })
  }

  func tabBarIsVisible() -> Bool {
    return self.tabBar.frame.origin.y < view.frame.maxY
  }
}

func resizedImageWith(image: UIImage, targetSize: CGSize) -> UIImage {
  
  let imageSize = image.size
  let newWidth = targetSize.width / image.size.width
  let newHeight = targetSize.height / image.size.height
  var newSize: CGSize
  
  if(newWidth > newHeight) {
    newSize = CGSize(width: imageSize.width * newHeight, height: imageSize.height * newHeight)
  } else {
    newSize = CGSize(width: imageSize.width * newWidth,  height: imageSize.height * newWidth)
  }
  
  let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
  
  UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
  
  image.draw(in: rect)
  
  let newImage = UIGraphicsGetImageFromCurrentImageContext()!
  UIGraphicsEndImageContext()
  
  return newImage
}
