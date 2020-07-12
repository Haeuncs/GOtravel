//
//  AccountMainViewControllerNew.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/08/18.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxDataSources
import RealmSwift

class AccountMainViewController: UIViewController {
  var disposeBag = DisposeBag()
  let realm = try! Realm()

  let viewModel_: AccountMainType
  
  init(tripMoneyData: [moneyRealm], day: Int) {
    viewModel_ = AccountMainViewModel(data: tripMoneyData, day: day)
    print(tripMoneyData)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
    rx()
    
    self.dayCollectionView.selectItem(at: IndexPath(row: self.viewModel_.input.selectedDay.value, section: 0),
                                      animated: true,
                                      scrollPosition: .centeredHorizontally)
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.viewModel_.input.selectedDay.accept(self.viewModel_.input.selectedDay.value)
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  func rx() {
    
    self.viewModel_.input.tripMoneyData
      .bind(to: dayCollectionView.rx.items(cellIdentifier: "exchangeCVCell", cellType: ExchangeCVCell.self)) { row, element, cell in
        if row == 0 {
          cell.dayLabel.text = "여행전"
        } else {
          cell.dayLabel.text = "\(row) 일"
        }
    }.disposed(by: disposeBag)
    
    self.dayCollectionView.rx.itemSelected
      .subscribe(onNext: { (indexPath) in
        self.viewModel_.input.selectedDay.accept(indexPath.row)
      }).disposed(by: disposeBag)
    
    self.viewModel_.output.specificDayDetail
      .subscribe(onNext: { (data) in
        self.setMoneyLabel(money: Array(data))
      }).disposed(by: disposeBag)
    

    self.accountDayTableView.rx.itemDeleted
      .subscribe(onNext: { (indexPath) in
        RealmManager.shared
          .deleteTripSpecificReceipt(data: self.viewModel_.input.tripMoneyData.value[self.viewModel_.input.selectedDay.value],
                                     index: indexPath.row,
                                     complete: {
                                      self.viewModel_.input.selectedDay.accept(self.viewModel_.input.selectedDay.value)
          })
      }).disposed(by: disposeBag)

    self.viewModel_.output.specificDayDetail
      .bind(to: accountDayTableView.rx.items(cellIdentifier: "exchangeTVC", cellType: ExchangeCell.self)) { row, element, cell in
        cell.label1.text = element.subTitle
        cell.label2.text = element.title
        cell.label3.text = "\(Formatter.decimal.string(from: NSNumber(value: element.money)) ?? "0") 원"
    }.disposed(by: disposeBag)
    
    self.viewModel_.output.specificDayDetail
      .subscribe(onNext: { (data) in
        if data.count == 0 {
          self.accountDayTableView.setEmptyMessage("X_X\n 이 날짜에 데이터가 없습니다. \n 데이터를 추가해주세요")
        } else {
          self.accountDayTableView.restore()
        }
      }).disposed(by: disposeBag)

    Observable
      .zip(self.accountDayTableView.rx.modelSelected(moneyDetailRealm.self), self.accountDayTableView.rx.itemSelected)
      .bind { [weak self] moneyDetail, indexPath in
        let vc = DirectAddReceiptViewController()
        vc.realmMoneyList = self?.viewModel_.output.specificDayDetail.value
        vc.editMoneyDetailRealm = moneyDetail
        self?.navigationController?.pushViewController(vc, animated: true)
    }.disposed(by: disposeBag)
    
  }
  func initView(){

    view.backgroundColor = .white
    view.addSubview(navView)
    view.addSubview(dayCollectionView)
    view.addSubview(moneyView)
    view.addSubview(accountDayTableView)
    
    navView.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.height.equalTo(44)
    }
    dayCollectionView.snp.makeConstraints { (make) in
      make.top.equalTo(navView.snp.bottom)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.height.equalTo(100)
    }
    moneyView.snp.makeConstraints { (make) in
      make.top.equalTo(dayCollectionView.snp.bottom)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.height.equalTo(60)
    }
    accountDayTableView.snp.makeConstraints { (make) in
      make.top.equalTo(moneyView.snp.bottom)
      make.left.equalTo(view.snp.left)
      make.right.equalTo(view.snp.right)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }
  lazy var navView: CustomNavigationBarView = {
    let view = CustomNavigationBarView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setTitle(title: "여행 경비")
    view.setButtonDoneText(title: "추가")
    view.setLeftForBack()
    view.dismissBtn.addTarget(self, action: #selector(popEvent), for: .touchUpInside)
    view.actionBtn.addTarget(self, action: #selector(saveEvent), for: .touchUpInside)
    return view
  }()

  lazy var dayCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    let collect = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collect.contentInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16  )
    collect.translatesAutoresizingMaskIntoConstraints = false
    collect.register(ExchangeCVCell.self, forCellWithReuseIdentifier: "exchangeCVCell")
    collect.backgroundColor = .white
    collect.delegate = self
    return collect
  }()
  let moneyView : ExchangeSubView = {
    let label = ExchangeSubView()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  let accountDayTableView : UITableView = {
    let table = UITableView()
//    table.isEditing = true
    table.rowHeight = 110
    table.separatorStyle = .none
    table.backgroundColor = .white
    table.translatesAutoresizingMaskIntoConstraints  = false
    table.register(ExchangeCell.self, forCellReuseIdentifier: "exchangeTVC")
    return table
  }()

}

extension AccountMainViewController {
  @objc func saveEvent(){
//    let vc = DirectAddAccountViewController()
    let vc = DirectAddReceiptViewController()
    vc.realmMoneyList = self.viewModel_.output.specificDayDetail.value
    self.navigationController?.pushViewController(vc, animated: true)
  }
  @objc func popEvent(){
    self.navigationController?.popViewController(animated: true)
  }
}

//extension AccountMainViewController: UICollectionViewDelegate {
//  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//    let model = self.viewModel.value[indexPath.row]
//    self.setMoneyLabel(money: model)
//    self.cellSelected.accept(Array(model.detailList))
//    self.selectedIndex.accept(indexPath.row)
//    if model.detailList.count == 0 {
//      self.accountDayTableView.setEmptyMessage("X_X\n 이 날짜에 데이터가 없습니다. \n 데이터를 추가해주세요")
//    }else{
//      self.accountDayTableView.restore()
//    }
//  }
//}
//
extension AccountMainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
  {
    return CGSize(width: 60, height: 60)
  }
}

// MARK: - logic
extension AccountMainViewController {
  func setMoneyLabel(money: [moneyDetailRealm]){
    var dayTotal = 0
    var allTotal = 0
    for i in money {
      dayTotal = Int(i.money) + dayTotal
    }
    for i in self.viewModel_.input.tripMoneyData.value {
      for j in i.detailList {
        allTotal = Int(j.money) + allTotal
      }
    }
    moneyView.dayView.moneyLabel.text = "\(dayTotal.toNumber()) 원"
    moneyView.totalView.moneyLabel.text = "\(allTotal.toNumber()) 원"

  }
}
