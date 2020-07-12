//
//  AddTripViewController_New.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/01/18.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class AddTripViewControllerNew: BaseUIViewController {
  var disposeBag = DisposeBag()
  var viewModel = AddTripViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.isDismiss = false
    initView()
    self.setupHideKeyboardOnTap()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupRx()
    if let customTabBarController = self.tabBarController as? TabbarViewController {
      customTabBarController.hideTabBarAnimated(hide: false, completion: nil)
    }

  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    disposeBag = DisposeBag()
  }
  
  func initView(){
    view.addSubview(textfield)
    view.addSubview(tableView)
    view.addSubview(confirmButton)
    textfield.snp.makeConstraints { (make) in
      make.top.equalTo(baseView.snp.bottom).offset(6)
      make.leading.equalTo(view.snp.leading).offset(16)
      make.trailing.equalTo(view.snp.trailing).offset(-16)
      //      make.bottom.equalTo(self.snp.bottom)
    }
    tableView.snp.makeConstraints { (make) in
      make.top.equalTo(textfield.snp.bottom).offset(22)
      make.leading.equalTo(view.snp.leading)
      make.trailing.equalTo(view.snp.trailing)
      make.bottom.equalTo(view.snp.bottom)
    }
    confirmButton.snp.makeConstraints { (make) in
      make.height.equalTo(56)
      make.leading.equalTo(view.snp.leading).offset(16)
      make.trailing.equalTo(view.snp.trailing).offset(-16)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-45)
      
    }
  }
  func setupRx(){
    textfield.textField.rx.text
      .orEmpty
      .throttle(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .bind(to: viewModel.searchText)
      .disposed(by: disposeBag)
    
    viewModel.places.asObservable()
      .bind(to: tableView.rx.items(
        cellIdentifier: "cell",
        cellType: PlaceSearchTableViewCell.self))
      { [weak self](row, element, cell) in
        cell.titleLabel.text = element.title
        cell.addressLabel.text = element.address
        if row == self?.viewModel.selectedIndex.value {
          cell.imageView_.isHidden = false
        }else{
          cell.imageView_.isHidden = true
        }
    }
    .disposed(by: disposeBag)
    
    tableView.rx.itemSelected
      .subscribe(onNext: { [weak self](indexPath) in
        
        if let beforeSelectedIndex = self?.viewModel.selectedIndex.value {
          let beforeSelectedCell = self?.tableView.cellForRow(
            at: IndexPath(row: beforeSelectedIndex, section: 0))
            as? PlaceSearchTableViewCell
          
          beforeSelectedCell?.imageView_.isHidden = true
          if beforeSelectedIndex == indexPath.row {
            self?.viewModel.selectedIndex.accept(nil)
            self?.viewModel.selectedPlace.accept(nil)
          }else{
            let cell = self?.tableView.cellForRow(at: indexPath) as? PlaceSearchTableViewCell
            cell?.imageView_.isHidden = false
            self?.viewModel.selectedPlace.accept((self?.viewModel.places.value[indexPath.row])!)
            self?.viewModel.selectedIndex.accept(indexPath.row)
          }
        }else{
          let cell = self?.tableView.cellForRow(at: indexPath) as? PlaceSearchTableViewCell
          cell?.imageView_.isHidden = false
          self?.viewModel.selectedPlace.accept((self?.viewModel.places.value[indexPath.row])!)
          self?.viewModel.selectedIndex.accept(indexPath.row)
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.selectedPlace.subscribe(onNext: { [weak self] (selectedPlace) in
      guard let place = selectedPlace else {
        self?.confirmButton.isHidden = true
        return
      }
      self?.confirmButton.isHidden = false
      self?.confirmButton.title = "\(place.title) 여행"
    })
      .disposed(by: disposeBag)
    
    confirmButton.rx.tap
      .subscribe(onNext: { [weak self](_) in
        guard let placeData = self?.viewModel.selectedPlace.value else {
          return
        }
        let countryRealmDB = countryRealm()
        countryRealmDB.city = placeData.address
        countryRealmDB.country = placeData.title
        countryRealmDB.latitude = (placeData.location?.latitude)!
        countryRealmDB.longitude = (placeData.location?.longitude)!
        let calenderVC = AddTripDateViewController()
        calenderVC.popTitle = "도시 검색"
        calenderVC.saveCountryRealmData = countryRealmDB
        self?.navigationController?.pushViewController( calenderVC, animated: true)

//        let googleMapVC = AddTripCheckMapViewController()
//        googleMapVC.selectPlaceInfo = (self?.viewModel.selectedPlace.value!)!
//        googleMapVC.myColor = #colorLiteral(red: 0.8209087171, green: 0.454993382, blue: 0.461091971, alpha: 1)
//        googleMapVC.arrayMap = false
//        googleMapVC.categoryIndex = 1
//        self?.navigationController?.pushViewController(googleMapVC, animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  lazy var textfield: TextFieldWithDescriptionView = {
    let view = TextFieldWithDescriptionView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var tableView : UITableView = {
    let tableView = UITableView()
    tableView.rowHeight = 74
    //    tableView.tag = 1
    tableView.backgroundColor = .white
    //    tableView.separatorColor = Defaull_style.subTitleColor
    tableView.separatorStyle = .none
    //    tableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(PlaceSearchTableViewCell.self, forCellReuseIdentifier: "cell")
    return tableView
  }()
  lazy var confirmButton: BottomButton = {
    let button = BottomButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
}
