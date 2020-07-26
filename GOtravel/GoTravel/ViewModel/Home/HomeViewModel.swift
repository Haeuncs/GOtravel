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


class HomeViewModel {
  
  var tripData = BehaviorSubject(value: [TripDataType]())

  init(service: HomeModelService) {

    getTripData()
  }
  
  func getTripData() {

    guard let trips = TripCoreDataManager.shared.fetchAllTrip() else {
        tripData.onNext([])
        return
    }

    let data = HomeModelService.orderByDate(trip: trips)
    tripData.onNext(data)
  }
  
}
