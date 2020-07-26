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
import TravelDesignSystem

enum MyTheme {
    case light
    case dark
}

var categoryArr = ["항공","숙박","쇼핑","식사","교통비","기타"]

class AddTripDateViewController: BaseUIViewController {

    enum Constant {
        static let title = "여행 기간 설정 🗓"
        enum TextField {
            static let title = "여행 일정을 설정하세요."
            static let text = "여행 시작일, 종료일을 추가하세요."
        }

        enum Dday {
            static let font = UIFont.b20
            static let textColor = UIColor.black
        }
        static let confirmTitle = "일정 추가하기"
    }

    var newTripData: Trip
    var theme = MyTheme.dark

    lazy var textfield: TextFieldWithDescriptionView = {
        let view = TextFieldWithDescriptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textField.isEnabled = false
        view.textField.text = Constant.TextField.title
        view.titleLabel.text = Constant.TextField.text
        return view
    }()

    lazy var confirmButton: AccentButton = {
        let button = AccentButton(title: Constant.confirmTitle)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return button
    }()

    let ddayLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.textAlignment = .center
        label.font = Constant.Dday.font
        label.textColor = Constant.Dday.textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let calenderView: CalenderView = {
        let v = CalenderView(theme: MyTheme.dark)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    init(newTripData: Trip) {
        self.newTripData = newTripData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
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

    func configureLayout() {
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
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-45)
        }
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

    @objc func buttonClicked(){
        saveRealmData()
        self.navigationController?.popToRootViewController(animated: true)
    }
}
