
//
//  Reactive.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/08/18.
//  Copyright © 2019 haeun. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UITableView {
  func isEmpty(message: String) -> Binder<Bool> {
    return Binder(base) { tableView, isEmpty in
      if isEmpty {
        tableView.setNoDataPlaceholder(message)
      } else {
        tableView.removeNoDataPlaceholder()
      }
    }
  }
}
