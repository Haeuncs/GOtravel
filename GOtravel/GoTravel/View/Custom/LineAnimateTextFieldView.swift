//
//  File.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/08/10.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LineAnimateTextView: UIView {
  let disposebag = DisposeBag()
  init(description: String, placeholder: String) {
    super.init(frame: .zero)
    self.descriptionLabel.text = description
    initView()
    bindRx()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.font = .sb14
    return label
  }()
  lazy var textView: UITextView = {
    let view = UITextView()
    // 시각 보정
    view.contentInset = UIEdgeInsets(top: -8, left: -4, bottom: 0, right: 0)
    view.tintColor = .black
    view.textColor = .black
    view.font = .r14
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var textFieldLine: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = DefaullStyle.lightGray
    return view
  }()
  lazy var textFieldActiveLine: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .black
    return view
  }()
  
  private func rectForBorder(isFilled: Bool) -> CGRect {
    if isFilled {
      return CGRect(origin: CGPoint(x: 0, y: textFieldLine.frame.minY), size: CGSize(width: textFieldLine.frame.width, height: 2))
    } else {
      return CGRect(origin: CGPoint(x: 0, y: textFieldLine.frame.minY), size: CGSize(width: 0, height: 2))
    }
  }
  func initView() {
    self.addSubview(descriptionLabel)
    self.addSubview(textView)
    self.addSubview(textFieldLine)
    self.addSubview(textFieldActiveLine)
    descriptionLabel.snp.makeConstraints{ (make) in
      make.top.leading.trailing.equalTo(self)
    }
    textView.snp.makeConstraints { (make) in
      make.top.equalTo(descriptionLabel.snp.bottom).offset(8).priority(.high)
      make.trailing.equalTo(self)
      // 시각 보정
      make.leading.equalTo(self).offset(-2)
    }
    textFieldLine.snp.makeConstraints{ (make) in
      make.height.equalTo(2)
      make.top.lessThanOrEqualTo(textView.snp.bottom).offset(4).priority(.high)
      make.leading.trailing.bottom.equalTo(self).priority(.high)
    }
    textFieldActiveLine.snp.makeConstraints{ (make) in
      make.height.equalTo(2)
      make.width.equalTo(0)
      make.top.equalTo(textFieldLine.snp.top)
      make.leading.trailing.bottom.equalTo(self).priority(.high)
    }
  }
  func bindRx() {
    self.textView.rx.didBeginEditing
    .subscribe(onNext: { [weak self] (_) in
      UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: ({
        self?.textFieldActiveLine.layer.frame = (self?.rectForBorder(isFilled: true))!
      }))
    }).disposed(by: disposebag)
    
    self.textView.rx.didEndEditing
    .subscribe(onNext: { [weak self] (_) in
      UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: ({
        self?.textFieldActiveLine.layer.frame = (self?.rectForBorder(isFilled: false))!
      }))
    }).disposed(by: disposebag)
  }
}

class LineAnimateTextFieldView: UIView {
  let disposebag = DisposeBag()
  func configure(title: String, placeHodeler: String, Font: UIFont) {
    self.descriptionLabel.text = title
    self.textField.font = Font
    self.textField.attributedPlaceholder = NSAttributedString(
      string: placeHodeler,
      attributes:
      [NSAttributedString.Key.foregroundColor: UIColor.grey01,
       NSAttributedString.Key.font: Font])
    
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    layout()
    attribute()
  }
  func layout(){
    self.addSubview(middleTextView)
    middleTextView.addSubview(descriptionLabel)
    middleTextView.addSubview(textField)
    middleTextView.addSubview(textFieldLine)
    middleTextView.addSubview(textFieldActiveLine)
    
    middleTextView.snp.makeConstraints{ (make) in
      make.top.equalTo(self.snp.top)
      make.bottom.equalTo(self.snp.bottom)
      make.left.equalTo(self.snp.left)
      make.right.equalTo(self.snp.right)
    }
    descriptionLabel.snp.makeConstraints{ (make) in
      make.top.equalTo(middleTextView.snp.top)
      make.left.equalTo(middleTextView.snp.left)
      make.right.equalTo(middleTextView.snp.right)
    }
    textField.snp.makeConstraints{ (make) in
      make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
      make.left.equalTo(middleTextView.snp.left)
      make.right.equalTo(middleTextView.snp.right)
//      make.height.equalTo(25)
    }
    textFieldLine.snp.makeConstraints{ (make) in
      make.height.equalTo(2)
      make.top.equalTo(textField.snp.bottom).offset(4)
      make.left.equalTo(middleTextView.snp.left)
      make.right.equalTo(middleTextView.snp.right)
      make.bottom.equalTo(middleTextView.snp.bottom)
    }
    textFieldActiveLine.snp.makeConstraints{ (make) in
      make.height.equalTo(2)
      make.top.equalTo(textField.snp.bottom).offset(4)
      make.left.equalTo(middleTextView.snp.left)
      make.width.equalTo(0)
      make.bottom.equalTo(middleTextView.snp.bottom)
    }
    
  }
  func attribute(){
    textField.rx.controlEvent(.editingDidBegin)
      .subscribe(onNext: { [weak self] (_) in
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: ({
          self?.textFieldActiveLine.layer.frame = (self?.rectForBorder(isFilled: true))!
        }))
      }).disposed(by: disposebag)
    
    textField.rx.controlEvent(.editingDidEnd)
      .subscribe(onNext: { [weak self] (_) in
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: ({
          self?.textFieldActiveLine.layer.frame = (self?.rectForBorder(isFilled: false))!
        }))
      }).disposed(by: disposebag)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  lazy var middleTextView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.font = .sb14
    return label
  }()
  lazy var textField: UITextField = {
    let text = UITextField()
    text.placeholder = "이메일 주소를 입력해 주세요."
    text.clearButtonMode = UITextField.ViewMode.whileEditing
    text.textColor = .black
    text.font = .r14
    text.tintColor = .black
    return text
  }()
  lazy var textFieldLine: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = DefaullStyle.lightGray
    return view
  }()
  lazy var textFieldActiveLine: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .black
    return view
  }()
  
  private func rectForBorder(isFilled: Bool) -> CGRect {
    if isFilled {
      return CGRect(origin: CGPoint(x: 0, y: textFieldLine.frame.minY), size: CGSize(width: textFieldLine.frame.width, height: 2))
    } else {
      return CGRect(origin: CGPoint(x: 0, y: textFieldLine.frame.minY), size: CGSize(width: 0, height: 2))
    }
  }
  
}
