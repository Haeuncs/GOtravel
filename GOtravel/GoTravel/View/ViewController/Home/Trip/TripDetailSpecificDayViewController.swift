//
//  TripDetailSpecificDayViewController.swift
//  GOtravel
//
//  Created by LEE HAEUN on 2020/01/26.
//  Copyright © 2020 haeun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AnimatedTextInput
import SnapKit
import RealmSwift
import IQKeyboardManagerSwift

class TripDetailSpecificDayViewController: BaseUIViewController {
  var disposeBag = DisposeBag()
  
  private var selectedColorIndex: IndexPath?
  
  var heightConstraint: NSLayoutConstraint?
  let realm = try! Realm()
  
  var detailRealmDB : detailRealm? {
    didSet{
      print("detailRealmDB")
      print(detailRealmDB!)
    }
  }
  var countryRealmDB : countryRealm?{
    didSet{
      print("countryRealmDB")
      print(countryRealmDB!)
    }
  }
  
  
  var colorPik : String = ""
  var memoText : String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    isDismiss = false
    popTitle = "여행"
    initView()
    bindRx()
    guard let db = detailRealmDB else {
      return
    }
    if db.color != "default" {
      let colorArr = db.color.components(separatedBy: " ")
      self.colorLabel.textColor = UIColor.init(red: characterToCgfloat(str: colorArr[0]),
                                               green: characterToCgfloat(str: colorArr[1]),
                                               blue: characterToCgfloat(str: colorArr[2]),
                                               alpha: characterToCgfloat(str: colorArr[3]))
    }
    titleLabel.text = (countryRealmDB?.city ?? "") + " 여행"
    titleTextInput.textField.text = db.title
    miniMemoTextInput.textField.text = db.oneLineMemo
    memoTextInput.textView.text = db.memo
    colorPik = db.color
  }
  func characterToCgfloat(str : String) -> CGFloat {
    let n = NumberFormatter().number(from: str)
    return n as! CGFloat
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    IQKeyboardManager.shared.enable = true
    addObservers()
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeObservers()
  }
  func initView(){
    collectionview.dataSource = self
    collectionview.delegate = self
    collectionview.showsVerticalScrollIndicator = false
    view.addSubview(confirmButton)
    contentView.addSubview(scrollView)
    scrollView.addSubview(titleLabel)
    scrollView.addSubview(titleTextInput)
    scrollView.addSubview(miniMemoTextInput)
    scrollView.addSubview(memoTextInput)
    scrollView.addSubview(colorLabel)
    scrollView.addSubview(stackView)
    stackView.addArrangedSubview(collectionview)
    
    scrollView.snp.makeConstraints { (make) in
      make.top.bottom.equalTo(contentView)
      make.leading.equalTo(contentView.snp.leading).offset(-16)
      make.trailing.equalTo(contentView.snp.trailing).offset(16)
    }
    titleLabel.snp.makeConstraints { (make) in
      make.leading.trailing.equalTo(contentView)
      make.top.equalTo(scrollView.snp.top).offset(3)
    }
    titleTextInput.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(40)
      make.leading.trailing.equalTo(contentView)
    }
    miniMemoTextInput.snp.makeConstraints { (make) in
      make.top.equalTo(titleTextInput.snp.bottom).offset(12)
      make.leading.trailing.equalTo(contentView)
    }
    colorLabel.snp.makeConstraints { (make) in
      make.top.equalTo(miniMemoTextInput.snp.bottom).offset(12)
      make.leading.trailing.equalTo(contentView)
      
    }
    stackView.snp.makeConstraints { (make) in
      make.top.equalTo(colorLabel.snp.bottom)
      make.leading.trailing.equalTo(contentView)
    }
    collectionview.snp.makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalTo(stackView)
    }
    
    memoTextInput.snp.makeConstraints { (make) in
      make.top.equalTo(stackView.snp.bottom).offset(12)
      make.leading.trailing.equalTo(contentView)
      make.bottom.equalTo(confirmButton.snp.top).offset(-45)
      make.bottom.lessThanOrEqualTo(scrollView.snp.bottom)
    }
    confirmButton.snp.makeConstraints { (make) in
      make.top.equalTo(scrollView.snp.bottom).priority(.high)
      make.height.equalTo(56)
      make.leading.equalTo(view.snp.leading).offset(16)
      make.trailing.equalTo(view.snp.trailing).offset(-16)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-45).priority(.high)
      
      
    }
  }
  func bindRx() {
    //    self.titleTextInput.rx.controlEvent(.editingDidBegin)
    //      .subscribe(onNext: { (_) in
    //        print("TEST")
    ////        self.scrollView.contentOffset = CGPoint(x: 0, y: self.titleTextInput.frame.midY)
    //      }).disposed(by: disposeBag)
  }
  
  /// Move TextFields to keyboard. Step 3: Add observers for 'UIKeyboardWillShow' and 'UIKeyboardWillHide' notification.
  func addObservers() {
    
  }
  
  /// Move TextFields to keyboard. Step 6: Method to remove observers.
  func removeObservers() {
    NotificationCenter.default.removeObserver(self)
  }
  
  /// Move TextFields to keyboard. Step 4: Add method to handle keyboardWillShow notification, we're using this method to adjust scrollview to show hidden textfield under keyboard.
  func keyboardWillShow(notification: Notification) {
    guard let userInfo = notification.userInfo,
      let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
        return
    }
    heightConstraint?.constant = view.frame.height - frame.height - 180
    heightConstraint?.isActive = true
  }
  
  /// Move TextFields to keyboard. Step 5: Method to reset scrollview when keyboard is hidden.
  func keyboardWillHide(notification: Notification) {
    //    scrollView.contentInset = UIEdgeInsets.zero
    heightConstraint?.constant = memoTextInput.textView.contentSize.height > 200 ? memoTextInput.textView.contentSize.height : 200
    heightConstraint?.isActive = true
  }
  
  
  lazy var scrollView: UIScrollView = {
    let scroll = UIScrollView()
    scroll.shouldIgnoreScrollingAdjustment = true
    scroll.translatesAutoresizingMaskIntoConstraints = false
    return scroll
  }()
  lazy var titleLabel : UILabel = {
    let label = UILabel()
    label.text = "여행"
    label.textColor = .black
    label.font = .sb28
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  lazy var titleTextInput : LineAnimateTextFieldView = {
    let text = LineAnimateTextFieldView()
    text.configure(title: "장소", placeHodeler: "장소", Font: .  r14)
    text.translatesAutoresizingMaskIntoConstraints = false
    return text
  }()
  lazy var miniMemoTextInput : LineAnimateTextFieldView = {
    let text = LineAnimateTextFieldView()
    text.configure(title: "힌줄 메모", placeHodeler: "한줄 메모", Font: .r14)
    text.translatesAutoresizingMaskIntoConstraints = false
    //        text.type = .numeric
    return text
  }()
  lazy var memoTextInput : LineAnimateTextView = {
    let text = LineAnimateTextView(description: "메모", placeholder: "메모를 입력해주세요.")
    text.translatesAutoresizingMaskIntoConstraints = false
    //    text.configure(placeHodeler: "메모 입력", Font: .r14)
    //        text.type = .numeric
    return text
  }()
  lazy var colorLabel: UILabel = {
    let label = UILabel()
    label.text = "중요도 컬러 선택"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.font = .sb14
    return label
  }()
  lazy var stackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    return stack
  }()
  
  lazy var collectionview: customCollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    let myCollectionView = customCollectionView(frame: .zero, collectionViewLayout : layout)
    myCollectionView.showsHorizontalScrollIndicator = false
    myCollectionView.translatesAutoresizingMaskIntoConstraints = false
    myCollectionView.backgroundColor = UIColor.clear
    myCollectionView.allowsSelection = true
    myCollectionView.register(colorCVCell.self, forCellWithReuseIdentifier: "Cell")
    return myCollectionView
  }()
  lazy var confirmButton: BottomButton = {
    let button = BottomButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.title = "저장하기"
    button.addTarget(self, action: #selector(saveDidTap), for: .touchUpInside)
    return button
  }()
  func showCollectionView() {
    collectionview.isHidden = !collectionview.isHidden
    collectionview.reloadData()
  }
  @objc func saveDidTap(){
    if colorPik == "" {
      colorPik = "default"
    }
    try! realm.write {
      detailRealmDB?.color = colorPik
      detailRealmDB?.title = titleTextInput.textField.text ?? ""
      detailRealmDB?.memo = memoTextInput.textView.text ?? ""
      detailRealmDB?.oneLineMemo = miniMemoTextInput.textField.text ?? ""
    }
    self.navigationController?.popViewController(animated: true)
  }
  
}


extension TripDetailSpecificDayViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? colorCVCell else {
      return
    }
    colorPik = cell.colorView.backgroundColor!.toString()

    let color = cell.colorView.backgroundColor
    colorLabel.textColor = color
    
    if let beforeSelected = self.selectedColorIndex {
      self.selectedColorIndex = indexPath
      self.collectionview.reloadItems(at: [beforeSelected])
    }
    
    self.selectedColorIndex = indexPath
    self.collectionview.reloadItems(at: [indexPath])
  }
}

extension TripDetailSpecificDayViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! colorCVCell
    let color = HSBrandomColor(num : CGFloat(Double((indexPath.row + 1) * 10) / Double(100)))
    cell.colorView.backgroundColor = color
    
    if selectedColorIndex == indexPath || colorPik == color.toString() {
      if selectedColorIndex == nil {
        selectedColorIndex = indexPath
      }
      let darkenedBase = UIColor(displayP3Red: color.cgColor.components![0] / 2,
                                 green: color.cgColor.components![1] / 2,
                                 blue: color.cgColor.components![2] / 2,
                                 alpha: 1)
      cell.colorView.layer.borderColor = darkenedBase.cgColor
      cell.colorView.layer.borderWidth = 3
    } else {
      cell.colorView.layer.borderColor = UIColor.clear.cgColor
    }
    return cell
  }
  // hsb random color
  func HSBrandomColor(num : CGFloat) -> UIColor{
    let saturation : CGFloat =  0.45
    let brigtness : CGFloat = 0.85
    let randomHue = num
    return UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1)
  }
}

extension TripDetailSpecificDayViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = 5 * 5
    let availableWidth = collectionView.frame.width - CGFloat(paddingSpace)
    let widthPerItem = availableWidth / 5
    let _: CGFloat = 80
    return CGSize(width: widthPerItem, height: widthPerItem)
    
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
}

class customCollectionView: UICollectionView {
  override func reloadData() {
    super.reloadData()
    self.invalidateIntrinsicContentSize()
  }
  
  override var intrinsicContentSize: CGSize {
    return self.collectionViewLayout.collectionViewContentSize
  }
}
