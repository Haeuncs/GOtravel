//
//  Realm.swift
//  GOtravel
//
//  Created by OOPSLA on 10/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation

// swiftlint:disable all
class realmTravelDetailInfo : Object{
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate = Date()
    @objc dynamic var name = ""
    @objc dynamic var address = ""
    @objc dynamic var color = ""
}
class realmTravelInfo : Object{
    var travel = List<realmTravelInfo>()
    @objc dynamic var city = ""
    @objc dynamic var startDate = Date()
    @objc dynamic var endDate = Date()
}
// swiftlint:enable all
