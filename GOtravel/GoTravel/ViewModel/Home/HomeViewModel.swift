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
  
  var tripData = BehaviorSubject(value: [TravelDataType]())
  let realm = try? Realm()
  let realmManager: RealmManagerType = RealmManager()
  
  init(service: HomeModelService) {
    
    guard let readmData = realm?.objects(countryRealm.self) else {
      tripData.onNext([])
      return
    }
    debugPrint(readmData)
    let data = HomeModelService.orderByDate(data: readmData)
    tripData.onNext(data)
  }
  
  func getTripData() {
    self.tripData.onNext(realmManager.getPresentTripData())
  }
  
}
