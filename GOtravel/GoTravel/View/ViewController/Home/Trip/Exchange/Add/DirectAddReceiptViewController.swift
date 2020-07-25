////
////  DirectAddReceiptViewController.swift
////  GOtravel
////
////  Created by LEE HAEUN on 2020/03/12.
////  Copyright © 2020 haeun. All rights reserved.
////
//
//import UIKit
//import SnapKit
//import RxSwift
//import RxCocoa
//
//
//
//enum ReceiptDetailType {
//  case edit
//  case add
//}
//protocol DireactAddReceiptDelegate: class {
//  func addKoreanPrice(price: String)
//  func addExchangePrice(exchange: String, price: Double)
//}
//class DirectAddReceiptViewController: UIViewController {
//  private var disposeBag = DisposeBag()
//  private var viewModel: DirectAddReceiptViewModelType = DirectAddReceiptViewModel()
//
//  /// 이전 viewcontroller 에서 받는 값 (선택된 여행 일자)
//  var realmMoneyList: List<moneyDetailRealm>?
//  /// 데이터 수정일 때 받는 값
//  var editMoneyDetailRealm: moneyDetailRealm?
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    view.backgroundColor = .white
//    initView()
//    bindRx()
//    
//    if let editMoney = self.editMoneyDetailRealm {
//      self.configureDetail(moneyDetail: editMoney)
//    }
//  }
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated)
//  }
//  override func viewWillDisappear(_ animated: Bool) {
//    super.viewWillDisappear(animated)
//  }
//  // View ✨
//  func initView() {
//    view.addSubview(navView)
//    view.addSubview(memoTextField)
//    view.addSubview(categoryLabel)
//    view.addSubview(categoryCollectionView)
//    view.addSubview(moneyLabel)
//    view.addSubview(moneySegmentControl)
//    view.addSubview(moneyWrapper)
//    moneyWrapper.addSubview(moneyDataLabel)
//    
//    navView.snp.makeConstraints { (make) in
//      make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
//      make.height.equalTo(44)
//    }
//    memoTextField.snp.makeConstraints{ (make) in
//      make.top.equalTo(navView.snp.bottom).offset(24)
//      make.leading.equalTo(view.snp.leading).offset(16)
//      make.trailing.equalTo(view.snp.trailing).offset(-16)
//    }
//    categoryLabel.snp.makeConstraints { (make) in
//      make.top.equalTo(memoTextField.snp.bottom).offset(24)
//      make.leading.equalTo(view.snp.leading).offset(16)
//      make.trailing.equalTo(view.snp.trailing).offset(-16)
//    }
//    categoryCollectionView.snp.makeConstraints { (make) in
//      make.top.equalTo(categoryLabel.snp.bottom)
//      make.leading.trailing.equalTo(view)
//      make.height.equalTo(200)
//    }
//    moneyLabel.snp.makeConstraints { (make) in
//      make.top.equalTo(categoryCollectionView.snp.bottom).offset(24)
//      make.leading.equalTo(view.snp.leading).offset(16)
//      make.trailing.equalTo(view.snp.trailing).offset(-16)
//    }
//    moneySegmentControl.snp.makeConstraints { (make) in
//      make.top.equalTo(moneyLabel.snp.bottom).offset(24)
//      make.leading.equalTo(view.snp.leading).offset(16)
//      make.trailing.equalTo(view.snp.trailing).offset(-16)
//    }
//    moneyWrapper.snp.makeConstraints { (make) in
//      make.top.equalTo(moneySegmentControl.snp.bottom).offset(24)
//      make.leading.trailing.equalTo(view)
//      make.bottom.equalTo(view.safeAreaLayoutGuide)
//    }
//    moneyDataLabel.snp.makeConstraints { (make) in
//      make.leading.trailing.equalTo(moneyWrapper)
//      make.center.equalTo(moneyWrapper)
//    }
//  }
//  // Bind 🏷
//  func bindRx() {
//
//    viewModel.output.saveEnabled.subscribe(onNext: { (bool) in
//      self.navView.actionBtn.isEnabled = bool
//      }).disposed(by: disposeBag)
//
//    self.navView.dismissBtn.rx.tap
//      .subscribe(onNext: { (_) in
//        self.navigationController?.popViewController(animated: true)
//      }).disposed(by: disposeBag)
//    
//    self.navView.actionBtn.rx.tap
//      .subscribe(onNext: { (_) in
//        do {
//          if let editData = self.editMoneyDetailRealm {
//            try self.realm.write {
//              editData.title = self.viewModel.input.title.value!
//              editData.subTitle = self.viewModel.input.subTitle.value!
//              editData.exchange = self.viewModel.input.exchangeName.value!
//              editData.money = self.viewModel.input.money.value
//            }
//            self.navigationController?.popViewController(animated: true)
//          } else {
//            let moneyDetailRealmDB = moneyDetailRealm()
//            if var data = self.realmMoneyList {
//              moneyDetailRealmDB.money = self.viewModel.input.money.value
//              moneyDetailRealmDB.title = self.viewModel.input.title.value!
//              moneyDetailRealmDB.exchange = self.viewModel.input.exchangeName.value!
//              moneyDetailRealmDB.subTitle = self.viewModel.input.subTitle.value!
//              try self.realm.write {
//                data.append(moneyDetailRealmDB)
//              }
//              self.navigationController?.popViewController(animated: true)
//            }
//          }
//        } catch {
//          return
//        }
//      }).disposed(by: disposeBag)
//    
//    self.memoTextField.textField.rx.text.orEmpty
//      .bind(to: self.viewModel.input.title)
//      .disposed(by: disposeBag)
//    
//    viewModel.output.categories.asObservable()
//      .bind(to: self.categoryCollectionView.rx.items(cellIdentifier: "cell", cellType: DirectAddAccountCell.self)) { _, element, cell in
//        cell.directAddAccountModel = element
//    }.disposed(by: disposeBag)
//    
//    self.categoryCollectionView.rx.modelSelected(DirectAddAccountModel.self)
//      .subscribe(onNext: { (model) in
//        self.viewModel.input.subTitle.accept(model.title)
//      }).disposed(by: disposeBag)
//    
//    moneySegmentControl.rx.controlEvent(.valueChanged)
//      .subscribe(onNext: { (_) in
//        if self.moneySegmentControl.selectedSegmentIndex == 0 {
//          let vc = DireactAddReceiptPriceViewController(type: .korean)
//          vc.directAddReceiptDelegate = self
//          self.navigationController?.pushViewController(vc, animated: true)
//        } else {
//          let vc = ExchangeSelectCountryViewController()
//          vc.directAddReceiptDelegate = self
//          self.navigationController?.pushViewController(vc, animated: true)
//        }
//      }).disposed(by: disposeBag)
//    
//    self.viewModel.input.money
//    .subscribe(onNext: { (double) in
//      let value = Formatter.decimal.string(from: NSNumber(value: double )) ?? "0"
//      self.moneyDataLabel.text = value + "원"
//    }).disposed(by: disposeBag)
//  }
//  
//  func configureDetail(moneyDetail: moneyDetailRealm) {
//    
//    self.viewModel.input.title.accept(moneyDetail.title)
//    self.viewModel.input.money.accept(moneyDetail.money)
//    self.viewModel.input.subTitle.accept(moneyDetail.subTitle)
//    self.viewModel.input.exchangeName.accept(moneyDetail.exchange)
//    
//    self.memoTextField.textField.text = moneyDetail.title
//    self.moneyDataLabel.text = Formatter.decimal.string(from: NSNumber(value: moneyDetail.money))
//    self.moneySegmentControl.selectedSegmentIndex = 0
//    
//    let categoryArr = self.viewModel.output.categories.value
//    
//    for i in 0..<self.viewModel.output.categories.value.count {
//      if categoryArr[i].title == moneyDetail.subTitle {
//        self.categoryCollectionView.selectItem(at: IndexPath(row: i, section: 0), animated: true, scrollPosition: .centeredHorizontally)
//      }
//    }
//  }
//  lazy var navView: CustomNavigationBarView = {
//    let view = CustomNavigationBarView()
//    view.translatesAutoresizingMaskIntoConstraints = false
//    view.setTitle(title: "경비 추가")
//    view.setLeftIcon(image: UIImage(named: "back")!)
//    view.setButtonDoneText(title: "저장")
//    
////    view.dismissBtn.addTarget(self, action: #selector(popEvent), for: .touchUpInside)
////    view.actionBtn.addTarget(self, action: #selector(saveEvent), for: .touchUpInside)
//    return view
//  }()
//  lazy var memoTextField: LineAnimateTextFieldView = {
//    let text = LineAnimateTextFieldView()
////    text.textField.delegate = self
//    text.translatesAutoresizingMaskIntoConstraints = false
//    text.textFieldActiveLine.backgroundColor = UIColor.butterscotch
//    text.textField.tintColor = .butterscotch
//    text.descriptionLabel.text = "메모"
//    text.descriptionLabel.font = .sb17
//    text.textField.placeholder = "이 경비에 대한 메모를 남겨주세요!"
//    return text
//  }()
//  lazy var categoryLabel: UILabel = {
//    let label = UILabel()
//    label.text = "카테고리"
//    label.translatesAutoresizingMaskIntoConstraints = false
//    label.textColor = .black
//    label.font = .sb17
//    return label
//  }()
//  lazy var categoryCollectionView: UICollectionView = {
//    let layout = UICollectionViewFlowLayout()
//    layout.scrollDirection = .horizontal
//    layout.sectionInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
//    layout.itemSize = CGSize(width: 84, height: 150)
//    //    layout.minimumInteritemSpacing = 100
//    layout.minimumLineSpacing = 14
//    let collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
//    collect.showsHorizontalScrollIndicator = false
//    collect.register(DirectAddAccountCell.self, forCellWithReuseIdentifier: "cell")
//    collect.backgroundColor = .white
//    collect.translatesAutoresizingMaskIntoConstraints = false
//    return collect
//  }()
//  lazy var moneyLabel: UILabel = {
//    let label = UILabel()
//    label.text = "금액"
//    label.translatesAutoresizingMaskIntoConstraints = false
//    label.textColor = .black
//    label.font = .sb17
//    return label
//  }()
//  lazy var moneySegmentControl: UISegmentedControl = {
//    let seg = UISegmentedControl(items: ["한화", "환율"])
//    seg.translatesAutoresizingMaskIntoConstraints = false
//    return seg
//  }()
//  lazy var moneyWrapper: UIView = {
//    let view = UIView()
//    view.translatesAutoresizingMaskIntoConstraints = false
//    return view
//  }()
//  lazy var moneyDataLabel: UILabel = {
//    let label = UILabel()
//    label.translatesAutoresizingMaskIntoConstraints = false
//    label.font = .sb24
//    label.textAlignment = .center
//    return label
//  }()
//
//}
//
//extension DirectAddReceiptViewController: DireactAddReceiptDelegate {
//  func addExchangePrice(exchange: String, price: Double) {
//    self.viewModel.input.money.accept(price)
//    self.viewModel.input.exchangeName.accept(exchange)
//  }
//  
//  func addKoreanPrice(price: String) {
//    let value = Double(price.split(separator: ",").joined()) ?? 0
//    self.viewModel.input.money.accept(value)
//    self.viewModel.input.exchangeName.accept("")
//  }
//}
