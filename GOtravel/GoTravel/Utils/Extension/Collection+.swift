//
//  Collection+.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/07/26.
//  Copyright © 2020 haeun. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
   public subscript(safe index: Index) -> Iterator.Element? {
     return (startIndex <= index && index < endIndex) ? self[index] : nil
   }
}
