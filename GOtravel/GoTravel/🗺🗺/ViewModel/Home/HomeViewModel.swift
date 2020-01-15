//
//  HomeViewModel.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/01/16.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift


class HomeViewModel {
  
  var tripData = BehaviorSubject(value: [countryRealm]())
  let realm = try? Realm()
  
  init(service: HomeModelService) {
    
    guard let readmData = realm?.objects(countryRealm.self) else {
      tripData.onNext([])
      return
    }
    let data = service.orderByDate(data: readmData)
    tripData.onNext(data)
  }
  
  
}
