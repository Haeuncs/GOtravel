//
//  AccountMainViewModel.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/03/27.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa


protocol AccountMainInput {
  var tripMoneyData: BehaviorRelay<[moneyRealm]> { get }
  var selectedDay: BehaviorRelay<Int> { get }
}

protocol AccountMainOutput {
  var specificDayDetail: BehaviorRelay<List<moneyDetailRealm>> { get }
}

protocol AccountMainType {
  var input: AccountMainInput { get }
  var output: AccountMainOutput { get }
}

class AccountMainViewModel: AccountMainInput, AccountMainOutput, AccountMainType {
  
  var disposeBag = DisposeBag()

  var selectedDay: BehaviorRelay<Int>
  var input: AccountMainInput { return self }
  var output: AccountMainOutput { return self }
  
  var tripMoneyData: BehaviorRelay<[moneyRealm]>
  var specificDayDetail: BehaviorRelay<List<moneyDetailRealm>>
  
  init(data: [moneyRealm], day: Int) {
    self.selectedDay = BehaviorRelay(value: day)
    self.tripMoneyData = BehaviorRelay(value: data)
    self.specificDayDetail = BehaviorRelay(value: data[day].detailList)
    
    self.selectedDay
      .map { (day) -> List<moneyDetailRealm> in
        print("\(day)일 \(self.tripMoneyData.value[day])")
      return self.tripMoneyData.value[day].detailList}
      .bind(to: self.specificDayDetail)
    .disposed(by: disposeBag)
  }
}
