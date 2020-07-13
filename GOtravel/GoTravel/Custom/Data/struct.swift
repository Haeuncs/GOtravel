//
//  struct.swift
//  GOtravel
//
//  Created by OOPSLA on 18/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import GoogleMaps

// addDetailView cell 사용함
struct TableData
{
    var section: String = ""
    var data = Array<String>()
    init(){}
}

// placeSearchViewControleler 에서 사용함, 데이터 임시 저장

struct PlaceInfo {
    var title: String = ""
    var address: String = ""
    var placeID: String = ""
    var location: CLLocationCoordinate2D?
    init(){}

}
