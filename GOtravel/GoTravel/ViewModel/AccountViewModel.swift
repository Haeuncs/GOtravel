//
//  AccountViewModel.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/08/12.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AccountViewModel {
  /// collectionView 에서 선택된 Index
  var selectedDayIndex = PublishSubject<Int>()
}
