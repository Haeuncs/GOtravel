//
//  HomeVM.swift
//  GOtravel
//
//  Created by OOPSLA on 08/02/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

protocol mainVC_protocol {
    var countryTitle : String{get}
    var cityTitle : String{get}
    var ddayTitle : String{get}
    
}
struct  mainVC_CVC_ViewModel: mainVC_protocol{
    var countryTitle : String
    var cityTitle : String
    var ddayTitle : String
    
    init(_ model : countryRealm) {
        self.countryTitle = model.country
        self.cityTitle = model.city
        self.ddayTitle = ""
        
        // d - day 계산
        let intervalToday = model.date?.timeIntervalSince(Date())
        // optional check
        if let intervalToday = intervalToday {
            var dday = Int(intervalToday / 86400)
            if dday >= 0 {
                self.ddayTitle = "D-\(dday+1)"
            }else{
                dday = dday * -1
                self.ddayTitle = "+\(dday+1)일"
            }
        }
    }
}

