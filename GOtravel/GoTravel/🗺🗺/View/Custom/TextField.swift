////
////  TextField.swift
////  GOtravel
////
////  Created by LEE HAEUN on 2020/03/09.
////  Copyright © 2020 haeun. All rights reserved.
////
//
//import SnapKit
//import RxSwift
//import RxCocoa
//
//class LineAnimateTextFieldView: UIView {
//  var disposebag = DisposeBag()
//
//  func configure(placeHodeler: String, Font: UIFont) {
//    self.textField.font = Font
//    self.textField.attributedPlaceholder = NSAttributedString(
//      string: placeHodeler,
//      attributes:
//      [NSAttributedString.Key.foregroundColor: UIColor.grey01,
//       NSAttributedString.Key.font: Font])
//
//  }
//  
//  private var activeLineWidth: NSLayoutConstraint?
//  
//  override init(frame: CGRect) {
//    super.init(frame: frame)
//    layout()
//    attribute()
//  }
//  func layout() {
//    self.addSubview(middleTextView)
//    middleTextView.addSubview(textField)
//    middleTextView.addSubview(textFieldLine)
//    middleTextView.addSubview(textFieldActiveLine)
//
//    middleTextView.snp.makeConstraints { (make) in
//      make.top.equalTo(self.snp.top)
//      make.bottom.equalTo(self.snp.bottom)
//      make.left.equalTo(self.snp.left)
//      make.right.equalTo(self.snp.right)
//    }
//    textField.snp.makeConstraints { (make) in
//      make.top.equalTo(middleTextView.snp.top)
//      make.left.equalTo(middleTextView.snp.left)
//      make.right.equalTo(middleTextView.snp.right)
////      make.height.equalTo(25)
//    }
//    textFieldLine.snp.makeConstraints { (make) in
//      make.height.equalTo(2)
//      make.top.equalTo(textField.snp.bottom).offset(4)
//      make.left.equalTo(middleTextView.snp.left)
//      make.right.equalTo(middleTextView.snp.right)
//      make.bottom.equalTo(middleTextView.snp.bottom)
//    }
//    textFieldActiveLine.snp.makeConstraints { (make) in
//      make.height.equalTo(2)
//      make.top.equalTo(textField.snp.bottom).offset(4)
//      make.left.equalTo(middleTextView.snp.left)
//      make.bottom.equalTo(middleTextView.snp.bottom)
//    }
//    activeLineWidth = textFieldActiveLine.widthAnchor.constraint(equalToConstant: 0)
//    activeLineWidth?.isActive = true
//  }
//  func attribute() {
//    textField.rx.controlEvent(.editingDidBegin)
//      .subscribe(onNext: { [weak self] (_) in
//        self?.activeLineWidth?.constant = self?.textFieldLine.frame.width ?? 0
//        UIView.animate(withDuration: 0.33, delay: 0.1, options: .curveEaseInOut, animations: ({
//          self?.layoutIfNeeded()
//        }))
//      }).disposed(by: disposebag)
//
//    textField.rx.controlEvent(.editingDidEnd)
//      .subscribe(onNext: { [weak self] (_) in
//        self?.activeLineWidth?.constant = 0
//        UIView.animate(withDuration: 0.33, delay: 0.1, options: .curveEaseInOut, animations: ({
//          self?.layoutIfNeeded()
//        }))
//      }).disposed(by: disposebag)
//  }
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//  lazy var middleTextView: UIView = {
//    let view = UIView()
//    view.translatesAutoresizingMaskIntoConstraints = false
//    return view
//  }()
//  lazy var textField: UITextField = {
//    let text = UITextField()
//    text.placeholder = "이메일 주소를 입력해 주세요."
//    text.autocapitalizationType = UITextAutocapitalizationType.none
//    text.attributedPlaceholder = NSAttributedString(
//      string: text.placeholder ?? "",
//      attributes:
//      [NSAttributedString.Key.foregroundColor: UIColor.grey01,
//       NSAttributedString.Key.font: UIFont.r14])
//    text.clearButtonMode = UITextField.ViewMode.whileEditing
//    text.textColor = .grey05
//    text.font = .r14
//    text.tintColor = .grey05
//    return text
//  }()
//  lazy var textFieldLine: UIView = {
//    let view = UIView()
//    view.translatesAutoresizingMaskIntoConstraints = false
//    view.backgroundColor = .grey01
//    return view
//  }()
//  lazy var textFieldActiveLine: UIView = {
//    let view = UIView()
//    view.translatesAutoresizingMaskIntoConstraints = false
//    view.backgroundColor = .grey05
//    return view
//  }()
//  private func rectForBorder(isFilled: Bool) -> CGRect {
//    if isFilled {
//      return CGRect(origin: CGPoint(x: 0, y: textFieldLine.frame.minY), size: CGSize(width: textFieldLine.frame.width, height: 2))
//    } else {
//      return CGRect(origin: CGPoint(x: 0, y: textFieldLine.frame.minY), size: CGSize(width: 0, height: 2))
//    }
//  }
//
//}
