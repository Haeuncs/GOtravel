//
//  DirectAddAccountViewModel.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/08/12.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DirectAddAccountViewModel {
  var foreignCalculateBy100: Bool = false
  var isKoreaMoneySelected = BehaviorSubject<Bool>(value: true)
  
  var isSelectedCategory = BehaviorSubject<Int>(value: 0)
  
  
  let categoryArr: [DirectAddAccountModel] = [
    DirectAddAccountModel(ExampleImage: UIImage(named: "boarding-pass")!, title: "항공비"),
    DirectAddAccountModel(ExampleImage: UIImage(named: "breakfast")!, title: "식비"),
    DirectAddAccountModel(ExampleImage: UIImage(named: "hotel")!, title: "숙박비"),
    DirectAddAccountModel(ExampleImage: UIImage(named: "shop")!, title: "쇼핑"),
    DirectAddAccountModel(ExampleImage: UIImage(named: "tourist")!, title: "투어"),
    DirectAddAccountModel(ExampleImage: UIImage(named: "bus")!, title: "교통비"),
    DirectAddAccountModel(ExampleImage: UIImage(named: "cable-car-cabin")!, title: "관광비"),
    DirectAddAccountModel(ExampleImage: UIImage(named: "diary")!, title: "보험"),
    DirectAddAccountModel(ExampleImage: UIImage(named: "packing")!, title: "기타"),
  ]
  lazy var data: Driver<[DirectAddAccountModel]> = {
    return Observable.of(categoryArr).asDriver(onErrorJustReturn: [])
  }()

}
