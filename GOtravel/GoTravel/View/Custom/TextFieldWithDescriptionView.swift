//
//  TextFieldWithDescriptionView.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/01/18.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit
import SnapKit

import SnapKit

class TextFieldWithDescriptionView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(stackView)
    stackView.addArrangedSubview(textField)
    stackView.addArrangedSubview(titleLabel)
    
    stackView.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top)
      make.leading.equalTo(self.snp.leading)
      make.trailing.equalTo(self.snp.trailing)
      make.bottom.equalTo(self.snp.bottom)
    }
    
    textField.snp.makeConstraints { (make) in
      make.height.equalTo(33)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
//    stack.alignment = .fill
    stack.spacing = 8
    stack.distribution = .equalSpacing
    return stack
  }()
  
  lazy var textField: CustomTextField = {
    let text = CustomTextField()
    text.placeholder = "어디로 여행을 가시나요?"
    
//    text.attributedPlaceholder = NSAttributedString(
//      string:text.placeholder ?? "",
//      attributes:
//      [NSAttributedString.Key.foregroundColor : UIColor.brownGrey,
//       NSAttributedString.Key.font : UIFont.sb28])
//    
    text.clearButtonMode = UITextField.ViewMode.whileEditing
    text.textColor = .black
    text.font = .sb28
    text.tintColor = .black
    return text
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "도시를 입력해주세요."
    label.font = .r16
    label.textColor = .black
    return label
  }()
  
}

class CustomTextField: UITextField {
  
  private var placeholderBackup: String?
  
  override func becomeFirstResponder() -> Bool {
    placeholderBackup = placeholder
    placeholder = nil
    return super.becomeFirstResponder()
  }
  
  override func resignFirstResponder() -> Bool {
    placeholder = placeholderBackup
    return super.resignFirstResponder()
  }
}
