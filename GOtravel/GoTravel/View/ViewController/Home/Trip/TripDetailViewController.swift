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

public enum sizeConstant {
  public static let paddingSize = 50
}
//let paddingSize = 10
protocol changeDetailVCVDelegate : class {
  func inputData()->(title:String,startTime:Date,endTime:Date,color:String,memo:String)
}
protocol addDetailViewTableViewCellDelegate : class {
  func addDetailViewTableViewCellDidTapInTableView(_ sender: addDetailTableViewCell,detailIndex : Int)
  func tableViewDeleteEvent(_ sender: addDetailTableViewCell)
}

protocol TripDetailDataPopupDelegate: class {
  func TripDetailDataPopupMoney(day: Int)
  func TripDetailDataPopupSchedule(day: Int)
  func TripDetailDataPopupPath(day: Int)
}

class TripDetailViewController: BaseUIViewController ,addDetailViewTableViewCellDelegate{
  
  // 테이블이 스크롤이 가능하게 할 것인가? -> 편집 클릭 시에 가능하도록! and 삭제 이동 기능도 사용
  var isEdit : Bool? = false
  let realm = try! Realm()
  // push 로 데이터 전달됨
  var countryRealmDB = countryRealm()
  var selectIndex = 0
  // 진동 feedbvar
  let impact = UIImpactFeedbackGenerator()
  
  // scroll 시작 시, 열려있는 버튼이 있을 때 다시 닫을 때 사용
  var currentIndexPath : IndexPath?
  // 각 셀의 버튼은 테이블 당 한개만 나타날 수 있도록 하는 변수
  var beforeSelectIndexPath = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.isDismiss = true
    initView()
    self.navigationController?.navigationBar.isHidden = true
  }
  var selectRow = 0
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    scheduleMainTableView.reloadData()
    DispatchQueue.main.async {
      let indexPath = IndexPath(row: self.selectRow, section: 0)
      self.scheduleMainTableView.scrollToRow(at: indexPath, at: .top, animated: false)
    }
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  func initView(){
    beforeSelectIndexPath = false
    isEdit = false
        
    scheduleMainTableView.register(addDetailTableViewCell.self, forCellReuseIdentifier: "cell")
    
    scheduleMainTableView.dataSource = self
    scheduleMainTableView.delegate = self
    
    view.backgroundColor = .white
    
//    view.addSubview(navView)
    view.addSubview(TripDescriptionView)
    view.addSubview(scheduleMainTableView)
    
    
    let customView = UIStackView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
    customView.alignment = .center
    customView.distribution = .fill
    //        customView.backgroundColor = UIColor.red
    customView.addArrangedSubview(deleteDataLabel)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(TripDetailViewController.alldDleteLabelEvent))
    deleteDataLabel.isUserInteractionEnabled = true
    deleteDataLabel.addGestureRecognizer(tap)
    
    scheduleMainTableView.tableFooterView = customView
    
    
    initLayout()
    getRealmData()
  }
  
  @objc func alldDleteLabelEvent(sender:UITapGestureRecognizer) {
    let uiAlertControl = UIAlertController(title: "여행 데이터 삭제", message: "한번 삭제한 데이터는 복구 할 수 없습니다. 삭제하시겠습니까? ", preferredStyle: .actionSheet)
    
    uiAlertControl.addAction(UIAlertAction(title: "삭제", style: .default, handler: { (_) in
      try! self.realm.write {
        self.realm.delete(self.countryRealmDB)
      }
      self.dismiss(animated: true, completion: nil)
    })
    )
    // 아이패드에서도 작동하기 위해서 사용 popoverController
    uiAlertControl.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
    if let popoverController = uiAlertControl.popoverPresentationController {
      popoverController.barButtonItem = sender as? UIBarButtonItem
    }
    
    self.present(uiAlertControl, animated: true, completion: nil)
    
  }
  
  func initLayout(){
    // constraint
//    navView.snp.makeConstraints { (make) in
//      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//      make.left.equalTo(view.snp.left)
//      make.right.equalTo(view.snp.right)
//      make.height.equalTo(44)
//    }
    NSLayoutConstraint.activate([
      TripDescriptionView.topAnchor.constraint(equalTo: baseView.bottomAnchor),
      TripDescriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      TripDescriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      
      scheduleMainTableView.topAnchor.constraint(equalTo: TripDescriptionView.bottomAnchor),
      scheduleMainTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scheduleMainTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scheduleMainTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      deleteDataLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      deleteDataLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
  }
  func getRealmData(){
    //        countryRealmDB = realm.objects(countryRealm.self).sorted(byKeyPath: "date", ascending: true)[selectIndex]
    
    TripDescriptionView.countryLabel.text = countryRealmDB.country
    TripDescriptionView.subLabel.text = countryRealmDB.city
    
    let dateFormatter = DateFormatter()
    let DBDate = Calendar.current.date(byAdding: .day, value: countryRealmDB.period - 1, to: countryRealmDB.date!)
    dateFormatter.dateFormat = "yyyy.MM.dd"
    dateFormatter.locale = Locale(identifier: "ko-KR")
    //    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    let startDay = dateFormatter.string(from: countryRealmDB.date!)
    let endDay = dateFormatter.string(from: DBDate!)
    
    
    TripDescriptionView.dateLabel.text = "\(startDay) ~ \(endDay)"+"    "+"\(countryRealmDB.period - 1)박 \(countryRealmDB.period)일"
    //        scheduleMainTableView.reloadData()
  }
  // MARK: 버튼 이벤트
  @objc func moreDidTap(_ sender: UIButton){
    // 피드백 진동
    impact.impactOccurred()
    let point = sender.convert(CGPoint.zero, to: scheduleMainTableView as UIView)
    let indexPath: IndexPath! = scheduleMainTableView.indexPathForRow(at: point)
    
    let vc = TripDetailPopupViewController()
    vc.setup(self.countryRealmDB, day: indexPath.row, delegate: self)
    vc.modalTransitionStyle = .crossDissolve
    vc.modalPresentationStyle = .overFullScreen
    self.present(vc, animated: true, completion: nil)
  }
  @objc func editEvent(){
    isEdit = !isEdit!
    scheduleMainTableView.reloadData()
    if self.navigationItem.rightBarButtonItem?.title == "편집"{
      self.navigationItem.rightBarButtonItem?.title = "완료"
    }else{
      self.navigationItem.rightBarButtonItem?.title = "편집"
    }
  }
  @objc func dismissEvent() {
    dismiss(animated: true, completion: nil)
  }
  @objc func btnAction(_ sender: UIButton) {
    // 피드백 진동
    impact.impactOccurred()
    // 선택한 cell의 indexPath
    let point = sender.convert(CGPoint.zero, to: scheduleMainTableView as UIView)
    let indexPath: IndexPath! = scheduleMainTableView.indexPathForRow(at: point)
    
    // 스크롤 변수 설정! viewWillAppear 에서 사용함
    selectRow = indexPath.row
    buttonEvent(indexPath: indexPath)
  }
  @objc func placeButtonEvent(_ sender : UIButton){
    impact.impactOccurred()
    let point = sender.convert(CGPoint.zero, to: scheduleMainTableView as UIView)
    let indexPath: IndexPath! = scheduleMainTableView.indexPathForRow(at: point)
    let placeVC = AddTripViewController()
    placeVC.countryRealmDB = countryRealmDB
    placeVC.dayRealmDB = countryRealmDB.dayList[indexPath.row]
    placeVC.categoryIndex = 0
    self.navigationController?.pushViewController(placeVC, animated: true)
  }
  @objc func pathButtonEvent(_ sender : UIButton){
    impact.impactOccurred()
    //        self.scheduleMainTableView.reloadData()
    let point = sender.convert(CGPoint.zero, to: scheduleMainTableView as UIView)
    let indexPath: IndexPath! = scheduleMainTableView.indexPathForRow(at: point)
    let googleVC = AddTripCheckMapViewController()
    if countryRealmDB.dayList[indexPath.row].detailList.first != nil{
      googleVC.navTitle = countryRealmDB.city
      googleVC.arrayMap = true
      googleVC.currentSelect = countryRealmDB.dayList[indexPath.row].detailList.first!
      googleVC.dayDetailRealm = countryRealmDB.dayList[indexPath.row].detailList
      googleVC.dayRealmDB = countryRealmDB.dayList[indexPath.row]
      self.navigationController?.pushViewController(googleVC, animated: true)
      
    }
    
    //
  }
  @objc func exchangeButtonEvent(_ sender : UIButton){
    impact.impactOccurred()
    let point = sender.convert(CGPoint.zero, to: scheduleMainTableView as UIView)
    let indexPath: IndexPath! = scheduleMainTableView.indexPathForRow(at: point)
    let vc = AccountMainViewController()
    vc.tripMoneyRealmDB = self.countryRealmDB.moneyList
    // 여행 전 경비가 있음으로 + 1
    vc.selectedIndex = BehaviorRelay(value: indexPath.row + 1)
    // 여행 전 경비가 있음으로 + 1
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  func callAction(with data : String){
    print("pushing view")
    print(data)
  }
  var sum = 0
  // delete label footer view
  let deleteDataLabel : UILabel = {
    let label = UILabel()
    label.text = "이 여행 데이터 전체 삭제"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    label.textColor = #colorLiteral(red: 0.802965343, green: 0.08342111856, blue: 0, alpha: 1)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    
    return label
  }()
  
  
  // MARK: VC에서 View 그릴 떄 사용하는 것들
  let deleteBtnS : UIButton = {
    let button = UIButton()
    button.backgroundColor = UIColor.myRed
    button.setTitle("삭제", for: .normal)
    
    button.translatesAutoresizingMaskIntoConstraints=false
    return button
  }()
  let addBtnS : UIButton = {
    let button = UIButton()
    button.backgroundColor = UIColor.myBlue
    button.setTitle("확인", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints=false
    return button
  }()
  let deleteAndSaveStack : UIStackView = {
    let stack = UIStackView()
    stack.distribution = .fillEqually
    stack.axis = .horizontal
    stack.isHidden = false
    stack.translatesAutoresizingMaskIntoConstraints=false
    return stack
  }()
  lazy var navView: CustomNavigationBarView = {
    let view = CustomNavigationBarView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.setTitle(title: "")
    view.setLeftForPop()
    view.setButtonTitle(title: "편집")
    view.dismissBtn.addTarget(self, action: #selector(dismissEvent), for: .touchUpInside)
    view.actionBtn.addTarget(self, action: #selector(editEvent), for: .touchUpInside)
    return view
  }()
  // title을 갖는 뷰
  // 여행지랑 몇박 몇일인지 등등
  lazy var TripDescriptionView: addDetailView = {
    let view = addDetailView()
    view.moneyBtn.addTarget(self, action: #selector(pushExchangeViewController), for: .touchUpInside)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  // 날짜별 테이블뷰
  var scheduleMainTableView : UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .white
    tableView.tag = 0
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorColor = Defaull_style.subTitleColor
    tableView.separatorStyle = .none
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    tableView.allowsSelection = false
    return tableView
  }()
  func openViewEvent(currentCell : addDetailTableViewCell){
    // duration 작을 수록 느리게 애니메이션
    
    UIView.animate(withDuration: 0.5, animations: {
      let transformScaled = CGAffineTransform
        .identity
        .scaledBy(x: 0.8, y: 0.8)
      
      let moveMoney = CGAffineTransform(translationX: -50, y: 0)
      let movedetail = CGAffineTransform(translationX: 50, y: 0)
      let movePath = CGAffineTransform(translationX: 100, y: 0)
      
      currentCell.paddingViewBottom.addBtn.transform = transformScaled
      currentCell.paddingViewBottom.moneyBtn.transform = moveMoney
      currentCell.paddingViewBottom.detailBtn.transform = movedetail
      currentCell.paddingViewBottom.pathBtn.transform = movePath
      currentCell.paddingViewBottom.moneyBtn.alpha = 1
      currentCell.paddingViewBottom.detailBtn.alpha = 1
      currentCell.paddingViewBottom.pathBtn.alpha = 1
      
      
      
    })
  }
  func colseViewEvent(beforeCell : addDetailTableViewCell){
    // duration 작을 수록 느리게 애니메이션
    
    UIView.animate(withDuration: 0.5, animations: {
      
      let transformScaled = CGAffineTransform
        .identity
        .scaledBy(x: 1.0, y: 1.0)
      
      let moveMoney = CGAffineTransform(translationX: 0, y: 0)
      let movedetail = CGAffineTransform(translationX: 0, y: 0)
      let movePath = CGAffineTransform(translationX: 0, y: 0)
      beforeCell.paddingViewBottom.addBtn.transform = transformScaled
      beforeCell.paddingViewBottom.moneyBtn.transform = moveMoney
      beforeCell.paddingViewBottom.detailBtn.transform = movedetail
      beforeCell.paddingViewBottom.pathBtn.transform = movePath
      beforeCell.paddingViewBottom.moneyBtn.alpha = 0.0
      beforeCell.paddingViewBottom.detailBtn.alpha = 0.0
      beforeCell.paddingViewBottom.pathBtn.alpha = 0.0
    })
    
  }
  // MARK: 버튼의 animate 정의
  func buttonEvent(indexPath : IndexPath){
    let currentCell = scheduleMainTableView.cellForRow(at: indexPath)! as? addDetailTableViewCell
    // 머니 버튼이 가려져 있다면 보이기
    if currentCell?.paddingViewBottom.moneyBtn.alpha == 0.0 {
      openViewEvent(currentCell: currentCell!)
    }else{
      colseViewEvent(beforeCell: currentCell!)
    }
    
  }
  
}
// MARK: delegate 정의 (cell 에서 사용한다.)
extension TripDetailViewController {
  // The cell calls this method when the user taps the heart button
  func addDetailViewTableViewCellDidTapInTableView(_ sender: addDetailTableViewCell, detailIndex : Int) {
    guard let tappedIndexPath = scheduleMainTableView.indexPath(for: sender) else { return }
    selectRow = tappedIndexPath.row
    //        print(detailIndex)
    //        dismiss(animated: true, completion: nil)
    let changeVC = TripDetailSpecificDayViewController()
    changeVC.detailRealmDB = countryRealmDB.dayList[tappedIndexPath.row].detailList[detailIndex]
    changeVC.countryRealmDB = countryRealmDB
    self.navigationController?.pushViewController(changeVC, animated: true)
  }
  func tableViewDeleteEvent(_ sender: addDetailTableViewCell) {
    guard let tappedIndexPath = scheduleMainTableView.indexPath(for: sender) else { return }
    print("tab", sender, tappedIndexPath)
    self.scheduleMainTableView.reloadData()
  }
  
  
}

extension TripDetailViewController : UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("select")
    // 지금은 select 이벤트 없음
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let rowCount = countryRealmDB.dayList[indexPath.row].detailList.count
    if rowCount == 0 {
      return CGFloat(80 * 1 + (sizeConstant.paddingSize))
    }
    else{
      return CGFloat(80 * rowCount + (sizeConstant.paddingSize))
    }
  }
}
extension TripDetailViewController : UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return countryRealmDB.dayList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! addDetailTableViewCell
    
    cell.dayRealmDB = countryRealmDB.dayList[indexPath.row]
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko-KR")
    let DBDate = Calendar.current.date(byAdding: .day, value: countryRealmDB.dayList[indexPath.row].day - 1, to: countryRealmDB.date!)
    
    dateFormatter.setLocalizedDateFormatFromTemplate("e")
    
    let day = dateFormatter.string(from: DBDate ?? Date())
    cell.dateView.dayOfTheWeek.text = day + "요일"
    cell.dateView.dateLabel.text = String(countryRealmDB.dayList[indexPath.row].day) + "일차"
    cell.count = countryRealmDB.dayList[indexPath.row].detailList.count
    cell.paddingViewBottom.addButton.addTarget(self, action: #selector(moreDidTap(_:)), for: .touchUpInside)
    cell.paddingViewBottom.addBtn.addTarget(self, action: #selector(self.btnAction(_:)), for: .touchUpInside)
    cell.paddingViewBottom.detailBtn.addTarget(self, action: #selector(self.placeButtonEvent(_:)), for: .touchUpInside)
    cell.paddingViewBottom.pathBtn.addTarget(self, action: #selector(self.pathButtonEvent(_:)), for: .touchUpInside)
    cell.paddingViewBottom.moneyBtn.addTarget(self, action: #selector(self.exchangeButtonEvent(_:)), for: .touchUpInside)
    
    let transformScaled = CGAffineTransform
      .identity
      .scaledBy(x: 1.0, y: 1.0)
    
    let moveMoney = CGAffineTransform(translationX: 0, y: 0)
    let movedetail = CGAffineTransform(translationX: 0, y: 0)
    let movePath = CGAffineTransform(translationX: 0, y: 0)
    cell.paddingViewBottom.addBtn.transform = transformScaled
    cell.paddingViewBottom.moneyBtn.transform = moveMoney
    cell.paddingViewBottom.detailBtn.transform = movedetail
    cell.paddingViewBottom.pathBtn.transform = movePath
    cell.paddingViewBottom.moneyBtn.alpha = 0.0
    cell.paddingViewBottom.detailBtn.alpha = 0.0
    cell.paddingViewBottom.pathBtn.alpha = 0.0
    
    cell.mydelegate = self
    cell.isEdit = isEdit!
    
    
    return cell
  }
  
}
extension TripDetailViewController: UIScrollViewDelegate {
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    // 버튼 animate 원상복구
  }
}

extension TripDetailViewController{
  @objc func pushExchangeViewController(){
    let vc = AccountMainViewController()
    vc.tripMoneyRealmDB = self.countryRealmDB.moneyList
    //    vc.countryRealmDB = self.countryRealmDB
    self.navigationController?.pushViewController(vc, animated: true)
  }
}


extension TripDetailViewController: TripDetailDataPopupDelegate {
  func TripDetailDataPopupMoney(day: Int) {
    let vc = AccountMainViewController()
    vc.tripMoneyRealmDB = self.countryRealmDB.moneyList
    // 여행 전 경비가 있음으로 + 1
    vc.selectedIndex = BehaviorRelay(value: day + 1)
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func TripDetailDataPopupSchedule(day: Int) {
    let placeVC = AddTripViewController()
    placeVC.countryRealmDB = countryRealmDB
    placeVC.dayRealmDB = countryRealmDB.dayList[day]
    placeVC.categoryIndex = 0
    self.navigationController?.pushViewController(placeVC, animated: true)
  }
  
  func TripDetailDataPopupPath(day: Int) {
    let googleVC = AddTripCheckMapViewController()
    if countryRealmDB.dayList[day].detailList.first != nil{
      googleVC.navTitle = countryRealmDB.city
      googleVC.arrayMap = true
      googleVC.currentSelect = countryRealmDB.dayList[day].detailList.first!
      googleVC.dayDetailRealm = countryRealmDB.dayList[day].detailList
      googleVC.dayRealmDB = countryRealmDB.dayList[day]
      self.navigationController?.pushViewController(googleVC, animated: true)
    }
  }
}
