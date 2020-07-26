//
//  addDetailView.swift
//  GOtravel
//
//  Created by OOPSLA on 15/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift
import SnapKit

public enum SizeConstant {
    public static let paddingSize = 50
}
//let paddingSize = 10
protocol changeDetailVCVDelegate: class {
    func inputData() -> (title: String,startTime: Date,endTime: Date,color: String,memo: String)
}
protocol addDetailViewTableViewCellDelegate: class {
    func addDetailViewTableViewCellDidTapInTableView(_ sender: AddDetailTableViewCell,detailIndex: Int)
    func tableViewDeleteEvent(planByDay: PlanByDays)
    func reorderEvet(planByDay: PlanByDays)
}

protocol TripDetailDataPopupDelegate: class {
    func TripDetailDataPopupMoney(day: Int)
    func TripDetailDataPopupSchedule(day: Int)
    func TripDetailDataPopupPath(day: Int)
}

class TripDetailMainViewController: BaseUIViewController {

    let impact = UIImpactFeedbackGenerator()

    let safeInsetBottom: CGFloat = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0

    var isPlanEditMode: Bool = false {
        didSet {
            editPlanStackView.isHidden = !isPlanEditMode
            scheduleMainTableView.contentInset.bottom = isPlanEditMode ? 56 + 45 + safeInsetBottom : 0
        }
    }

    var tripData: Trip
    var editedPlanByDays: [PlanByDays]

    // scroll 시작 시, 열려있는 버튼이 있을 때 다시 닫을 때 사용
    var currentIndexPath: IndexPath?
    var beforeSelectRowForScroll = 0

    lazy var navView: CustomNavigationBarView = {
        let view = CustomNavigationBarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle(title: "")
        view.setLeftForPop()
        view.setRightIcon(image: UIImage(named: "dots")!)
        view.dismissBtn.addTarget(self, action: #selector(dismissEvent), for: .touchUpInside)
        view.actionBtn.addTarget(self, action: #selector(editEvent), for: .touchUpInside)
        return view
    }()
    // title을 갖는 뷰
    // 여행지랑 몇박 몇일인지 등등
    lazy var tripDescriptionView: TripDescriptionView = {
        let view = TripDescriptionView()
        view.moneyBtn.addTarget(self, action: #selector(pushExchangeViewController), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // 날짜별 테이블뷰
    var scheduleMainTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorColor = DefaullStyle.subTitleColor
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        tableView.allowsSelection = false
        tableView.register(AddDetailTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    lazy var editPlanStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [editCancelButton, editConfirmButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 16
        stack.isHidden = true
        return stack
    }()

    lazy var editConfirmButton: BottomButton = {
        let button = BottomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.title = "수정 완료"
        button.addTarget(self, action: #selector(saveEditPlans), for: .touchUpInside)
        return button
    }()

    lazy var editCancelButton: BottomButton = {
        let button = BottomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.title = "취소"
        button.addTarget(self, action: #selector(cancelEditPlans), for: .touchUpInside)
        return button
    }()

    init(trip: Trip) {
        self.tripData = trip
        self.editedPlanByDays = trip.planByDays
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        isDismiss = true
        scheduleMainTableView.dataSource = self
        scheduleMainTableView.delegate = self
        configureLayout()
        getRealmData()

        NotificationCenter.default.addObserver(self, selector: #selector(tripDataChanged), name: .tripDataChange, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.beforeSelectRowForScroll, section: 0)
            self.scheduleMainTableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func configureLayout() {
        rightNavigationButtonView.button.imageView_.image = UIImage(named: "dots")
        rightNavigationButtonView.button.addTarget(self, action: #selector(settingPlans), for: .touchUpInside)

        view.backgroundColor = .white
        view.addSubview(tripDescriptionView)
        view.addSubview(scheduleMainTableView)
        view.addSubview(editPlanStackView)

        NSLayoutConstraint.activate([
            tripDescriptionView.topAnchor.constraint(equalTo: baseView.bottomAnchor),
            tripDescriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tripDescriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            scheduleMainTableView.topAnchor.constraint(equalTo: tripDescriptionView.bottomAnchor),
            scheduleMainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scheduleMainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scheduleMainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        editPlanStackView.snp.makeConstraints { (make) in
            make.height.equalTo(56)
            make.leading.equalTo(view.snp.leading).offset(16)
            make.trailing.equalTo(view.snp.trailing).offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-45)

        }
    }

    func getRealmData(){
        tripDescriptionView.countryLabel.text = tripData.country
        tripDescriptionView.subLabel.text = tripData.city

        let dateFormatter = DateFormatter()
        let DBDate = Calendar.current.date(
            byAdding: .day,
            value: tripData.period - 1,
            to: tripData.date
        )
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.locale = Locale(identifier: "ko-KR")
        //    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let startDay = dateFormatter.string(from: tripData.date)
        let endDay = dateFormatter.string(from: DBDate!)

        tripDescriptionView.dateLabel.text = "\(startDay) ~ \(endDay)"+"    "+"\(tripData.period - 1)박 \(tripData.period)일"
        //        scheduleMainTableView.reloadData()
    }

    // MARK: OBJC

    @objc func saveEditPlans() {
        tripData.planByDays = editedPlanByDays
        _ = TripCoreDataManager.shared.updateTrip(updateTrip: tripData)
        isPlanEditMode = false
        scheduleMainTableView.reloadData()
    }

    @objc func cancelEditPlans() {
        editedPlanByDays = tripData.planByDays
        isPlanEditMode = false
        scheduleMainTableView.reloadData()
    }

    @objc func alldDleteLabelEvent() {
        let uiAlertControl = UIAlertController(
            title: "여행 데이터 삭제",
            message: "한번 삭제한 데이터는 복구 할 수 없습니다. 삭제하시겠습니까? ",
            preferredStyle: .actionSheet
        )
        uiAlertControl.addAction(
            UIAlertAction(
                title: "삭제",
                style: .destructive,
                handler: { (_) in
                    _ = TripCoreDataManager.shared.deleteTrip(identifier: self.tripData.identifier)
                    self.dismiss(animated: true, completion: nil)
            })
        )
        uiAlertControl.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(uiAlertControl, animated: true, completion: nil)

    }

    @objc func moreDidTap(_ sender: UIButton){
        // 피드백 진동
        impact.impactOccurred()
        let point = sender.convert(CGPoint.zero, to: scheduleMainTableView as UIView)
        guard let indexPath: IndexPath = scheduleMainTableView.indexPathForRow(at: point) else {
            return
        }

        var moreDatas = [
            PullUpPopupDataType(image: UIImage(named: "atm")!, title: "경비 추가하기", handler: { [weak self] in
                guard let self = self else { return }
                self.TripDetailDataPopupMoney(day: indexPath.row)
            }),
            PullUpPopupDataType(image: UIImage(named: "pin")!, title: "일정 추가하기", handler: { [weak self] in
                guard let self = self else { return }
                self.TripDetailDataPopupSchedule(day: indexPath.row)
            }),
        ]

        if tripData.planByDays[indexPath.row].plans.isEmpty == false {
            moreDatas.append(PullUpPopupDataType(image: UIImage(named: "route")!, title: "경로 보기", handler: { [weak self] in
                guard let self = self else { return }
                self.TripDetailDataPopupPath(day: indexPath.row)
            }))
        }

        let currentDate = Calendar.current.date(byAdding: .day, value: indexPath.row, to: tripData.date) ?? Date()

        let title = currentDate.dateToKorString()
        let pullUpViewController = PullUpPopupViewController(
            title: title,
            pullUpDatas: moreDatas
        )
        present(pullUpViewController, animated: true, completion: nil)
    }

    @objc func settingPlans(_ sender: UIButton) {
        impact.impactOccurred()
        let planText = isPlanEditMode ? "일정 수정 완료" : "일정 수정하기"
        let settingDatas = [
            PullUpPopupDataType(image: UIImage(named: "SettingPlanPencil")!, title: planText, handler: { [weak self] in
                guard let self = self else { return }
                self.isPlanEditMode = !self.isPlanEditMode
                self.scheduleMainTableView.reloadData()
            }),
            PullUpPopupDataType(image: UIImage(named: "SettingPlanDelete")!, title: "여행 데이터 전체 삭제하기", handler: { [weak self] in
                guard let self = self else { return }
                self.alldDleteLabelEvent()
            }),
        ]
        let pullUpViewController = PullUpPopupViewController(title: "설정", pullUpDatas: settingDatas)
        present(pullUpViewController, animated: true, completion: nil)
    }

    @objc func editEvent(){
        isPlanEditMode = !isPlanEditMode
        scheduleMainTableView.reloadData()
    }

    @objc func dismissEvent() {
        dismiss(animated: true, completion: nil)
    }

    @objc func tripDataChanged() {
        guard let newTripData = TripCoreDataManager.shared.fetchTrip(identifier: tripData.identifier) else {
            return
        }
        tripData = newTripData
        scheduleMainTableView.reloadData()
    }
}

extension TripDetailMainViewController: addDetailViewTableViewCellDelegate {

    func addDetailViewTableViewCellDidTapInTableView(_ sender: AddDetailTableViewCell, detailIndex: Int) {
        guard let tappedIndexPath = scheduleMainTableView.indexPath(for: sender) else { return }
        beforeSelectRowForScroll = tappedIndexPath.row

        let changeVC = TripDetailSpecificDayViewController(
            trip: tripData,
            plan: tripData.planByDays[tappedIndexPath.row].plans[detailIndex], day: detailIndex
        )
        self.navigationController?.pushViewController(changeVC, animated: true)
    }

    func tableViewDeleteEvent(planByDay: PlanByDays) {
        var deletedPlanByDay = planByDay
        var beforeDelete = tripData.planByDays

        for index in 0 ..< deletedPlanByDay.plans.count {
            deletedPlanByDay.plans[index].displayOrder = Int16(index)
        }

        for index in 0 ..< beforeDelete.count where beforeDelete[index].day == deletedPlanByDay.day {
            beforeDelete[index] = deletedPlanByDay
            break
        }
        tripData.planByDays = beforeDelete
        _ = TripCoreDataManager.shared.updateTrip(updateTrip: tripData)
    }

    func reorderEvet(planByDay: PlanByDays) {
        for index in 0 ..< editedPlanByDays.count where editedPlanByDays[index].day == planByDay.day {
            editedPlanByDays[index] = planByDay
            break
        }
    }
}

extension TripDetailMainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowCount = tripData.planByDays[indexPath.row].plans.count
        if rowCount == 0 {
            return CGFloat(80 * 1 + (SizeConstant.paddingSize))
        }
        else{
            return CGFloat(80 * rowCount + (SizeConstant.paddingSize))
        }
    }
}
extension TripDetailMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripData.planByDays.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddDetailTableViewCell

        cell.configure(
            planByDay: tripData.planByDays[indexPath.row],
            isEditMode: isPlanEditMode
        )

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        let DBDate = Calendar.current.date(byAdding: .day, value: tripData.planByDays[indexPath.row].day - 1, to: tripData.date)

        dateFormatter.setLocalizedDateFormatFromTemplate("e")

        let day = dateFormatter.string(from: DBDate ?? Date())
        cell.dateView.dayOfTheWeek.text = day + "요일"
        cell.dateView.dateLabel.text = String(tripData.planByDays[indexPath.row].day) + "일차"

        cell.paddingViewBottom.addButton.addTarget(self, action: #selector(moreDidTap(_:)), for: .touchUpInside)

        cell.mydelegate = self

        return cell
    }

}

extension TripDetailMainViewController{
    @objc func pushExchangeViewController(){
        let vc = TripCostMainViewController(
            trip: tripData,
            day: 0
        )
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TripDetailMainViewController: TripDetailDataPopupDelegate {
    func TripDetailDataPopupMoney(day: Int) {
        // 여행 전 경비가 있음으로 + 1
        let vc = TripCostMainViewController(
            trip: tripData,
            day: day + 1
        )
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func TripDetailDataPopupSchedule(day: Int) {
        let placeVC = AddTripViewController(searchType: .place, trip: tripData, day: day)
        self.navigationController?.pushViewController(placeVC, animated: true)
    }

    func TripDetailDataPopupPath(day: Int) {
        let tripRouteViewController = TripRouteViewController(
            day: day,
            trip: tripData,
            plans: tripData.planByDays[day].plans
        )
        self.navigationController?.pushViewController(tripRouteViewController, animated: true)
    }
}
