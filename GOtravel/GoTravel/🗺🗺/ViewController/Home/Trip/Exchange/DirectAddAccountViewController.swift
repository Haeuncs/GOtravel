//
//  DirectAddAccountViewController.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2019/08/12.
//  Copyright © 2019 haeun. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RealmSwift

class DirectAddAccountViewController: UIViewController {
  var ViewModel = DirectAddAccountViewModel()
  var selectForeignMoneyDouble: Double?
  let realm = try! Realm()
  /// 이전 viewcontroller 에서 받는 값 (선택된 여행 일자)
  var realmMoneyList: moneyRealm?
  /// 데이터 수정일 때 받는 값
  var editMoneyDetailRealm: moneyDetailRealm?
  
  var disposeBag = DisposeBag()
  deinit {
    print("deinit")
    disposeBag = DisposeBag()
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "경비 추가"
    bindRX()
    initView()
    setupGesture()
    
    let rightButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(saveEvent))
    self.navigationItem.rightBarButtonItem = rightButton
    self.navigationItem.rightBarButtonItem?.isEnabled = false
    
    
    if let data = editMoneyDetailRealm {
      memoTextField.textField.text = data.title
      leftTextField.text = Formatter.decimal.string(from: NSNumber(value: data.money))
      ViewModel.isKoreaMoneySelected.onNext(true)
      for i in 0..<ViewModel.categoryArr.count {
        if ViewModel.categoryArr[i].title == data.subTitle {
          ViewModel.isSelectedCategory.onNext(i)
          categoryCollectionView.selectItem(at: IndexPath(row: i, section: 0), animated: true, scrollPosition: .left)
          checkSaveEnable()
          break
        }
      }
    }else{
      categoryCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
    }

  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }

  func bindRX(){
    ViewModel.isKoreaMoneySelected.asObservable()
      .subscribe(onNext: { (bool) in
        if bool {
          self.koreaMoneyButton.isSelected = true
          self.foreignMoneyButton.isSelected = false
          self.selectStackCountry.isHidden = true
          self.rightTextField.isHidden = true
          self.exchangeImageView.isHidden = true
        }else{
          self.koreaMoneyButton.isSelected = false
          self.foreignMoneyButton.isSelected = true
          self.selectStackCountry.isHidden = false
          self.rightTextField.isHidden = false
          self.exchangeImageView.isHidden = false
        }
      }).disposed(by: disposeBag)
    
    memoTextField.textField.rx.text.orEmpty
      .subscribe(onNext: { (s) in
        self.checkSaveEnable()
      }).disposed(by: disposeBag)
    
    ViewModel.data.asObservable()
      .bind(to: categoryCollectionView.rx.items(cellIdentifier: "cell", cellType: DirectAddAccountCell.self)){ row, model, cell in
        cell.directAddAccountModel = model
      }.disposed(by: disposeBag)
    
    categoryCollectionView.rx.itemSelected
      .subscribe(onNext: { (indexPath) in
        self.ViewModel.isSelectedCategory.onNext(indexPath.row)
        self.checkSaveEnable()
      }).disposed(by: disposeBag)
    
    leftTextField.rx.controlEvent(.editingChanged)
      .subscribe(onNext: { (_) in
        if self.leftTextField.text != "" {
          self.textFieldDidChange(self.leftTextField)
        }
        self.checkSaveEnable()
      }).disposed(by: disposeBag)
    
  }
  func setupGesture() {
    let krGesture = UITapGestureRecognizer(target: self, action: #selector(koreaGesture))
    koreaMoneyButton.addGestureRecognizer(krGesture)
    let foGesture = UITapGestureRecognizer(target: self, action: #selector(foreignGesture))
    foreignMoneyButton.addGestureRecognizer(foGesture)
    
    let leftGesture = UITapGestureRecognizer(target: self, action:  #selector(self.leftAction))
    self.leftView.addGestureRecognizer(leftGesture)

//    leftTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

  }
  func textFieldDidChange(_ textField: UITextField) {
    if textField.text?.count != 0 {
      if (textField.text?.contains("."))!{
        if let range = textField.text!.range(of: ".") {
          let dotBefore = textField.text![..<range.lowerBound]
          let dotAfter = textField.text![range.lowerBound...] // or str[str.startIndex..<range.lowerBound]

          let subtractionDot = dotBefore.replacingOccurrences(of: ",", with: "")
          calculatorKoreaMoney(textFieldDouble: Double(textField.text!) ?? 0, selectedForeognMoney: self.selectForeignMoneyDouble ?? 0)

          let numberFormatter = NumberFormatter()
          numberFormatter.numberStyle = NumberFormatter.Style.decimal
          var formattedNumber = numberFormatter.string(from: NSNumber(value:(subtractionDot.toDouble())!))

          formattedNumber?.append(String(dotAfter))
          textField.text = formattedNumber

        }
      }else{
        let subtractionDot = textField.text?.replacingOccurrences(of: ",", with: "")
        calculatorKoreaMoney(textFieldDouble: Double(subtractionDot!) ?? 0, selectedForeognMoney: self.selectForeignMoneyDouble ?? 0)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:Double(subtractionDot!)!))

        textField.text = formattedNumber
      }
    }
    checkSaveEnable()
  }
  @objc func saveEvent(){
    do {
      var money: Double?
      let selectedCategory = try ViewModel.isSelectedCategory.value()
      let bool = try ViewModel.isKoreaMoneySelected.value()
      if bool {
        money = leftTextField.text?.replacingOccurrences(of: ",", with: "").toDouble() ?? 0
      }else {
        money = rightTextField.text?.replacingOccurrences(of: ",", with: "").toDouble() ?? 0
      }
      if let editData = editMoneyDetailRealm {
        try self.realm.write {
          editData.title = memoTextField.textField.text!
          editData.subTitle = ViewModel.categoryArr[selectedCategory].title
          editData.exchange = leftBelowLabel.text ?? ""
          editData.money = money!
        }
        self.navigationController?.popViewController(animated: true)
      }else {
        let moneyDetailRealmDB = moneyDetailRealm()
        if let data = realmMoneyList {
          moneyDetailRealmDB.money = money!
          moneyDetailRealmDB.title = memoTextField.textField.text ?? ""
          moneyDetailRealmDB.exchange = leftBelowLabel.text ?? ""
          moneyDetailRealmDB.subTitle = ViewModel.categoryArr[selectedCategory].title
          try self.realm.write {
            data.detailList.append(moneyDetailRealmDB)
          }
          self.navigationController?.popViewController(animated: true)
        }
      }
    }catch{
      return
    }
  }
  @objc func koreaGesture(){
    ViewModel.isKoreaMoneySelected.onNext(true)
  }
  @objc func foreignGesture(){
    ViewModel.isKoreaMoneySelected.onNext(false)
  }
  @objc func leftAction(sender : UITapGestureRecognizer) {
    let vc = ExchangeSelectCountryViewController()
    vc.viewModel.selected.asObservable().subscribe(onNext: { (model) in
      self.leftTextField.text = ""
      self.rightTextField.text = ""
//      self.leftTextField.becomeFirstResponder()
      self.selectForeignMoneyDouble = model.calculateDouble
      if model.foreignName != nil {
        self.leftLabel.text = "\(model.value.country)-\(model.value.korName)"
        self.leftBelowLabel.text = model.foreignName!
      }else{
        self.leftLabel.text = "\(model.value.country)"
        self.leftBelowLabel.text = model.value.korName
      }
      }).disposed(by: disposeBag)
    self.navigationController?.pushViewController(vc, animated: true)
  }
  lazy var memoTextField: LineAnimateTextFieldView = {
    let text = LineAnimateTextFieldView()
    text.translatesAutoresizingMaskIntoConstraints = false
    text.textFieldActiveLine.backgroundColor = UIColor.butterscotch
    text.textField.tintColor = .butterscotch
    text.descriptionLabel.text = "메모"
    text.descriptionLabel.font = .sb17
    text.textField.placeholder = "이 경비에 대한 메모를 남겨주세요!"
    return text
  }()
  lazy var categoryMoneyStack: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.distribution = .fillEqually
    view.spacing = 34
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var categoryView: UIView = {
    let view = UIView()
    //    view.axis = .vertical
    //    view.spacing = 23
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var categoryLabel: UILabel = {
    let label = UILabel()
    label.text = "카테고리"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.font = .sb17
    return label
  }()
  lazy var categoryCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.sectionInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
    //    layout.itemSize = CGSize(width: 84, height: 100)
    //    layout.minimumInteritemSpacing = 100
    layout.minimumLineSpacing = 14
    let collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collect.register(DirectAddAccountCell.self, forCellWithReuseIdentifier: "cell")
    collect.backgroundColor = .white
    collect.translatesAutoresizingMaskIntoConstraints = false
    return collect
  }()
  lazy var moneyView: UIView = {
    let view = UIView()
    //    view.axis = .vertical
    //    view.spacing = 23
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var moneyLabel: UILabel = {
    let label = UILabel()
    label.text = "금액"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.font = .sb17
    return label
  }()
  lazy var moneyBackGroundView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.clipsToBounds = false
    view.layer.cornerRadius = 4
    view.backgroundColor = .grey02
    view.layer.zeplinStyleShadows(color: .black, alpha: 0.16, x: 3, y: 3, blur: 6, spread: 0)
    return view
  }()
  lazy var moneyStack: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.distribution = .fillEqually
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var moneyStackOne: UIStackView = {
    let view = UIStackView()
    view.backgroundColor = .clear
    view.axis = .horizontal
    view.distribution = .fillEqually
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var koreaMoneyButton : moneyButton = {
    let view = moneyButton()
    view.backgroundColor = .clear
    view.translatesAutoresizingMaskIntoConstraints = false
    view.titleLabel.text = "한화"
    //    button.isSelected = true
    return view
  }()
  lazy var foreignMoneyButton : moneyButton = {
    let view = moneyButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.titleLabel.text = "환율"
    return view
  }()
  let selectStackCountry : UIStackView = {
    let view = UIStackView()
    view.axis = .horizontal
    view.distribution = .fillEqually
    //        view.spacing = 5
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  let leftView : UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  let rightView : UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  let leftSubView : UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.distribution = .fillEqually
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  let rightSubView : UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.distribution = .fillEqually
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  lazy var exchangeImageView : UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleAspectFit
    image.image = UIImage(named: "exchange")
    image.isHidden = true
    return image
  }()
  let leftLabel : UILabel = {
    let label = UILabel()
    label.adjustsFontSizeToFitWidth = true
    label.text = "환율 적용"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    label.textColor = Defaull_style.mainTitleColor
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  let leftBelowLabel : UILabel = {
    let label = UILabel()
    label.text = " "
    label.textAlignment = .center
    label.adjustsFontSizeToFitWidth = true
    label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    label.textColor = Defaull_style.mainTitleColor
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let rightLabel : UILabel = {
    let label = UILabel()
    label.text = "대한민국-원"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    label.textColor = Defaull_style.mainTitleColor
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  let rightBelowLabel : UILabel = {
    let label = UILabel()
    label.text = "KRW"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    label.textColor = Defaull_style.mainTitleColor
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  let moneyTextFieldStack : UIStackView = {
    let view = UIStackView()
    view.axis = .horizontal
    view.distribution = .fillEqually
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  let leftTextFieldView : UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  let leftTextField : UITextField = {
    let text = UITextField()
    text.text = "0"
    text.minimumFontSize = 12
    text.adjustsFontSizeToFitWidth = true
    text.clearButtonMode = .whileEditing
    text.font = UIFont.systemFont(ofSize: 30, weight: .medium)
    text.textAlignment = .center
    text.keyboardType = .decimalPad
    text.translatesAutoresizingMaskIntoConstraints = false
    return text
  }()
  var rightTextField : UITextField = {
    let text = UITextField()
    text.text = ""
    // read Only
    text.isUserInteractionEnabled = false
    text.minimumFontSize = 12
    text.adjustsFontSizeToFitWidth = true
    text.clearButtonMode = .whileEditing
    text.font = UIFont.systemFont(ofSize: 30, weight: .medium)
    text.textAlignment = .center
    text.keyboardType = .decimalPad
    text.translatesAutoresizingMaskIntoConstraints = false
    return text
  }()
  
  let rightTextFieldView : UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  func initView(){
    categoryCollectionView.delegate = self
    view.backgroundColor = .white
    // 메모
    view.addSubview(memoTextField)
    view.addSubview(categoryMoneyStack)
    // 카테고리 + 금액 스택
    categoryMoneyStack.addArrangedSubview(categoryView)
    categoryMoneyStack.addArrangedSubview(moneyView)
    // 카테고리
    categoryView.addSubview(categoryLabel)
    categoryView.addSubview(categoryCollectionView)
    // 금액
    moneyView.addSubview(moneyLabel)
    moneyView.addSubview(moneyBackGroundView)
    moneyBackGroundView.addSubview(moneyStack)
    moneyBackGroundView.addSubview(exchangeImageView)
    moneyStack.addArrangedSubview(moneyStackOne)
    moneyStack.addArrangedSubview(selectStackCountry)
    moneyStack.addArrangedSubview(moneyTextFieldStack)
    // 금액 첫 줄 스택 (항상 보임)
    moneyStackOne.addArrangedSubview(koreaMoneyButton)
    moneyStackOne.addArrangedSubview(foreignMoneyButton)
    // 환율 시에 보이는 2번째 줄 스택
    selectStackCountry.addArrangedSubview(leftView)
    selectStackCountry.addArrangedSubview(rightView)
    leftView.addSubview(leftSubView)
    rightView.addSubview(rightSubView)
    leftSubView.addArrangedSubview(leftLabel)
    leftSubView.addArrangedSubview(leftBelowLabel)
    rightSubView.addArrangedSubview(rightLabel)
    rightSubView.addArrangedSubview(rightBelowLabel)
    /// 세번째 텍스트 필드 스택
    moneyTextFieldStack.addArrangedSubview(leftTextField)
    moneyTextFieldStack.addArrangedSubview(rightTextField)
    //
    //    leftTextFieldView.addSubview(leftTextField)
    //    rightTextFieldView.addSubview(rightTextField)
    
    exchangeImageView.snp.makeConstraints{ (make) in
      make.width.equalTo(37)
      make.height.equalTo(37)
      make.center.equalTo(moneyBackGroundView.snp.center)
    }
    memoTextField.snp.makeConstraints{ (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
      make.left.equalTo(view.snp.left).offset(16)
      make.right.equalTo(view.snp.right).offset(-16)
    }
    categoryMoneyStack.snp.makeConstraints{ (make) in
      make.top.equalTo(memoTextField.snp.bottom).offset(34)
      make.left.equalTo(view.snp.left).offset(0)
      make.right.equalTo(view.snp.right).offset(0)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
    }
    categoryLabel.snp.makeConstraints{ (make) in
      make.top.equalTo(categoryView.snp.top)
      make.left.equalTo(categoryView.snp.left).offset(16)
      make.right.equalTo(categoryView.snp.right).offset(-16)
    }
    categoryCollectionView.snp.makeConstraints{ (make) in
      make.top.equalTo(categoryLabel.snp.bottom).offset(23)
      make.left.equalTo(categoryView.snp.left)
      make.right.equalTo(categoryView.snp.right)
      make.bottom.equalTo(categoryView.snp.bottom)
    }
    
    moneyLabel.snp.makeConstraints{ (make) in
      make.top.equalTo(moneyView.snp.top)
      make.left.equalTo(moneyView.snp.left).offset(16)
      make.right.equalTo(moneyView.snp.right).offset(-16)
    }
    moneyBackGroundView.snp.makeConstraints{ (make) in
      make.top.equalTo(moneyLabel.snp.bottom).offset(23)
      make.left.equalTo(moneyView.snp.left).offset(16)
      make.right.equalTo(moneyView.snp.right).offset(-16)
      make.bottom.equalTo(moneyView.snp.bottom)
    }
    
    moneyStack.snp.makeConstraints{ (make) in
      make.top.equalTo(moneyBackGroundView.snp.top)
      make.left.equalTo(moneyBackGroundView.snp.left)
      make.right.equalTo(moneyBackGroundView.snp.right)
      make.bottom.equalTo(moneyBackGroundView.snp.bottom)
    }
    leftView.snp.makeConstraints{ (make) in
      make.center.equalTo(leftSubView.snp.center)
    }
    rightView.snp.makeConstraints{ (make) in
      make.center.equalTo(rightSubView.snp.center)
    }
    leftSubView.frame = leftView.frame
    rightSubView.frame = rightView.frame
  }
}



extension DirectAddAccountViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 84, height: collectionView.frame.height - 20)
  }
}

// MARK: - Logic
extension DirectAddAccountViewController {
  func calculatorKoreaMoney(textFieldDouble : Double, selectedForeognMoney: Double){
    if ViewModel.foreignCalculateBy100 {
      let divide =  selectedForeognMoney / Double(100)
      let calculatorText = divide * textFieldDouble
      let numberFormatter = String(format: "%.2f", calculatorText).toDouble()
      if let num = numberFormatter {
        rightTextField.text = Formatter.decimal.string(from: NSNumber(value: num))
      }
    }else{
      print(textFieldDouble * selectedForeognMoney)
      let numberFormatter = String(format: "%.2f", textFieldDouble * selectedForeognMoney).toDouble()
      
      if let num = numberFormatter {
        rightTextField.text = Formatter.decimal.string(from: NSNumber(value: num))
      }
    }
  }
  func checkSaveEnable(){
    if memoTextField.textField.text != "" {
      if leftTextField.text != "" {
        self.navigationItem.rightBarButtonItem?.title = "완료"
        self.navigationItem.rightBarButtonItem?.isEnabled = true
      }else{
        self.navigationItem.rightBarButtonItem?.title = "편집"
        self.navigationItem.rightBarButtonItem?.isEnabled = false
      }
    }else{
      self.navigationItem.rightBarButtonItem?.title = "편집"
      self.navigationItem.rightBarButtonItem?.isEnabled = false
    }
  }
}
class moneyButton: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  lazy var indicator: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 7/2
    view.backgroundColor = .clear
    return view
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.font = .r17
    return label
  }()
  func initView(){
    self.addSubview(titleLabel)
    self.addSubview(indicator)
    titleLabel.snp.makeConstraints{ (make) in
      make.center.equalTo(self.snp.center)
    }
    indicator.snp.makeConstraints{ (make) in
      make.width.equalTo(7)
      make.height.equalTo(7)
      make.top.equalTo(titleLabel.snp.top).offset(-4)
      make.right.equalTo(titleLabel.snp.left).offset(-0.5)
    }
  }
  var isSelected: Bool = false {
    didSet {
      if isSelected {
        titleLabel.font = .sb17
        indicator.backgroundColor = .butterscotch
      }else{
        titleLabel.font = .r17
        indicator.backgroundColor = .clear
      }
    }
  }
}
