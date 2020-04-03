//
//  ColorCollectionViewCell.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/03/28.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit

class colorCVCell: UICollectionViewCell {
  let widthSize = CGFloat(40)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    //        backgroundColor = .red
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func setupView(){
    addSubview(colorView)
    colorView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    colorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    colorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    colorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    
  }
  let colorView : UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    view.layer.cornerRadius = 40/2.0
    view.clipsToBounds = true
    
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
}
