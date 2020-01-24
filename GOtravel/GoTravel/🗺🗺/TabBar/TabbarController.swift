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

class TabbarViewController : UITabBarController, UITabBarControllerDelegate {
  
  private let tabbarItemCount = 2
  private var currentTab = 0
  private var firstCheck = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    // tabbar indicator
//    self.view.addSubview(selectLine)
    // MARK: Tabbar Setting
//    self.tabBar.barTintColor = #colorLiteral(red: 0.9803921569, green: 0.9803921569, blue: 0.9803921569, alpha: 1)
    view.backgroundColor = .white
    self.tabBar.barTintColor = .white
    self.tabBar.tintColor = UIColor.black
    self.tabBar.isTranslucent = false
    
    
    let tabOne = UINavigationController(rootViewController: HomeMainViewController())
    let image1 = resizedImageWith(image: UIImage(named: "home (1)")!, targetSize: CGSize(width: 24, height: 24))
    let tabOneBarItem = UITabBarItem(title: nil, image: image1, selectedImage: image1)
    tabOneBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    tabOne.tabBarItem = tabOneBarItem
    
    let tabTwo = UINavigationController(rootViewController: pastVC())
    
    let image2 = resizedImageWith(image: UIImage(named: "menu (1)")!, targetSize: CGSize(width: 24, height: 24))
    let tabTwoBarItem2 = UITabBarItem(title: nil, image: image2, selectedImage: image2)
    tabTwoBarItem2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    tabTwo.tabBarItem = tabTwoBarItem2
    
    
    self.viewControllers = [tabOne, tabTwo]
    
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if currentTab == 0 {
      if hasTopNotch {
        var bottomSafeAreaHeight: CGFloat = 0
        if #available(iOS 11.0, *) {
          let window = UIApplication.shared.windows[0]
          let safeFrame = window.safeAreaLayoutGuide.layoutFrame
          bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        }
        if firstCheck {
          firstCheck = false
          selectLine.frame = CGRect(x: 0, y: self.view.bounds.maxY - CGFloat(self.tabBar.frame.height) - bottomSafeAreaHeight  , width: view.frame.width/CGFloat(tabbarItemCount), height: 2)
        }else{
          selectLine.frame = CGRect(x: 0, y: self.view.bounds.maxY - CGFloat(self.tabBar.frame.height)  , width: view.frame.width/CGFloat(tabbarItemCount), height: 3)
        }
      }else{
        selectLine.frame = CGRect(x: 0, y: self.view.bounds.maxY - CGFloat(self.tabBar.frame.height) , width: view.frame.width/CGFloat(tabbarItemCount), height: 2)
      }
    }else{
      let itemWidth = tabBar.bounds.width / CGFloat(tabbarItemCount)
      let currentMinX = itemWidth * CGFloat(currentTab)
      
      self.selectLine.frame = CGRect(x: currentMinX, y: self.view.bounds.maxY - CGFloat(self.tabBar.frame.height), width: itemWidth, height: 2)
    }
  }
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    view.bringSubviewToFront(selectLine)
    let itemWidth = tabBar.bounds.width / CGFloat(tabbarItemCount)
    let tabBarIndex = tabBarController.selectedIndex
    let currentMinX = itemWidth * CGFloat(tabBarIndex)
    currentTab = tabBarIndex
    UIView.animate(withDuration: 0.3, animations: {
      self.selectLine.frame = CGRect(x: currentMinX, y: self.view.bounds.maxY - CGFloat(self.tabBar.frame.height), width: itemWidth, height: 2)
    },completion: { _ in
    })
  }
  /// tabbar 아이템 선택시 표시되는 라인
  lazy var selectLine : UIView = {
    let view = UIView()
    view.backgroundColor = Defaull_style.mainTitleColor
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
}
extension TabbarViewController {
}
func resizedImageWith(image: UIImage, targetSize: CGSize) -> UIImage {
  
  let imageSize = image.size
  let newWidth  = targetSize.width  / image.size.width
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

extension TabbarViewController {
  func setSelectLine(index : Int ){
    let itemWidth = tabBar.bounds.width / CGFloat(tabbarItemCount)
    let currentMinX = itemWidth * CGFloat(index)
    currentTab = index
    UIView.animate(withDuration: 0.3, animations: {
      self.selectLine.frame = CGRect(x: currentMinX, y: self.view.bounds.maxY - CGFloat(self.tabBar.frame.height), width: itemWidth, height: 2)
    },completion: { _ in
    })
    
  }
  // hidesBottomBarWhenPushed 아니면 tabbar 위치에서 버튼이 안눌리는 문제를 해결하기 위함
  func showSelectLine(){
    let tabBarMinY = self.tabBar.frame.minY
    self.selectLine.frame = CGRect(x :(self.selectLine.frame.minX), y: tabBarMinY, width: self.selectLine.frame.width, height: self.selectLine.frame.height)
    self.view.bringSubviewToFront(self.selectLine)
    
  }
  func hideTabbarSelectLine(){
    //    self.selectLine.isHidden = true
    //    self.selectLine.frame = CGRect(x :(self.selectLine.frame.minX), y: self.tabBar.frame.maxY, width: self.selectLine.frame.width, height: self.selectLine.frame.height)
  }
  // hide == true 이면 숨기기 false 이면 보이기
  @objc func hideTabBarAnimated(hide:Bool, completion: ((Bool)->Void)? = nil ) {
    self.selectLine.isHidden = hide
    
    if (tabBarIsVisible() == !hide) {
      if let completion = completion {
        return completion(true)
      }
      else {
        return
      }
    }
    // get a frame calculation ready
    let height = self.tabBar.frame.size.height
    
    let offsetY = (!hide ? -height : height)
    let tabY = height
    let selectLineY = hide ? self.tabBar.frame.maxY  : self.tabBar.frame.maxY - (tabY*2)
    // zero duration means no animation
    let duration = 0.33
    
    UIView.animate(withDuration: duration, animations: {
      let frame = self.tabBar.frame
      self.tabBar.frame = frame.offsetBy(dx: 0, dy: offsetY)
      self.selectLine.frame = CGRect(x :(self.selectLine.frame.minX), y: selectLineY, width: self.selectLine.frame.width, height: self.selectLine.frame.height)
      self.view.setNeedsDisplay()
      self.view.layoutIfNeeded()
    }, completion: { (finished) in
      self.tabBarController?.tabBar.isHidden = !(self.tabBarController?.tabBar.isHidden)!
    })
  }
  func tabBarIsVisible() -> Bool {
    return self.tabBar.frame.origin.y < view.frame.maxY
  }
  
}


