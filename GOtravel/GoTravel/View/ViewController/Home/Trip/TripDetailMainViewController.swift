//
//  addDetailView.swift
//  GOtravel
//
//  Created by OOPSLA on 15/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
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
    func tableViewDeleteEvent(_ sender: AddDetailTableViewCell)
    func reorderEvet(planByDay: DayPlan)
}

protocol TripDetailDataPopupDelegate: class {
    func TripDetailDataPopupMoney(day: Int)
    func TripDetailDataPopupSchedule(day: Int)
    func TripDetailDataPopupPath(day: Int)
}

class TripDetailMainViewController: BaseUIViewController, addDetailViewTableViewCellDelegate {
    func reorderEvet(planByDay: DayPlan) {
        let newDetailList = List<detailRealm>()
        for data in planByDay.detailList {
            newDetailList.append(data)
        }
        countryRealmForEdit[planByDay.day - 1].detailList = planByDay.detailList

//        try! self.realm.write {
//
//        }
    }

    let impact = UIImpactFeedbackGenerator()

    var isPlanEditMode: Bool = false {
        didSet {
            editPlanStackView.isHidden = !isPlanEditMode
        }
    }

    let realm = try! Realm()

    let countryRealmDB: countryRealm
    var countryRealmForEdit = [DayPlan]()

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
    init(travelData: countryRealm) {
        self.countryRealmDB = travelData
        for data in travelData.dayList {
            countryRealmForEdit.append(DayPlan(day: data.day, detailList: Array(data.detailList)))
        }
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scheduleMainTableView.reloadData()
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
        tripDescriptionView.countryLabel.text = countryRealmDB.country
        tripDescriptionView.subLabel.text = countryRealmDB.city

        let dateFormatter = DateFormatter()
        let DBDate = Calendar.current.date(byAdding: .day, value: countryRealmDB.period - 1, to: countryRealmDB.date!)
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateFormatter.locale = Locale(identifier: "ko-KR")
        //    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let startDay = dateFormatter.string(from: countryRealmDB.date!)
        let endDay = dateFormatter.string(from: DBDate!)

        tripDescriptionView.dateLabel.text = "\(startDay) ~ \(endDay)"+"    "+"\(countryRealmDB.period - 1)박 \(countryRealmDB.period)일"
        //        scheduleMainTableView.reloadData()
    }

    // MARK: OBJC

    @objc func saveEditPlans() {
        isPlanEditMode = false
        scheduleMainTableView.reloadData()
    }

    @objc func cancelEditPlans() {
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
                    try! self.realm.write {
                        self.realm.delete(self.countryRealmDB)
                    }
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

        let vc = TripDetailPopupViewController()
        vc.setup(self.countryRealmDB, day: indexPath.row, delegate: self)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
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
}

// MARK: delegate 정의 (cell 에서 사용한다.)
extension TripDetailMainViewController {

    func addDetailViewTableViewCellDidTapInTableView(_ sender: AddDetailTableViewCell, detailIndex: Int) {
        guard let tappedIndexPath = scheduleMainTableView.indexPath(for: sender) else { return }
        beforeSelectRowForScroll = tappedIndexPath.row
        //        print(detailIndex)
        //        dismiss(animated: true, completion: nil)
        let changeVC = TripDetailSpecificDayViewController()
        changeVC.detailRealmDB = countryRealmDB.dayList[tappedIndexPath.row].detailList[detailIndex]
        changeVC.countryRealmDB = countryRealmDB
        self.navigationController?.pushViewController(changeVC, animated: true)
    }
    func tableViewDeleteEvent(_ sender: AddDetailTableViewCell) {
        guard let tappedIndexPath = scheduleMainTableView.indexPath(for: sender) else { return }
        print("tab", sender, tappedIndexPath)
        self.scheduleMainTableView.reloadData()
    }

}

extension TripDetailMainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
        // 지금은 select 이벤트 없음
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowCount = countryRealmForEdit[indexPath.row].detailList.count
        if rowCount == 0 {
            return CGFloat(80 * 1 + (SizeConstant.paddingSize))
        }
        else{
            return CGFloat(80 * rowCount + (SizeConstant.paddingSize))
        }
    }
}
extension TripDetailMainViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryRealmForEdit.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddDetailTableViewCell

        cell.configure(
            planByDate: countryRealmForEdit[indexPath.row],
            isEditMode: isPlanEditMode
        )

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko-KR")
        let DBDate = Calendar.current.date(byAdding: .day, value: countryRealmDB.dayList[indexPath.row].day - 1, to: countryRealmDB.date!)

        dateFormatter.setLocalizedDateFormatFromTemplate("e")

        let day = dateFormatter.string(from: DBDate ?? Date())
        cell.dateView.dayOfTheWeek.text = day + "요일"
        cell.dateView.dateLabel.text = String(countryRealmDB.dayList[indexPath.row].day) + "일차"

        cell.paddingViewBottom.addButton.addTarget(self, action: #selector(moreDidTap(_:)), for: .touchUpInside)

        cell.mydelegate = self

        return cell
    }

}
extension TripDetailMainViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // 버튼 animate 원상복구
    }
}

extension TripDetailMainViewController{
    @objc func pushExchangeViewController(){
        let vc = AccountMainViewController(tripMoneyData: Array(self.countryRealmDB.moneyList), day: 0)
        //    vc.countryRealmDB = self.countryRealmDB
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TripDetailMainViewController: TripDetailDataPopupDelegate {
    func TripDetailDataPopupMoney(day: Int) {
        // 여행 전 경비가 있음으로 + 1
        let vc = AccountMainViewController(tripMoneyData: Array(self.countryRealmDB.moneyList), day: day + 1)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func TripDetailDataPopupSchedule(day: Int) {
        let placeVC = AddTripViewController(searchType: .place)
        placeVC.countryRealmDB = countryRealmDB
        placeVC.dayRealmDB = countryRealmDB.dayList[day]
        self.navigationController?.pushViewController(placeVC, animated: true)
    }

    func TripDetailDataPopupPath(day: Int) {
        guard let tripDetail = countryRealmDB.dayList[day].detailList.first else {
            return
        }
        let dayDetail = countryRealmDB.dayList[day].detailList

        let tripRouteViewController = TripRouteViewController(day: day, tripDetail: tripDetail, dayDetail: dayDetail)
        self.navigationController?.pushViewController(tripRouteViewController, animated: true)
    }
}
