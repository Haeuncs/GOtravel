
//
//  addDetailViewTableViewCell.swift
//  GOtravel
//
//  Created by OOPSLA on 16/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

class AddDetailTableViewCell: UITableViewCell {

    weak var mydelegate: addDetailViewTableViewCellDelegate?

    // MARK: VC로 부터 전달받는 데이터
    var isEditMode: Bool = false
    // avoid realm transaction
    var planByDay: PlanByDays?

    override func prepareForReuse() {
        super.prepareForReuse()
        planByDay = nil
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(planByDay: PlanByDays, isEditMode: Bool) {
        self.planByDay = planByDay
        self.isEditMode = isEditMode

        if planByDay.plans.isEmpty == false {
            detailScheduleTableView.allowsSelection = true
            detailScheduleTableView.isEditing = isEditMode
        }
        else {
            detailScheduleTableView.isEditing = false
            detailScheduleTableView.allowsSelection = false
        }

        detailScheduleTableView.reloadData()
    }

    func initView(){
        detailScheduleTableView.register(
            TravelPlanCell.self,
            forCellReuseIdentifier: TravelPlanCell.reuseIdentifier
        )
        detailScheduleTableView.register(
            TravelEmptyPlanCell.self,
            forCellReuseIdentifier: TravelEmptyPlanCell.reuseIdentifier
        )

        detailScheduleTableView.delegate = self
        detailScheduleTableView.dataSource = self
        detailScheduleTableView.separatorStyle = .none
        detailScheduleTableView.rowHeight = UITableView.automaticDimension
        detailScheduleTableView.estimatedRowHeight = 200
        detailScheduleTableView.isScrollEnabled = false

        initLayout()
    }

    func initLayout(){
        contentView.backgroundColor = .white

        contentView.addSubview(detailScheduleTableView)
        contentView.addSubview(paddingViewBottom)
        contentView.addSubview(dateView)

        dateView.snp.makeConstraints { (make) in
            make.top.leading.equalTo(contentView).offset(16)
            make.width.height.equalTo(66)
        }
        detailScheduleTableView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(12)
            make.trailing.equalTo(contentView)
            make.leading.equalTo(dateView.snp.trailing)
            make.bottom.equalTo(paddingViewBottom.snp.top)
        }
        NSLayoutConstraint.activate([
            paddingViewBottom.heightAnchor.constraint(equalToConstant: 42),
            paddingViewBottom.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            paddingViewBottom.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            paddingViewBottom.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

        ])
    }
    // MARK: Cell 에서 사용하는 것들
    lazy var dateView: TripDateView = {
        let view = TripDateView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.zeplinStyleShadows(color: .black, alpha: 0.16, x: 0, y: 3, blur: 6, spread: 0)
        return view
    }()
    lazy var detailScheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.tag = 1
        tableView.backgroundColor = .white
        tableView.separatorColor = DefaullStyle.subTitleColor
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.backgroundColor = UIColor.clear
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    var paddingViewBottom: AddDetailViewCellButtonView = {
        let view = AddDetailViewCellButtonView()
        //        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

}

extension AddDetailTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if planByDay?.plans.isEmpty ?? true {
            return 1
        }
        return planByDay?.plans.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let plans = planByDay?.plans else {
            return UITableViewCell()
        }

        if plans.isEmpty {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TravelEmptyPlanCell.reuseIdentifier,
                for: indexPath) as? TravelEmptyPlanCell else {
                return UITableViewCell()
            }
            return cell
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TravelPlanCell.reuseIdentifier, for: indexPath) as? TravelPlanCell else {

            return UITableViewCell()
        }

        cell.configure(plan: plans[indexPath.row])
        return cell
    }
}

extension AddDetailTableViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mydelegate?.addDetailViewTableViewCellDidTapInTableView(
            self,
            detailIndex: indexPath.row
        )
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        isEditMode
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if planByDay?.plans.count == 0 {
            return .none
        }
        return .delete
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return isEditMode
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        guard var planByDay = planByDay else {
            return
        }

        if planByDay.plans.count != 0 {
            let currentMove = planByDay.plans[sourceIndexPath.row]
//            try! self.realm.write {
            planByDay.plans.remove(at: sourceIndexPath.row)
            planByDay.plans.insert(currentMove, at: destinationIndexPath.row)
//            }
            mydelegate?.reorderEvet(planByDay: planByDay)
        }
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        guard var planByDay = planByDay else {
            return
        }

        if editingStyle == .delete {
//            try! self.realm.write {
            planByDay.plans.remove(at: indexPath.row)
//            }
            self.mydelegate?.tableViewDeleteEvent(planByDay: planByDay)

        }
    }
}
