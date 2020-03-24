//
//  DirectExchangeViewController.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/08/10.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RealmSwift

/**
 환율 단위 직접 입력
 */
class DirectAddExchangeViewController: UIViewController {
  var disposeBag = DisposeBag()
  var exchangeName = BehaviorSubject(value: "환율 단위")
  let realm = try? Realm()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    initView()
    rx()
    exchangeName.on(.next("환율 단위"))
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    disposeBag = DisposeBag()
  }
  func rx(){
    navView.dismissBtn.rx.tap
      .subscribe(onNext: { (_) in
        self.dismiss(animated: true, completion: nil)
      }).disposed(by: disposeBag)
    navView.actionBtn.rx.tap
      .subscribe(onNext: { (_) in
        let exchange = ExchangeRealm()
        exchange.name = self.nameTextField.textField.text!
        exchange.exchangeName = self.exchangeNameTextField.textField.text!
        exchange.krWon = self.krWonTextField.textField.text!.toDouble()!
        try! self.realm?.write {
          self.realm?.add(exchange)
        }
        self.dismiss(animated: true, completion: nil)
      }).disposed(by: disposeBag)
    
    exchangeName
      .subscribe(onNext: { (s) in
        self.krWonTextField.descriptionLabel.text = "1 \(s) 당 원"
        self.krWonTextField.textField.placeholder = "1 \(s) 당 한화(원)을 입력해주세요"
      }).disposed(by: disposeBag)
    
    nameTextField.textField.rx.text.orEmpty
      .subscribe(onNext: { (s) in
        self.checkAllFieldFill()
      }).disposed(by: disposeBag)
    exchangeNameTextField.textField.rx.text.orEmpty
      .subscribe(onNext: { (s) in
        self.checkAllFieldFill()
        self.exchangeName.on(.next(s))
      }).disposed(by: disposeBag)
    krWonTextField.textField.rx.text.orEmpty
      .subscribe(onNext: { (s) in
        self.checkAllFieldFill()
      }).disposed(by: disposeBag)
  }
  func initView(){
    view.addSubview(navView)
    view.addSubview(textStackView)
    textStackView.addArrangedSubview(nameTextField)
    textStackView.addArrangedSubview(exchangeNameTextField)
    textStackView.addArrangedSubview(krWonTextField)
    //    textStackView.addArrangedSubview(descriptionLabel)
    navView.snp.makeConstraints{ (make) -> Void in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.height.equalTo(44)
    }
    
    textStackView.snp.makeConstraints{ (make) in
      make.top.equalTo(navView.snp.bottom).offset(20)
      make.left.equalTo(view.snp.left).offset(16)
      make.right.equalTo(view.snp.right).offset(-16)
      make.bottom.lessThanOrEqualTo(view.snp.bottom)
    }
  }
  lazy var navView: CustomNavigationBarView = {
    let view = CustomNavigationBarView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setTitle(title: "환율 직접 설정하기")
    view.setButtonTitle(title: "저장")
    view.setButtonEnabled(enabled: false)
    return view
  }()
  lazy var textStackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.spacing = 30
    return stack
  }()
  lazy var nameTextField: LineAnimateTextFieldView = {
    let text = LineAnimateTextFieldView()
    text.descriptionLabel.text = "이름"
    text.textField.placeholder = "알아 보실 수 있는 이름을 입력해주세요."
    text.translatesAutoresizingMaskIntoConstraints = false
    return text
  }()
  lazy var exchangeNameTextField: LineAnimateTextFieldView = {
    let text = LineAnimateTextFieldView()
    text.descriptionLabel.text = "환율 단위"
    text.textField.placeholder = "알아 보실 수 있는 환율 단위를 입력해주세요. (예: KRW)"
    text.textField.keyboardType = .alphabet
    text.translatesAutoresizingMaskIntoConstraints = false
    return text
  }()
  lazy var krWonTextField: LineAnimateTextFieldView = {
    let text = LineAnimateTextFieldView()
    text.descriptionLabel.text = "1 환율 단위 당 원"
    text.textField.placeholder = "1 환율 단위 당 한화(원)을 입력해주세요"
    text.textField.keyboardType = .decimalPad
    text.translatesAutoresizingMaskIntoConstraints = false
    return text
  }()
}


// MARK: - Logic
extension DirectAddExchangeViewController {
  /// 모든 필드가 채워졌는가?
  func checkAllFieldFill(){
    if exchangeNameTextField.textField.text != "" &&
      krWonTextField.textField.text != "" &&
      nameTextField.textField.text != "" {
      navView.setButtonEnabled(enabled: true)
    }else{
      navView.setButtonEnabled(enabled: false)
    }
  }
}
