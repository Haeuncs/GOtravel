//
//  realmData.swift
//  GOtravel
//
//  Created by OOPSLA on 13/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import RealmSwift
import MapKit

//class categoryRealm : Object {
//    var categoryList = List<categoryDetailRealm>()
//}
class countryRealm : Object{
    @objc dynamic var country: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var date: Date?
    // 여행 기간, 몇 일인지 저장한다.
    @objc dynamic var period: Int = 0
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var latitude: Double = 0.0
    var dayList = List<dayRealm>()
    var moneyList = List<moneyRealm>()
    var categoryList = List<categoryDetailRealm>()
}
// 경비 카테고리
class categoryDetailRealm : Object {
    @objc dynamic var title: String = ""
}
// 0 은 여행 전 돈 쓴거
class moneyRealm : Object {
    @objc dynamic var day: Int = 0
    var detailList = List<moneyDetailRealm>()
}

class moneyDetailRealm : Object {
    @objc dynamic var title: String = ""
    @objc dynamic var subTitle: String = ""
    @objc dynamic var exchange: String = ""
    @objc dynamic var money: Double = 0.0
}

class dayRealm : Object {
    @objc dynamic var day: Int = 0
    var detailList = List<detailRealm>()
}

class detailRealm : Object{
    @objc dynamic var title: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var longitude: Double = 0.0
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var startTime: Date?
    @objc dynamic var EndTime: Date?
    @objc dynamic var color: String = ""
    @objc dynamic var memo: String = ""
    @objc dynamic var oneLineMemo: String = ""


}
class ExchangeRealm : Object{
    @objc dynamic var name: String = ""
    @objc dynamic var exchangeName: String = ""
    @objc dynamic var krWon: Double = 0.0
}
