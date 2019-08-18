//
//  ExchangeSelectViewModel.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/08/13.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


struct ExchangeSelectModel{
  /// 국가이름(혹은 알아볼 수 있는)
  /// 달러 같은거
  let value: ExchangeCountry
  /// KWR 같은거
  let foreignName: String?
  /// 계산에 쓰이는 double
  var calculateDouble: Double
}
class ExchangeSelectViewModel {
  
  let selectedPublish = PublishSubject<ExchangeSelectModel>()
  var selected: Observable<ExchangeSelectModel> {
    return selectedPublish.asObserver()
  }

}
