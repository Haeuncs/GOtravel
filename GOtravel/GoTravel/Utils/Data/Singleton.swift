//
//  Singleton.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/07/31.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation

class Singleton {
  static let shared = Singleton()
  private init() {
  }
  private var _googleMapAPIKey: String?
  
  var googleMapAPIKey: String? {
    get {
      return _googleMapAPIKey
    }
    set(new) {
      _googleMapAPIKey = new
    }
  }
}
