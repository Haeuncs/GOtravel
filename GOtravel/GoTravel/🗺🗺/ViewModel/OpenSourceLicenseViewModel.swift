//
//  OpenSourceLicenseViewModel.swift
//  Fitco
//
//  Created by Daisy on 30/07/2019.
//  Copyright © 2019 Fitco. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class OpenSourceLicenseViewModel {
  let openSourceArr: [OpenSourceLicenseModel] = [
    OpenSourceLicenseModel(title: "IQKeyboardManagerSwift", author: URL(string: "https://github.com/hackiftekhar/IQKeyboardManager/blob/master/LICENSE.md")!, license: "MIT License"),
    OpenSourceLicenseModel(title: "CenteredCollectionView", author: URL(string: "https://github.com/BenEmdon/CenteredCollectionView/blob/master/LICENSE")!, license: "MIT License"),
    OpenSourceLicenseModel(title: "SnapKit", author: URL(string: "https://github.com/SnapKit/SnapKit/blob/develop/LICENSE")!, license: "MIT License"),
    OpenSourceLicenseModel(title: "RxSwift", author: URL(string: "https://github.com/ReactiveX/RxSwift/blob/master/LICENSE.md")!, license: "MIT License"),
    OpenSourceLicenseModel(title: "EasyTipView", author: URL(string: "https://github.com/teodorpatras/EasyTipView/blob/master/LICENSE")!, license: "MIT License"),
    OpenSourceLicenseModel(title: "Realm", author: URL(string: "https://github.com/realm/realm-cocoa/blob/master/LICENSE")!, license: "MIT License"),
    OpenSourceLicenseModel(title: "Icon Image", author: URL(string: "https://www.flaticon.com/authors/smashicons")!, license: "Icon made by [https://www.flaticon.com/authors/smashicons] from www.flaticon.com"),
  OpenSourceLicenseModel(title: "Icon Image", author: URL(string: "https://www.flaticon.com/authors/freepik")!, license: "Icon made by [https://www.flaticon.com/authors/freepik] from www.flaticon.com"),
  OpenSourceLicenseModel(title: "App Icon Image", author: URL(string: "https://www.flaticon.com/authors/photo3idea-studio")!, license: "icon made by [https://www.flaticon.com/authors/photo3idea-studio] from www.flaticon.com"),
  ]
  lazy var data: Driver<[OpenSourceLicenseModel]> = {
    return Observable.of(openSourceArr).asDriver(onErrorJustReturn: [])
  }()
  
}
