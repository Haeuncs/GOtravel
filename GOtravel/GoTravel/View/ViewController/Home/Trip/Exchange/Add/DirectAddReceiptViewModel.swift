//
//  DirectAddReceiptViewModel.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/03/23.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol DirectAddReceiptViewModelInputs {
  var title: BehaviorRelay<String?> { get }
  var money: BehaviorRelay<Double> { get }
  var subTitle: BehaviorRelay<String?> { get }
  var exchangeName: BehaviorRelay<String?> { get }
}
protocol DirectAddReceiptViewModelOutputs {
  var categories: BehaviorRelay<[DirectAddAccountModel]> { get }
  var saveEnabled: PublishSubject<Bool> { get }
}
protocol DirectAddReceiptViewModelType {
  var input: DirectAddReceiptViewModelInputs { get }
  var output: DirectAddReceiptViewModelOutputs { get }
}
class DirectAddReceiptViewModel: DirectAddReceiptViewModelInputs, DirectAddReceiptViewModelOutputs, DirectAddReceiptViewModelType {
  private var disposeBag = DisposeBag()
  
  var saveEnabled: PublishSubject<Bool>
  
  var exchangeName: BehaviorRelay<String?>
  var subTitle: BehaviorRelay<String?>
  var title: BehaviorRelay<String?>
  var money: BehaviorRelay<Double>
  
  var categories: BehaviorRelay<[DirectAddAccountModel]>
  
  var input: DirectAddReceiptViewModelInputs { return self }
  var output: DirectAddReceiptViewModelOutputs { return self }
  
  // mock Data
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
  
  init() {
    categories = BehaviorRelay(value: self.categoryArr)
    money = BehaviorRelay(value: 0)
    title = BehaviorRelay(value: nil)
    subTitle = BehaviorRelay(value: nil)
    exchangeName = BehaviorRelay(value: nil)
    saveEnabled = PublishSubject()
    
    Observable.combineLatest(money, title, subTitle, exchangeName)
      .flatMapLatest { (_, title, subTitle, exchangeName) -> Observable<Bool> in
        if title != nil && subTitle != nil && exchangeName != nil {
          return Observable.just(true)
        } else {
          return Observable.just(false)
        }
    }
    .bind(to: self.saveEnabled)
    .disposed(by: disposeBag)
  }
}
