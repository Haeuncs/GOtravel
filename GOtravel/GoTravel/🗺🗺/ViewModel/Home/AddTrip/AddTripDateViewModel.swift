//
//  AddTripDateViewModel.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/01/19.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AddTripDateViewModel {
  
  var selectedDates: BehaviorRelay<[Date]?> = BehaviorRelay(value: nil)
  var showButton: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
  
  init() {
//    self.showButton = selectedDates.asObservable().map({ (dateArr) -> Bool in
//      guard let arr = dateArr else {
//        return false
//      }
//      if arr.isEmpty || arr?.count == 1 {
//        return false
//      }else{
//        return true
//      }
//    })
    
    //    self.showButton = selectedDates.map { (dateArr) -> Bool in
    //      guard let arr = dateArr else {
    //        return false
    //      }
    //      if arr.isEmpty || arr?.count == 1 {
    //        return false
    //      }else{
    //        return true
    //      }
    //    }
  }
}
