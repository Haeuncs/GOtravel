//
//  Dictionary+.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/17.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation

extension Dictionary where Value: Equatable {
  func someKey(forValue val: Value) -> Key? {
    return first(where: { $1 == val })?.key
  }
}
