//
//  DirectAddReceiptViewController.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/03/12.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum ReceiptDetailType {
  case edit
  case add
}

protocol DireactAddReceiptDelegate: class {
  func addKoreanPrice(price: String)
  func addExchangePrice(exchange: String, price: Double)
}
class DirectAddTripCostViewController: UIViewController {
  private var disposeBag = DisposeBag()
  private var viewModel: DirectAddReceiptViewModelType = DirectAddReceiptViewModel()

    let trip: Trip
    let type: ReceiptDetailType
    let day: Int
    let editPay: Pay?

    var currentSelectedCategoryIndexPath: IndexPath?
    init(
        type: ReceiptDetailType,
        trip: Trip,
        day: Int,
        editPay: Pay?
    ) {
        self.type = type
        self.trip = trip
        self.day = day
        self.editPay = editPay

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    initView()
    bindRx()

    if let editMoney = self.editPay {
      self.configureDetail(moneyDetail: editMoney)
    }
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
    view.addSubview(memoTextField)
    view.addSubview(categoryLabel)
    view.addSubview(categoryCollectionView)
    view.addSubview(costView)
//    view.addSubview(moneyLabel)
//    view.addSubview(moneySegmentControl)
//    view.addSubview(moneyWrapper)
//    moneyWrapper.addSubview(moneyDataLabel)

    navView.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(44)
    }
    memoTextField.snp.makeConstraints{ (make) in
      make.top.equalTo(navView.snp.bottom).offset(24)
      make.leading.equalTo(view.snp.leading).offset(16)
      make.trailing.equalTo(view.snp.trailing).offset(-16)
    }
    categoryLabel.snp.makeConstraints { (make) in
      make.top.equalTo(memoTextField.snp.bottom).offset(24)
      make.leading.equalTo(view.snp.leading).offset(16)
      make.trailing.equalTo(view.snp.trailing).offset(-16)
    }
    categoryCollectionView.snp.makeConstraints { (make) in
      make.top.equalTo(categoryLabel.snp.bottom)
      make.leading.trailing.equalTo(view)
      make.height.equalTo(100)
    }
    costView.snp.makeConstraints { (make) in
        make.top.equalTo(categoryCollectionView.snp.bottom).offset(22)
        make.leading.equalTo(view.snp.leading).offset(16)
        make.trailing.equalTo(view.snp.trailing).offset(-16)
    }
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
  }
  // Bind 🏷
  func bindRx() {

    viewModel.output.saveEnabled.subscribe(onNext: { (bool) in
      self.navView.actionBtn.isEnabled = bool
      }).disposed(by: disposeBag)

    self.navView.dismissBtn.rx.tap
      .subscribe(onNext: { (_) in
        self.navigationController?.popViewController(animated: true)
      }).disposed(by: disposeBag)

    self.navView.actionBtn.rx.tap
        .subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            if var editData = self.editPay {
                editData.name = self.viewModel.input.title.value
                editData.krWon = Float(self.viewModel.input.money.value)
                editData.category = self.viewModel.input.subTitle.value ?? ""
                _ = TripManager.shared.updatePay(
                    trip: self.trip,
                    day: self.day,
                    pay: editData
                )
                self.navigationController?.popViewController(animated: true)
            } else {
                let newPay = Pay(
                    exchangeName: nil,
                    krWon: Float(self.viewModel.input.money.value),
                    name: self.viewModel.input.title.value,
                    displayOrder: Int16(0),
                    identifier: UUID(),
                    category: self.viewModel.output.categories.value[self.currentSelectedCategoryIndexPath?.row ?? 0].title
                )
                _ = TripManager.shared.addPay(
                    trip: self.trip,
                    day: self.day,
                    pay: newPay
                )
                self.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)

    self.memoTextField.textField.rx.text.orEmpty
      .bind(to: self.viewModel.input.title)
      .disposed(by: disposeBag)

    viewModel.output.categories.asObservable()
        .bind(to: self.categoryCollectionView.rx.items(
            cellIdentifier: DirectAddTripCostCategoryCell.reuseIdentifier,
            cellType: DirectAddTripCostCategoryCell.self)) { row, element, cell in

                if row == self.currentSelectedCategoryIndexPath?.row {
                    cell.isSelected = true
                }
                cell.titleLabel.text = element.title
    }.disposed(by: disposeBag)

    Observable.zip(
        categoryCollectionView.rx.itemSelected,
        categoryCollectionView.rx.modelSelected(DirectAddAccountModel.self))
        .bind{ [weak self] indexPath, model in
            guard let self = self else { return }
            guard self.currentSelectedCategoryIndexPath != indexPath else { return }
            guard let cell = self.categoryCollectionView.cellForItem(at: indexPath) as? DirectAddTripCostCategoryCell else {
                return
            }

            var reloadIndexPaths = [IndexPath]()
            if let beforeSelectedIndexPath = self.currentSelectedCategoryIndexPath {
                reloadIndexPaths.append(beforeSelectedIndexPath)
            }
            self.currentSelectedCategoryIndexPath = indexPath
            cell.isSelected = true
            self.categoryCollectionView.reloadItems(at: reloadIndexPaths)
    }
    .disposed(by: disposeBag)

    self.categoryCollectionView.rx.modelSelected(DirectAddAccountModel.self)
      .subscribe(onNext: { (model) in
        self.viewModel.input.subTitle.accept(model.title)
      }).disposed(by: disposeBag)

    moneySegmentControl.rx.controlEvent(.valueChanged)
      .subscribe(onNext: { (_) in
//        if self.moneySegmentControl.selectedSegmentIndex == 0 {
          let vc = DireactAddReceiptPriceViewController(type: .korean)
          vc.directAddReceiptDelegate = self
          self.navigationController?.pushViewController(vc, animated: true)
//        } else {
//          let vc = ExchangeSelectCountryViewController()
//          vc.directAddReceiptDelegate = self
//          self.navigationController?.pushViewController(vc, animated: true)
//        }
      }).disposed(by: disposeBag)

    self.viewModel.input.money
    .subscribe(onNext: { (double) in
      let value = Formatter.decimal.string(from: NSNumber(value: double )) ?? "0"
        self.costView.costButton.setTitle(value + "원", for: .normal)
    }).disposed(by: disposeBag)

    costView.costButton.rx.tap
        .subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }
            let vc = DireactAddReceiptPriceViewController(type: .korean)
            vc.directAddReceiptDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
  }

  func configureDetail(moneyDetail: Pay) {

    self.viewModel.input.title.accept(moneyDetail.name)
    self.viewModel.input.money.accept(Double(moneyDetail.krWon))
    self.viewModel.input.subTitle.accept(moneyDetail.category)
    self.viewModel.input.exchangeName.accept(moneyDetail.exchangeName)

    self.memoTextField.textField.text = moneyDetail.name
    self.moneyDataLabel.text = Formatter.decimal.string(from: NSNumber(value: moneyDetail.krWon))
    self.moneySegmentControl.selectedSegmentIndex = 0

    let categoryArr = self.viewModel.output.categories.value

    for i in 0..<self.viewModel.output.categories.value.count {
        if categoryArr[i].title == moneyDetail.category {
            currentSelectedCategoryIndexPath = IndexPath(row: i, section: 0)
            self.categoryCollectionView.selectItem(at: IndexPath(row: i, section: 0), animated: true, scrollPosition: .centeredHorizontally)
      }
    }
  }
  lazy var navView: CustomNavigationBarView = {
    let view = CustomNavigationBarView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setTitle(title: "경비 추가")
    view.setLeftIcon(image: UIImage(named: "back")!)
    view.setButtonDoneText(title: "저장")

//    view.dismissBtn.addTarget(self, action: #selector(popEvent), for: .touchUpInside)
//    view.actionBtn.addTarget(self, action: #selector(saveEvent), for: .touchUpInside)
    return view
  }()
  lazy var memoTextField: LineAnimateTextFieldView = {
    let text = LineAnimateTextFieldView()
//    text.textField.delegate = self
    text.translatesAutoresizingMaskIntoConstraints = false
    text.textFieldActiveLine.backgroundColor = UIColor.butterscotch
    text.textField.tintColor = .butterscotch
    text.descriptionLabel.text = "메모"
    text.descriptionLabel.font = .sb17
    text.textField.placeholder = "이 경비에 대한 메모를 남겨주세요!"
    return text
  }()
  lazy var categoryLabel: UILabel = {
    let label = UILabel()
    label.text = "카테고리"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.font = .sb17
    return label
  }()
  lazy var categoryCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    layout.minimumLineSpacing = 12
    let collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collect.contentInset = UIEdgeInsets(
        top: 14,
        left: 16,
        bottom: 7,
        right: 16
    )
    collect.showsHorizontalScrollIndicator = false
    collect.register(
        DirectAddTripCostCategoryCell.self,
        forCellWithReuseIdentifier: DirectAddTripCostCategoryCell.reuseIdentifier
    )
    collect.backgroundColor = .white
    collect.translatesAutoresizingMaskIntoConstraints = false
    return collect
  }()
    lazy var costView: CostView = {
        let view = CostView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
  lazy var moneyLabel: UILabel = {
    let label = UILabel()
    label.text = "금액"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.font = .sb17
    return label
  }()
  lazy var moneySegmentControl: UISegmentedControl = {
    let seg = UISegmentedControl(items: ["한화", "환율"])
    seg.translatesAutoresizingMaskIntoConstraints = false
    return seg
  }()
  lazy var moneyWrapper: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var moneyDataLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .sb24
    label.textAlignment = .center
    return label
  }()

}

extension DirectAddTripCostViewController: DireactAddReceiptDelegate {
  func addExchangePrice(exchange: String, price: Double) {
    self.viewModel.input.money.accept(price)
    self.viewModel.input.exchangeName.accept(exchange)
  }

  func addKoreanPrice(price: String) {
    let value = Double(price.split(separator: ",").joined()) ?? 0
    self.viewModel.input.money.accept(value)
    self.viewModel.input.exchangeName.accept("")
    self.costView.costButton.setTitle(price + "원", for: .normal)
  }
}


class CostView: UIView {
    lazy var titleLabel: UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.text = "비용"
      label.textColor = .black
      label.font = .sb17
      return label
    }()
    lazy var costButton: CostButton = {
      let button = CostButton()
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setTitle("비용 추가하기", for: .normal)
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
      button.backgroundColor = .greyishTeal
      button.layer.cornerRadius = 8
      button.layer.zeplinStyleShadows(color: .greyishTeal, alpha: 1, x: 0, y: 3, blur: 6, spread: 0)
      return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        addSubview(titleLabel)
        addSubview(costButton)

        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self)
            make.centerY.equalTo(self)
        }
        costButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(self)
            make.centerY.equalTo(self)
            make.height.equalTo(54)
            make.top.equalTo(self).offset(13)
            make.bottom.equalTo(self).offset(-13)
//            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing)
        }
    }
}

class CostButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel?.font = .b18
        titleLabel?.textColor = .white
        titleLabel?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(13)
            make.trailing.equalTo(self).offset(-13)
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
