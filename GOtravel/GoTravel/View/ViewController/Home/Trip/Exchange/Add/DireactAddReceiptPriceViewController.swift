//
//  DireactAddReceiptPriceViewController.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/03/23.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum DirectAddReceiptPriceType {
  case korean
  case other
}
private enum DirectAddConstant {
  static let koreanTitle: String = "한화 적용"
  static let otherTitle: String = "환율 적용"
}
class DireactAddReceiptPriceViewController: UIViewController {
  weak var directAddReceiptDelegate: DireactAddReceiptDelegate?
  
  private var viewModel: DirectAddReceiptPriceViewModelType = DirectAddReceiptPriceViewModel()
  
  private var disposeBag = DisposeBag()
  private var priceText: String = "0" {
    didSet {
      self.viewModel.input.money.onNext(priceText)
      let numberFormatter = NumberFormatter()
      numberFormatter.numberStyle = NumberFormatter.Style.decimal
      let value = numberFormatter.string(from: NSNumber(value: Int(priceText) ?? 0))
      
      switch currentType {
      case .korean:
        self.titleLabel.text = String(value ?? "0") + "원"
      case .other:
        self.titleLabel.text = String(value ?? "0") + (self.exchangeModel?.value.korName)! + "은/는"
      }
    }
  }
  private var currentType: DirectAddReceiptPriceType
  private var exchangeModel: ExchangeSelectModel?
  
  init(type: DirectAddReceiptPriceType, exchangeModel: ExchangeSelectModel? = nil) {
    self.currentType = type
    self.exchangeModel = exchangeModel
    super.init(nibName: nil, bundle: nil)
    switch currentType {
    case .korean:
      self.navView.setTitle(title: DirectAddConstant.koreanTitle)
    case .other:
      //예) 일본 환율 적용
      self.viewModel.input.exchangeModel.onNext(exchangeModel!)
      self.navView.setTitle(title: exchangeModel!.value.country + " " + DirectAddConstant.otherTitle)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    initView()
    bindRx()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  // View ✨
  func initView() {
    view.addSubview(navView)
    view.addSubview(titleContentView)
    view.addSubview(numberInputStackView)
    navView.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.equalTo(view.snp.leading)
      make.trailing.equalTo(view.snp.trailing)
      make.height.equalTo(44)
    }
    titleContentView.snp.makeConstraints { (make) in
      make.top.equalTo(navView.snp.bottom)
      make.leading.equalTo(view.snp.leading)
      make.trailing.equalTo(view.snp.trailing)
      make.bottom.equalTo(numberInputStackView.snp.top)
    }
    numberInputStackView.snp.makeConstraints { (make) in
      make.height.equalTo(76*3)
      make.leading.equalTo(view.snp.leading).offset(48)
      make.trailing.equalTo(view.snp.trailing).offset(-48)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-48)
    }
    
    switch currentType {
    case .korean:
      titleContentView.addSubview(titleLabel)
      titleLabel.snp.makeConstraints { (make) in
        make.center.equalTo(titleContentView)
      }
    case .other:
      titleContentView.addSubview(titleLabel)
      titleContentView.addSubview(calculatedLabel)
      
      titleLabel.textAlignment = .left
      calculatedLabel.textAlignment = .right
      
      titleLabel.snp.makeConstraints { (make) in
        make.leading.equalTo(view.snp.leading).offset(48)
        make.trailing.equalTo(view.snp.trailing)
        make.bottom.equalTo(titleContentView.snp.centerY).offset(-28)
      }
      calculatedLabel.snp.makeConstraints { (make) in
        make.top.equalTo(titleContentView.snp.centerY).offset(28)
        make.leading.equalTo(view.snp.leading)
        make.trailing.equalTo(view.snp.trailing).offset(-48)
        
      }
    }
  }
  // Bind 🏷
  func bindRx() {
    self.navView.dismissBtn.rx.tap
      .subscribe(onNext: { (_) in
        self.navigationController?.popViewController(animated: true)
      }).disposed(by: disposeBag)
    
    self.navView.actionBtn.rx.tap
      .subscribe(onNext: { (_) in
        let nav = self.navigationController
        switch self.currentType {
        case .korean:
          self.directAddReceiptDelegate?.addKoreanPrice(price: self.priceText)
          nav?.popViewController(animated: true)
        case .other:
          self.directAddReceiptDelegate?.addExchangePrice(exchange: (self.exchangeModel?.foreignName!)!, price: self.viewModel.output.calculatedKor.value)
          nav?.popViewController(animated: false)
          nav?.popViewController(animated: true)

        }
      }).disposed(by: disposeBag)
    
    self.viewModel.output.calculatedKor.subscribe(onNext: { (double) in

      let num = String(format: "%.2f", double).toDouble() ?? 0

      let value = Formatter.decimal.string(from: NSNumber(value: num)) ?? "0"
      self.calculatedLabel.text = value + "원"
    }).disposed(by: disposeBag)
  }
  
  lazy var navView: CustomNavigationBarView = {
    let view = CustomNavigationBarView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setTitle(title: "한화 추가")
    view.setLeftIcon(image: UIImage(named: "back")!)
    view.setButtonDoneText(title: "확인")
    return view
  }()
  lazy var titleContentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = priceText
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .sb28
    label.textAlignment = .center
    return label
  }()
  lazy var calculatedLabel: UILabel = {
    let label = UILabel()
    label.text = priceText
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .sb28
    label.textAlignment = .center
    return label
  }()
  
  lazy var numberInputStackView: UIStackView = {
    let view = UIStackView(arrangedSubviews: [stackView123, stackView456, stackView789, stackView0])
    view.translatesAutoresizingMaskIntoConstraints = false
    view.axis = .vertical
    view.alignment = .fill
    view.distribution = .fillEqually
    return view
  }()
  lazy var stackView123: ThreeItemStackView = {
    let view = ThreeItemStackView(first: 1, second: 2, third: 3)
    view.firstButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    view.secondButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    view.thirdButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var stackView456: ThreeItemStackView = {
    let view = ThreeItemStackView(first: 4, second: 5, third: 6)
    view.firstButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    view.secondButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    view.thirdButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var stackView789: ThreeItemStackView = {
    let view = ThreeItemStackView(first: 7, second: 8, third: 9)
    view.firstButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    view.secondButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    view.thirdButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var stackView0: DeleteCancelNumberStackView = {
    let view = DeleteCancelNumberStackView(second: 0)
    view.secondButton.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
    view.thirdButton.addTarget(self, action: #selector(deleteDidTap(_:)), for: .touchUpInside)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  @objc func deleteDidTap(_ sender: UIButton) {
    if priceText != "0" {
      if priceText.count > 0 {
        priceText = String(priceText.dropLast())
      } else {
        priceText = "0"
      }
    }
  }
  @objc func buttonDidTap(_ sender: UIButton) {
    if priceText == "0" {
      priceText = String(sender.tag)
    } else {
      if priceText.count == 7 {
        Toast.show(message: "백만 단위까지 입력할 수 있어요 😮", isTabbar: false)
      } else {
        priceText += String(sender.tag)
      }
    }
  }
}

class ThreeItemStackView: UIStackView {
  
  init(first: Int, second: Int, third: Int) {
    super.init(frame: .zero)
    self.axis = .horizontal
    self.alignment = .fill
    self.distribution = .fillEqually
    self.spacing = 60
    
    self.addArrangedSubview(firstButton)
    self.addArrangedSubview(secondButton)
    self.addArrangedSubview(thirdButton)
    
    self.firstButton.tag = first
    self.secondButton.tag = second
    self.thirdButton.tag = third
    
    self.firstButton.setTitle(String(first), for: .normal)
    self.secondButton.setTitle(String(second), for: .normal)
    self.thirdButton.setTitle(String(third), for: .normal)
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var firstButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = .sb27
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  lazy var secondButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = .sb27
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  lazy var thirdButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = .sb27
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitleColor(.black, for: .normal)
    return button
  }()
}
class DeleteCancelNumberStackView: UIStackView {
  
  init(second: Int) {
    super.init(frame: .zero)
    self.axis = .horizontal
    self.alignment = .fill
    self.distribution = .fillEqually
    self.spacing = 60
    
    self.addArrangedSubview(firstButton)
    self.addArrangedSubview(secondButton)
    self.addArrangedSubview(thirdButton)
    
    self.secondButton.tag = second
    
    self.firstButton.setTitle("", for: .normal)
    self.secondButton.setTitle(String(second), for: .normal)
    self.thirdButton.setTitle("←", for: .normal)
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var firstButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = .sb27
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  lazy var secondButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = .sb27
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  lazy var thirdButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = .sb27
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitleColor(.black, for: .normal)
    return button
  }()
}
