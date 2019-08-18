//
//  DirectAddAccountCell.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/08/12.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class DirectAddAccountCell: UICollectionViewCell {
  override var isSelected: Bool {
    didSet {
    if isSelected {
      layer.borderWidth = 1
      layer.borderColor = UIColor.butterscotch.cgColor
    }else{
      layer.borderColor = UIColor.clear.cgColor
      }
    }
  }
  var directAddAccountModel: DirectAddAccountModel? {
    didSet {
      guard let model = directAddAccountModel else {
        return
      }
      imageView.image = model.ExampleImage
      titleLabel.text = model.title
    }
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func initView(){
    self.backgroundColor = .white
    self.layer.cornerRadius = 4
    self.clipsToBounds = false
    self.layer.zeplinStyleShadows(color: .black, alpha: 0.16, x: 3, y: 3, blur: 6, spread: 0)
    self.addSubview(view)
    view.addArrangedSubview(imageView)
    view.addArrangedSubview(titleLabel)
    
    view.snp.makeConstraints{ (make) in
      make.top.equalTo(imageView)
      make.left.equalTo(self.snp.left)
      make.right.equalTo(self.snp.right)
      make.bottom.equalTo(titleLabel.snp.bottom)
      make.center.equalTo(self.snp.center)
    }
    
    imageView.snp.makeConstraints{(make) in
      make.width.equalTo(40)
      make.height.equalTo(40)
    }
  }
  lazy var view: UIStackView = {
    let view = UIStackView()
    view.spacing = 15
    view.axis = .vertical
    view.alignment = .center
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var imageView: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = UIImageView.ContentMode.scaleAspectFit
    return image
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.font = .sb14
    return label
  }()
}
