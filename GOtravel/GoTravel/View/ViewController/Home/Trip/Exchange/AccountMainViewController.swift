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
import RealmSwift

class AccountMainViewController: UIViewController {
  var disposeBag = DisposeBag()
  let realm = try! Realm()
  
  // TripDetailViewController 에서 전달 받는 데이터
  var tripMoneyRealmDB: List<moneyRealm>? {
    didSet {
      if let data = tripMoneyRealmDB {
        viewModel.accept(Array(data))
      }
    }
  }
  
  
  var viewModel = BehaviorRelay(value: [moneyRealm]())
  var cellSelected = BehaviorRelay(value: [moneyDetailRealm]())
  /// day 값이 있다면 이 값에 데이터 set됨 디폴트는 0임
  var selectedIndex = BehaviorRelay(value: Int())
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
    rx()
    

  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    do {
      cellSelected.accept(Array(viewModel.value[selectedIndex.value].detailList))
      setMoneyLabel(money: viewModel.value[selectedIndex.value])
      dayCollectionView.selectItem(at: IndexPath(row: selectedIndex.value, section: 0), animated: false, scrollPosition: .centeredHorizontally)
      self.collectionView(dayCollectionView, didSelectItemAt: IndexPath(row:  selectedIndex.value, section: 0))
    } catch {
      print(error)
    }

  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
//    disposeBag = DisposeBag()
  }
  func rx(){
    viewModel.asObservable()
      .bind(to: dayCollectionView.rx.items(cellIdentifier: "exchangeCVCell", cellType: exchangeCVCell.self)) { row, model, cell in
        if row == 0 {
          cell.dayLabel.text = "여행전"
        }else{
          cell.dayLabel.text = "\(row) 일"
        }
    }.disposed(by: disposeBag)
    
    cellSelected.asObservable()
      .bind(to: accountDayTableView.rx.items(cellIdentifier: "exchangeTVC", cellType: exchangeTVC.self)) { row, model, cell in
        cell.label1.text = model.subTitle
        cell.label2.text = model.title
        cell.label3.text = "\(Formatter.decimal.string(from: NSNumber(value: model.money)) ?? "0") 원"
      }.disposed(by: disposeBag)

    accountDayTableView.rx.modelSelected(moneyDetailRealm.self)
      .subscribe(onNext: { (moneyDetail) in
        do {
//          let vc = DirectAddAccountViewController()
          let vc = DirectAddReceiptViewController()
          vc.realmMoneyList = try self.viewModel.value[self.selectedIndex.value]
          vc.editMoneyDetailRealm = moneyDetail
          self.navigationController?.pushViewController(vc, animated: true)
        }catch {
          print(error)
        }
      }).disposed(by: disposeBag)
//    navigationItem.rightBarButtonItem?.rx.tap
//      .subscribe(onNext: { (_) in
//        let vc = DirectAddAccountViewController()
//        vc.realmMoneyList = try! self.viewModel.value()[try! self.selectedIndex.value()]
//        self.navigationController?.pushViewController(vc, animated: true)
//      }).disposed(by: disposeBag)
  }
  func initView(){
//    self.navigationItem.title = "여행 경비"
//    self.navigationController?.navigationBar.tintColor = .blackText
//    self.navigationItem.leftBarButtonItem?.tintColor = Defaull_style.mainTitleColor
//    self.navigationItem.rightBarButtonItem?.tintColor = Defaull_style.mainTitleColor
//    let rightButton = UIBarButtonItem(title: "추가", style: .done, target: self, action: nil)
//    self.navigationItem.rightBarButtonItem = rightButton

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
    collect.register(exchangeCVCell.self, forCellWithReuseIdentifier: "exchangeCVCell")
    collect.backgroundColor = .white
    collect.delegate = self
    return collect
  }()
  let moneyView : exchangeSubView = {
    let label = exchangeSubView()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  let accountDayTableView : UITableView = {
    let table = UITableView()
    table.rowHeight = 110
    table.separatorStyle = .none
    table.backgroundColor = .white
    table.translatesAutoresizingMaskIntoConstraints  = false
    table.register(exchangeTVC.self, forCellReuseIdentifier: "exchangeTVC")
    return table
  }()

}

extension AccountMainViewController {
  @objc func saveEvent(){
//    let vc = DirectAddAccountViewController()
    let vc = DirectAddReceiptViewController()
    vc.realmMoneyList = try! self.viewModel.value[self.selectedIndex.value]
    self.navigationController?.pushViewController(vc, animated: true)
  }
  @objc func popEvent(){
    self.navigationController?.popViewController(animated: true)
  }
}

extension AccountMainViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let model = self.viewModel.value[indexPath.row]
    self.setMoneyLabel(money: model)
    self.cellSelected.accept(Array(model.detailList))
    self.selectedIndex.accept(indexPath.row)
    if model.detailList.count == 0 {
      self.accountDayTableView.setEmptyMessage("X_X\n 이 날짜에 데이터가 없습니다. \n 데이터를 추가해주세요")
    }else{
      self.accountDayTableView.restore()
    }
  }
}

extension AccountMainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
  {
    return CGSize(width: 60, height: 60)
  }
}

// MARK: - logic
extension AccountMainViewController {
  func setMoneyLabel(money: moneyRealm){
    var dayTotal = 0
    var allTotal = 0
    for i in money.detailList {
      dayTotal = Int(i.money) + dayTotal
    }
    for i in self.viewModel.value {
      for j in i.detailList {
        allTotal = Int(j.money) + allTotal
      }
    }
    moneyView.dayView.moneyLabel.text = "\(dayTotal.toNumber()) 원"
    moneyView.totalView.moneyLabel.text = "\(allTotal.toNumber()) 원"

  }
}


