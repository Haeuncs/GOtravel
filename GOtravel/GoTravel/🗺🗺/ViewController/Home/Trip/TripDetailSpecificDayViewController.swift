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


class TripDetailSpecificDayViewController: BaseUIViewController {
  var disposeBag = DisposeBag()
  
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
    
    guard let db = detailRealmDB else {
      return
    }
    if db.color != "default" {
      let colorArr = db.color.components(separatedBy: " ")
      var stylee = CustomTextInputStyle()
      stylee.setPlace(color:
        UIColor.init(red: characterToCgfloat(str: colorArr[0]),
                     green: characterToCgfloat(str: colorArr[1]),
                     blue: characterToCgfloat(str: colorArr[2]),
                     alpha: characterToCgfloat(str: colorArr[3])))
      colorSelectionInput.style = stylee
    }
    titleLabel.text = (countryRealmDB?.city ?? "") + " 여행"
    titleTextInput.text = db.title
    miniMemoTextInput.text = db.oneLineMemo
    memoTextInput.text = db.memo
    colorPik = db.color
  }
  func characterToCgfloat(str : String) -> CGFloat {
    let n = NumberFormatter().number(from: str)
    return n as! CGFloat
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    disposeBag = DisposeBag()
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
    scrollView.addSubview(colorSelectionInput)
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
    colorSelectionInput.snp.makeConstraints { (make) in
      make.top.equalTo(miniMemoTextInput.snp.bottom).offset(12)
      make.leading.trailing.equalTo(contentView)
      
    }
    stackView.snp.makeConstraints { (make) in
      make.top.equalTo(colorSelectionInput.snp.bottom)
      make.leading.trailing.equalTo(contentView)
    }
    collectionview.snp.makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalTo(stackView)
    }
    memoTextInput.snp.makeConstraints { (make) in
      make.top.equalTo(stackView.snp.bottom).offset(12)
      make.leading.trailing.equalTo(contentView)
      make.bottom.equalTo(scrollView.snp.bottom)
    }
    confirmButton.snp.makeConstraints { (make) in
      make.height.equalTo(56)
      make.leading.equalTo(view.snp.leading).offset(16)
      make.trailing.equalTo(view.snp.trailing).offset(-16)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-45)
      
    }
  }
  lazy var scrollView: UIScrollView = {
    let scroll = UIScrollView()
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
  lazy var titleTextInput : AnimatedTextInput = {
    let text = AnimatedTextInput()
    text.placeHolderText = "장소"
    text.translatesAutoresizingMaskIntoConstraints = false
    text.style = CustomTextInputStyle()
    return text
  }()
  lazy var miniMemoTextInput : AnimatedTextInput = {
    let text = AnimatedTextInput()
    text.placeHolderText = "한줄 메모"
    text.translatesAutoresizingMaskIntoConstraints = false
    text.style = CustomTextInputStyle()
    //        text.type = .numeric
    return text
  }()
  lazy var memoTextInput : AnimatedTextInput = {
    let text = AnimatedTextInput()
    text.placeHolderText = "메모 입력"
    text.type = .multiline
    text.showCharacterCounterLabel(with: 300)
    text.translatesAutoresizingMaskIntoConstraints = false
    text.lineSpacing = 15
    text.font = UIFont.systemFont(ofSize: 13)
    text.style = CustomTextInputStyle()
    //        text.type = .numeric
    return text
  }()
  lazy var colorSelectionInput : AnimatedTextInput = {
    let select = AnimatedTextInput()
    select.style = CustomTextInputStyle()
    select.translatesAutoresizingMaskIntoConstraints = false
    select.placeHolderText = "중요도 컬러 선택"
    select.type = .selection
    select.tapAction = { [weak self] in
      print("tap")
      self?.showCollectionView()
    }
    //            { [weak self] in
    //            guard let strongself = self else { return }
    //            strongself.tap()
    //            } as (() -> Void)
    return select
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
    myCollectionView.translatesAutoresizingMaskIntoConstraints=false
    myCollectionView.backgroundColor=UIColor.clear
    myCollectionView.allowsMultipleSelection=false
    myCollectionView.isHidden = true
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
      detailRealmDB?.title = titleTextInput.text!
//      detailRealmDB?.startTime = startTime
//      detailRealmDB?.EndTime = endTime
      detailRealmDB?.memo = memoTextInput.text!
      detailRealmDB?.oneLineMemo = miniMemoTextInput.text!
    }
    self.navigationController?.popViewController(animated: true)
  }
}


extension TripDetailSpecificDayViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! colorCVCell
    cell.colorView.layer.borderWidth = 3
    let color = cell.colorView.backgroundColor
    let darkenedBase = UIColor(displayP3Red: color!.cgColor.components![0] / 2, green: color!.cgColor.components![1] / 2, blue: color!.cgColor.components![2] / 2, alpha: 1)
    
    cell.colorView.layer.borderColor = darkenedBase.cgColor
    
    colorPik = cell.colorView.backgroundColor!.toString()
    
    var stylee = CustomTextInputStyle()
    stylee.setPlace(color: color ?? UIColor.gray)
    colorSelectionInput.style = stylee
    
  }
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! colorCVCell
    cell.colorView.layer.borderWidth = 3
    cell.colorView.layer.borderColor = UIColor.clear.cgColor
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
    if color.toString() == colorPik {
      let darkenedBase = UIColor(displayP3Red: color.cgColor.components![0] / 2, green: color.cgColor.components![1] / 2, blue: color.cgColor.components![2] / 2, alpha: 1)
      cell.colorView.layer.borderColor = darkenedBase.cgColor
      cell.colorView.layer.borderWidth = 3
      var stylee = CustomTextInputStyle()
      stylee.setPlace(color: color)
      colorSelectionInput.style = stylee
    }else{
      cell.colorView.layer.borderColor = UIColor.clear.cgColor
    }
    //        cell.colorView.layer.borderWidth = 1
    return cell
  }
  // hsb random color
  func HSBrandomColor(num : CGFloat) -> UIColor{
    let saturation : CGFloat =  0.45
    let brigtness : CGFloat = 0.85
    let randomHue = num
    //        print(UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1))
    return UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1)
  }
}

extension TripDetailSpecificDayViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = 5 * 5
    let availableWidth = collectionView.frame.width - CGFloat(paddingSpace)
    let widthPerItem = availableWidth / 5
    let _: CGFloat = 80
    //        print(widthPerItem)
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
