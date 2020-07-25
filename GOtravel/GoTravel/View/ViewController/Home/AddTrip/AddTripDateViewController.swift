//
//  calendarViewController.swift
//  GOtravel
//
//  Created by OOPSLA on 14/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SnapKit

enum MyTheme {
  case light
  case dark
}

var categoryArr = ["항공","숙박","쇼핑","식사","교통비","기타"]

class AddTripDateViewController: BaseUIViewController {

    var newTripData: Trip
  
  var theme = MyTheme.dark

    init(newTripData: Trip) {
        self.newTripData = newTripData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "여행 기간 설정 🗓"
    initializeView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.extendedLayoutIncludesOpaqueBars = true
    if let customTabBarController = self.tabBarController as? TabbarViewController {
      customTabBarController.hideTabBarAnimated(hide: true, completion: nil)
    }
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
  }

  func saveRealmData(){
    let periodWithLastDay = calenderView.dateRange.count
    guard let firstDate = calenderView.firstDate else {
            return
    }

    newTripData.date = firstDate
    newTripData.period = periodWithLastDay

    var mockPlanByDays = [PlanByDays]()
    var mockPayByDays = [PayByDays]()

    for i in 1...periodWithLastDay {
      // 디테일 기록 데이
        mockPlanByDays.append(PlanByDays(day: i, plans: []))
        mockPayByDays.append(PayByDays(day: i - 1, pays: []))
    }
    mockPayByDays.append(PayByDays(day: periodWithLastDay, pays: []))

    newTripData.planByDays = mockPlanByDays
    newTripData.payByDays = mockPayByDays

    // FIXIT: Move to VM
    TripCoreDataManager.shared.add(newData: newTripData)

  }
  func initializeView(){
    self.view.backgroundColor = .white
    let availableWidth = view.frame.width - 7 - 10
    let widthPerItem = availableWidth / 7
//    view.addSubview(navView)
    self.isDismiss = false
    view.addSubview(textfield)
    view.addSubview(calenderView)
    view.addSubview(confirmButton)

    textfield.snp.makeConstraints { (make) in
      make.top.equalTo(baseView.snp.bottom).offset(6)
      make.leading.equalTo(view.snp.leading).offset(16)
      make.trailing.equalTo(view.snp.trailing).offset(-16)
    }

    calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
    calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
    calenderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    calenderView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    calenderView.heightAnchor.constraint(equalToConstant: 70 + (widthPerItem * 6)).isActive = true

    confirmButton.snp.makeConstraints { (make) in
      make.height.equalTo(56)
      make.leading.equalTo(view.snp.leading).offset(16)
      make.trailing.equalTo(view.snp.trailing).offset(-16)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-45)
      
    }
    
  }
  @objc func buttonClicked(){
    saveRealmData()
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  lazy var textfield: TextFieldWithDescriptionView = {
    let view = TextFieldWithDescriptionView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textField.isEnabled = false
    view.textField.text = "여행 일정을 설정하세요."
    view.titleLabel.text = "여행 시작일, 종료일을 추가하세요."
    return view
  }()

  lazy var confirmButton: BottomButton = {
    let button = BottomButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.title = "일정 추가하기"
    button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
    return button
  }()

  let ddayLabel: UILabel = {
    let label = UILabel()
    label.text = ""
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
    
  let calenderView: CalenderView = {
    let v = CalenderView(theme: MyTheme.dark)
    v.translatesAutoresizingMaskIntoConstraints = false
    return v
  }()
  
}
