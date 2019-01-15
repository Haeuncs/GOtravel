//
//  addDetailView.swift
//  GOtravel
//
//  Created by OOPSLA on 15/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

class addDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    func initView(){
        // 뷰 겹치는거 방지
        self.navigationController!.navigationBar.isTranslucent = false
        view.backgroundColor = .white
        mainView.addSubview(countryLabel)
        mainView.addSubview(subLabel)
        mainView.addSubview(dateLabel)
        
        view.addSubview(mainView)
        
        scheduleView.addSubview(testLabel)
        dateView.addSubview(dateViewLabel)
        view.addSubview(scheduleStackView)
        // constraint
        
        let scheduleViewHeight = NSLayoutConstraint(item: dateView, attribute: .width, relatedBy: .equal, toItem: scheduleView, attribute: .width, multiplier: 0.25, constant: 0.0)

        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
//            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            countryLabel.topAnchor.constraint(equalTo: mainView.topAnchor),
            countryLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            countryLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            
            subLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor),
            subLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            subLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: subLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            // data size에 맞추기 위한 앵커
            mainView.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            
//            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: mainView.bottomAnchor)
            scheduleStackView.topAnchor.constraint(equalTo: mainView.bottomAnchor),
            scheduleStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scheduleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scheduleStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            dateViewLabel.topAnchor.constraint(equalTo: dateView.topAnchor),
            dateViewLabel.leadingAnchor.constraint(equalTo: dateView.leadingAnchor),
            dateViewLabel.trailingAnchor.constraint(equalTo: dateView.trailingAnchor),
//            dateViewLabel.bottomAnchor.constraint(equalTo: dateView.bottomAnchor),

            testLabel.topAnchor.constraint(equalTo: scheduleView.topAnchor),
            testLabel.leadingAnchor.constraint(equalTo: scheduleView.leadingAnchor),
            testLabel.trailingAnchor.constraint(equalTo: scheduleView.trailingAnchor),

            scheduleViewHeight
//            testView.topAnchor.constraint(equalTo: scheduleStackView.topAnchor),
//            testView.leadingAnchor.constraint(equalTo: scheduleStackView.leadingAnchor),
//            testView.trailingAnchor.constraint(equalTo: scheduleStackView.trailingAnchor),
//            testView.bottomAnchor.constraint(equalTo: scheduleStackView.bottomAnchor),

            
            ])
        

//        scheduleViewHeight.isActive = true


    }
    // titleView label 정의
    var countryLabel : UILabel = {
        let label = UILabel()
        label.text = "일본 여행 🗺"
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var subLabel : UILabel = {
        let label = UILabel()
        label.text = "오사카 교토"
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var dateLabel : UILabel = {
        let label = UILabel()
        label.text = "2019.02.10~2019.02.16 5박6일"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var dateViewLabel : UILabel = {
        let label = UILabel()
        label.text = "2019.02.10~2019.02.16 5박6일"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var testLabel : UILabel = {
        let label = UILabel()
        label.text = "2019.02.10~2019.02.16 5박6일"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var dateView : UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var scheduleView : UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var scheduleMainTableView : UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .yellow
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    
    // title을 갖는 뷰
    lazy var mainView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    lazy var allStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [mainStackView , scheduleStackView])
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [countryLabel , subLabel, dateLabel])
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        return stackView
    }()
    lazy var scheduleStackView : UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateView,scheduleView])
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .blue
        return stackView
    }()

}
