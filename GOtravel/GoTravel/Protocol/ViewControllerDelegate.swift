//
//  ViewControllerDelegate.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/07/27.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

protocol ViewControllerDelegate {
  func presentView(viewContorller: UIViewController)
  func push(viewContorller: UIViewController)
}
