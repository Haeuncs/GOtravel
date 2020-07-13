//
//  exchagneView.swift
//  GOtravel
//
//  Created by OOPSLA on 28/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

protocol ExchangeTableCellProtocol {
  var subTitle: String { get }
  var mainTitle: String { get }
  var numberTitle: String { get }
}
struct ExchangeTableCellViewModel: ExchangeTableCellProtocol{
  var subTitle: String
  
  var mainTitle: String
  
  var numberTitle: String
  
  init(_ data: moneyDetailRealm) {
    self.mainTitle = data.title
    self.subTitle = data.subTitle
    self.numberTitle = ""
    
  }
}
class ExchangeView: UIView,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
  
  var viewModel: AccountViewModel?

  // addDetailVC -> exchangeVC 에서 전달 받는 데이터
  var countryRealmDB = countryRealm()
  var selectDay = 0
  
  var mainCV: UICollectionView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    mainCV = UICollectionView(frame: CGRect(x: 0, y: 5 , width: self.bounds.width , height: self.bounds.height / 12), collectionViewLayout: flowLayout)
    mainCV.register(ExchangeCVCell.self, forCellWithReuseIdentifier: "exchangeCVCell")
    mainCV.backgroundColor = UIColor.clear
    mainCV.delegate = self
    mainCV.dataSource = self
    mainCV.showsHorizontalScrollIndicator = false
    self.addSubview(mainCV)
    self.addSubview(moneyLabel)
    self.addSubview(belowView)
    belowView.delegate = self
    NSLayoutConstraint.activate([
      
      moneyLabel.topAnchor.constraint(equalTo: mainCV.bottomAnchor, constant: 5),
      //            moneyLabel.bottomAnchor.constraint(equalTo: belowView.topAnchor),
      moneyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      moneyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      moneyLabel.heightAnchor.constraint(equalToConstant: 60),
      
      //            belowView.topAnchor.constraint(equalTo: mainCV.bottomAnchor, constant: 5),
      belowView.topAnchor.constraint(equalTo: moneyLabel.bottomAnchor),
      belowView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      belowView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      belowView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      
    ])
    // 이전 뷰에서 선택된 셀 표시
    let indexPathForFirstRow = NSIndexPath(item: selectDay, section: 0)
    mainCV.selectItem(at: indexPathForFirstRow as IndexPath, animated: true, scrollPosition: .centeredHorizontally)
    
    belowView.countryRealmDB = self.countryRealmDB
    belowView.selectDay = self.selectDay
    
  }
  let moneyLabel: ExchangeSubView = {
    let label = ExchangeSubView()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  // 테이블뷰
  let belowView: ExchangeTV = {
    let view = ExchangeTV()
    view.layer.cornerRadius = 10
    view.backgroundColor = UIColor.clear
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  func reloadMoneyLabels(index: Int){
    // 라벨 계산
    var todayTotal = 0
    print("selectDat = \(index)")
    for i in countryRealmDB.moneyList[index].detailList {
      todayTotal = Int(i.money) + todayTotal
    }
    var allTotal = 0
    for i in countryRealmDB.moneyList{
      for j in i.detailList{
        allTotal = allTotal + Int(j.money)
      }
    }
//    moneyLabel.moneyDayLabel.text = "￦ \(todayTotal.toNumber())"
//    moneyLabel.moneyTotalLabel.text = "￦ \(allTotal.toNumber())"
    
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return countryRealmDB.moneyList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "exchangeCVCell",
            for: indexPath) as? ExchangeCVCell else {
      return UICollectionViewCell()
    }
    cell.dayLabel.text = "\(indexPath.row) 일"
    cell.layer.cornerRadius = 5
    cell.backgroundColor = .white
    // 여행 전 가계부
    if indexPath.row == 0 {
      cell.dayLabel.text = "여행 전"
    }
    
    //        cell.backgroundColor = .red
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
  {
    
    return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
  {
    
    return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    viewModel?.selectedDayIndex.onNext(indexPath.row)
  }
}

class ExchangeSubView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func initView() {
    self.addSubview(stackView)
    stackView.addArrangedSubview(dayView)
    stackView.addArrangedSubview(totalView)
    
    stackView.snp.makeConstraints { (make) in
      make.top.equalTo(self.snp.top)
      make.left.equalTo(self.snp.left)
      make.right.equalTo(self.snp.right)
      make.bottom.equalTo(self.snp.bottom)
    }
  }
  lazy var stackView: UIStackView = {
    let view = UIStackView()
    view.axis = .horizontal
    view.distribution = UIStackView.Distribution.fillEqually
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var dayView: AccountLabelView = {
    let view = AccountLabelView()
    view.descriptionLabel.text = "하루 합계"
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var totalView: AccountLabelView = {
    let view = AccountLabelView()
    view.descriptionLabel.text = "총합"
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
}
class AccountLabelView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func initView(){
    self.addSubview(stackView)
    stackView.addArrangedSubview(descriptionLabel)
    stackView.addArrangedSubview(moneyLabel)
    
    stackView.snp.makeConstraints { (make) in
//      make.left.equalTo(self.snp.left)
//      make.right.equalTo(self.snp.right)
      make.centerX.equalTo(self.snp.centerX)
      make.centerY.equalTo(self.snp.centerY)
    }
  }
  lazy var stackView: UIStackView = {
    let view = UIStackView()
    view.spacing = 16
    view.axis = .vertical
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  /// 설명
  lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "하루"
    label.textAlignment = .center
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  /// money 표시
  lazy var moneyLabel: UILabel = {
    let label = UILabel()
    label.text = "￦ 100.000"
    label.textAlignment = .center
    label.textColor = .black
    label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
}

class ExchangeTV: UIView,UITableViewDelegate,UITableViewDataSource {
  
  let realm = try! Realm()
  var countryRealmDB = countryRealm()
  var selectDay = 0 {
    didSet {
      moneyTV.reloadData()
    }
  }
  var delegate: ExchangeView?
  //  var exchangeCell:exchangeCVCell?
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func layoutSubviews() {
    print(countryRealmDB)
    moneyTV.register(ExchangeCell.self, forCellReuseIdentifier: "cell")
    moneyTV.delegate = self
    moneyTV.dataSource = self
    
    addSubview(moneyTV)
    NSLayoutConstraint.activate([
      moneyTV.topAnchor.constraint(equalTo: self.topAnchor),
      moneyTV.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      moneyTV.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      moneyTV.trailingAnchor.constraint(equalTo: self.trailingAnchor),
    ])
  }
  let moneyTV: UITableView = {
    let table = UITableView()
    table.separatorStyle = .none
    table.backgroundColor = DefaullStyle.topTableView
    table.translatesAutoresizingMaskIntoConstraints = false
    return table
  }()
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.frame.height / 5
  }
  //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  //        return 20
  //    }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath) as? ExchangeCell else {
      return UITableViewCell()
    }
    
    let data = countryRealmDB.moneyList[selectDay].detailList[indexPath.row]
    
    cell.label1.text = data.subTitle
    cell.label2.text = data.title
    
    cell.backgroundColor = UIColor.clear
    cell.contentView.layer.cornerRadius = CGFloat(DefaullStyle.insideTableViewCorner)
    cell.contentView.backgroundColor = DefaullStyle.insideTableView
    cell.contentView.layer.shadowColor = UIColor.black.cgColor
    cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
    cell.contentView.layer.shadowOpacity = 0.2
    cell.contentView.layer.shadowRadius = 4.0
    
    cell.contentView.clipsToBounds = true
    
    // money numberFormat
    let strDouble = String(data.money)
    if let range = strDouble.range(of: ".0") {
      let dotBefore = strDouble[..<range.lowerBound]
      //            let dotAfter = strDouble[range.lowerBound...]
      
      let subtractionDot = dotBefore.replacingOccurrences(of: ",", with: "")
      let numberFormatter = NumberFormatter()
      numberFormatter.numberStyle = NumberFormatter.Style.decimal
      let formattedNumber = numberFormatter.string(from: NSNumber(value: Double(subtractionDot)!))
      
      //            formattedNumber?.append(String(dotAfter))
      cell.label3.text = "￦ \(formattedNumber!)"
      
    }
    //        cell.label3.text = "￦ \(data.money)"
    return cell
  }
  //    // 각 셀마다 space
  //    func numberOfSections(in tableView: UITableView) -> Int {
  //        return countryRealmDB.moneyList[selectDay].detailList.count
  //    }
  //
  // There is just one row in every section
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if countryRealmDB.moneyList[selectDay].detailList.count == 0 {
      moneyTV.setEmptyMessage("X_X\n 이 날짜에 데이터가 없습니다. \n 데이터를 추가해주세요")
    } else {
      moneyTV.restore()
    }
    
    return countryRealmDB.moneyList[selectDay].detailList.count
  }
  
  // Set the spacing between sections
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 10
  }
  
  // Make the background color show through
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = UIColor.clear
    return headerView
  }
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete{
      try! self.realm.write {
        self.countryRealmDB.moneyList[selectDay].detailList.remove(at: indexPath.row)
      }
      self.moneyTV.reloadData()
      delegate?.reloadMoneyLabels(index: selectDay)
    }
  }
  
}
class ExchangeCell: UITableViewCell {
  override func prepareForReuse() {
    
  }
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setLayout()

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func setLayout() {
    
//    self.backgroundColor = .butterscotch
//    contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20))
    insideView.layer.cornerRadius = 4
    insideView.layer.zeplinStyleShadows(color: .black, alpha: 0.07, x: 0, y: 10, blur: 10, spread: 0)
    insideView.clipsToBounds = false
    
    contentView.addSubview(insideView)
    insideView.addSubview(leftStack)
    leftStack.addArrangedSubview(label1)
    leftStack.addArrangedSubview(label2)
    insideView.addSubview(label3)
    
    NSLayoutConstraint.activate([
      insideView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
      insideView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
      insideView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      insideView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      
      insideView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      
      leftStack.centerYAnchor.constraint(equalTo: insideView.centerYAnchor, constant: 0),
      leftStack.leftAnchor.constraint(equalTo: insideView.leftAnchor, constant: 14),
      
      label3.centerYAnchor.constraint(equalTo: insideView.centerYAnchor, constant: 0),
      label3.rightAnchor.constraint(equalTo: insideView.rightAnchor, constant: -14),

    ])
    
  }
  let insideView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .white
    return view
  }()
  lazy var leftStack: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.spacing = 8
    return stack
  }()
  let label1: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "호텔"
    label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    return label
  }()
  let label2: UILabel = {
    let label = UILabel()
    label.adjustsFontSizeToFitWidth = true
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
    label.text = "도쿄 호텔 비용"
    label.textColor = .black
    return label
  }()
  let label3: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .right
    label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
    return label
  }()
  
}
