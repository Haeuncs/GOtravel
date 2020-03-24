//
//  Toast.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/08/11.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit

class Toast: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  public static func show(message: String, isTabbar: Bool){
    guard let window = UIApplication.shared.keyWindow else{
      fatalError("No access to UIApplication Window")
    }
    let alert = Toast(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
    if isTabbar {
      alert.bottomWithTabbarConstraint()
    }else{
      alert.bottomConstraint()
    }
    alert.titleLabel.text = message
    
    window.addSubview(alert)
    
    /// Animates the alert to show and disappear from the view
    UIView.animate(withDuration: 0.8, delay: 0.2, options: [.curveEaseOut,.allowUserInteraction], animations: {
      alert.alpha = 1.0
    }, completion: { _ in
      UIView.animate(withDuration: 1.6, delay: 1.6, options: [.curveEaseOut,.allowUserInteraction], animations: {
        alert.alpha = 0.0
        //        alert.frame.origin.y = alert.frame.origin.y + 50
      }, completion: { _ in
        alert.removeFromSuperview()
      })
    })
    
  }
  private func bottomConstraint(){
    self.addSubview(popupView)
    popupView.addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      popupView.heightAnchor.constraint(equalToConstant: 32),
      popupView.widthAnchor.constraint(equalToConstant: 280),
      popupView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      popupView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
      
      titleLabel.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: popupView.centerYAnchor),
      ])
  }
  private func bottomWithTabbarConstraint(){
    self.addSubview(popupView)
    popupView.addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      popupView.heightAnchor.constraint(equalToConstant: 32),
      popupView.widthAnchor.constraint(equalToConstant: 280),
      popupView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      popupView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: ( (-49) + (-20))),
      
      titleLabel.centerXAnchor.constraint(equalTo: popupView.centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: popupView.centerYAnchor),
      ])
  }

  lazy var popupView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    view.layer.cornerRadius = 4
    view.layer.masksToBounds = true
    view.clipsToBounds = true
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = UIColor.white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
}

