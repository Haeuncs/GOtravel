//
//  changeDetailView.swift
//  GOtravel
//
//  Created by OOPSLA on 20/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit
import AnimatedTextInput

class changeDetailView : UIView,UICollectionViewDelegate,UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,changeDetailVCVDelegate {
  func inputData() -> (title: String, startTime: Date, endTime: Date, color: String, memo: String) {
    return (titleTextInput.text!,startTime!,endTime!,colorPik,memoText)
  }
  var detailRealmDB : detailRealm?
  
  weak var delegate : changeDelegate?
  
  var startTime : Date?
  var endTime : Date?
  var colorPik : String = ""
  var memoText : String = ""
  
  var realViewWidth = CGFloat()
  var calcHeight = CGFloat()
  
  let dateFormatter = DateFormatter()
  
  var cellId = "Cell"
  
  let collectionview: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    let myCollectionView=UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout : layout)
    myCollectionView.showsHorizontalScrollIndicator = false
    myCollectionView.translatesAutoresizingMaskIntoConstraints=false
    myCollectionView.backgroundColor=UIColor.clear
    myCollectionView.allowsMultipleSelection=false
    myCollectionView.isHidden = true
    
    return myCollectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    //        print(UIScreen.main.bounds.width)
    print("init")
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    //        print(self.frame)
    print("layout")
    realViewWidth = self.frame.width
    initView()
    
    var stylee = CustomTextInputStyle()
    if detailRealmDB?.color != "default"{
      if colorPik != "" {
        let colorArr = colorPik.components(separatedBy: " ")
        let colorText = UIColor.init(red: colorArr[0].characterToCgfloat() , green: colorArr[1].characterToCgfloat(), blue: colorArr[2].characterToCgfloat(), alpha: colorArr[3].characterToCgfloat())
        
        stylee.setPlace(color: colorText)
        selection.style = stylee
        
      }else{
        let colorArr = detailRealmDB?.color.components(separatedBy: " ")
        let colorText = UIColor.init(red: colorArr![0].characterToCgfloat() , green: colorArr![1].characterToCgfloat(), blue: colorArr![2].characterToCgfloat(), alpha: colorArr![3].characterToCgfloat())
        
        stylee.setPlace(color: colorText)
        selection.style = stylee
      }
    }else{
      let colorText = UIColor.gray
      
      stylee.setPlace(color: colorText)
      selection.style = stylee
    }
  }
  
  func initView(){
    
    //        print(frame.width)
    //        layout.itemSize = CGSize(width: self.frame.width/5, height: 40)
    //        collectionview = UICollectionView(frame: frame, collectionViewLayout: layout)
    collectionview.register(colorCVCell.self, forCellWithReuseIdentifier: "Cell")
    
    collectionview.dataSource = self
    collectionview.delegate = self
    collectionview.showsVerticalScrollIndicator = false
    //        collectionview.backgroundColor = UIColor.red
    
    addSubview(myStackView)
    myStackView.backgroundColor = .blue
    
    myStackView.addArrangedSubview(mainTitle)
    myStackView.addArrangedSubview(titleTextInput)
    myStackView.addArrangedSubview(miniMemoTextInput)
    myStackView.addArrangedSubview(timeStack)
    deleteAndSaveStack.addArrangedSubview(deleteBtn)
    deleteAndSaveStack.addArrangedSubview(addBtn)
    
    myStackView.addArrangedSubview(timePickerStart)
    myStackView.addArrangedSubview(timePickerEnd)
    myStackView.addArrangedSubview(deleteAndSaveStack)
    myStackView.addArrangedSubview(selection)
    selection.tapAction = {
      self.initState(selectIndex: 2)
    }
    myStackView.addArrangedSubview(collectionview)
    
    //        myStackView.addArrangedSubview(categoryLabel4)
    myStackView.addArrangedSubview(memoTextInput)
    
    addSubview(showMap)
    
    calcHeight = (realViewWidth - (5*5))/5
    //        print(calcHeight)
    deleteBtn.addTarget(self, action: #selector(self.deleteBtnSelect), for: .touchUpInside)
    addBtn.addTarget(self, action: #selector(self.addBtnSelect), for: .touchUpInside)
    initLayout()
  }
  @objc func addBtnSelect(){
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    
    
    if timePickerStart.isHidden{
      // start가 숨겨져 있으면 end임
      endTime = timePickerEnd.date
      let date = dateFormatter.string(from: timePickerEnd.date)
      
      print(date as Any)
    }else{
      startTime = timePickerStart.date
      let date = dateFormatter.string(from: timePickerStart.date)
      
      print(date as Any)
      
    }
  }
  @objc func deleteBtnSelect(){
    if timePickerStart.isHidden {
      // 숨겨져있으면
      timePickerEnd.isHidden = true
      deleteAndSaveStack.isHidden = true
    }
    else{
      timePickerStart.isHidden = true
      deleteAndSaveStack.isHidden = true
      
    }
  }
  func initState(selectIndex : Int) {
    print(selectIndex)
    if selectIndex == 0 {
      self.timeSelectionEnd.style = CustomTextInputStyle()
      timePickerStart.isHidden = !timePickerStart.isHidden
      deleteAndSaveStack.isHidden = timePickerStart.isHidden
      //            timeSelectionEnd.isHidden = true
      collectionview.isHidden = true
      timePickerEnd.isHidden = true
      self.endEditing(true)
    }else if selectIndex == 1 {
      self.timeSelectionStart.style = CustomTextInputStyle()
      timePickerEnd.isHidden = !timePickerEnd.isHidden
      deleteAndSaveStack.isHidden = timePickerEnd.isHidden
      timePickerStart.isHidden = true
      collectionview.isHidden = true
      self.endEditing(true)
    }else if selectIndex == 2{
      self.timeSelectionStart.style = CustomTextInputStyle()
      self.timeSelectionEnd.style = CustomTextInputStyle()
      collectionview.isHidden = !collectionview.isHidden
      deleteAndSaveStack.isHidden = true
      timePickerStart.isHidden = true
      //            timeSelectionEnd.isHidden = true
      timePickerEnd.isHidden = true
      deleteAndSaveStack.isHidden = true
      collectionview.reloadData()
      self.endEditing(true)
    }
    
    
  }
  let myStackView: UIStackView = {
    let stackView=UIStackView()
    stackView.distribution = .fill
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints=false
    return stackView
  }()
  let showMap : UIButton = {
    let b = UIButton()
    b.translatesAutoresizingMaskIntoConstraints=false
    b.layer.cornerRadius = 5
    b.puls()
    b.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
    b.setTitle("길찾기", for: .normal)
    b.setTitleColor(.white, for: .normal)
    b.addTarget(self, action: #selector(mapSearch), for: .touchUpInside)
    return b
  }()
  @objc func mapSearch(){
    delegate?.showAlert(longitude : (detailRealmDB?.longitude)!, latitude : (detailRealmDB?.latitude)!, title : detailRealmDB?.title ?? "")
  }
  let spacingView : UIView = {
    let view = UIView()
    view.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
    view.backgroundColor = .red
    return view
  }()
  func initLayout(){
    self.backgroundColor = .white
    NSLayoutConstraint.activate([
      myStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
      myStackView.leftAnchor.constraint(equalTo: leftAnchor),
      myStackView.rightAnchor.constraint(equalTo: rightAnchor),
      collectionview.heightAnchor.constraint(equalToConstant: calcHeight*2),
      showMap.heightAnchor.constraint(equalToConstant: 50),
      showMap.widthAnchor.constraint(equalToConstant: self.frame.width - 10),
      showMap.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
      showMap.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50),
      // FIXIT : 메모 인풋 ㅠㅠ;;
      memoTextInput.heightAnchor.constraint(equalToConstant: 50)
      //            memoTextInput.topAnchor.constraint(equalTo: collectionview.bottomAnchor)
      //            myStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
//  lazy var navView: CustomNavigationBarView = {
//    let view = CustomNavigationBarView()
//    view.translatesAutoresizingMaskIntoConstraints = false
//    view.setTitle(title: "")
//    view.setLeftIcon(image: UIImage(named: "back")!)
//    view.dismissBtn.addTarget(self, action: #selector(popEvent), for: .touchUpInside)
//    return view
//  }()
  lazy var mainTitle : UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.text = "일본 오사카 여행"
    //        label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let  titleTextInput : AnimatedTextInput = {
    let text = AnimatedTextInput()
    text.placeHolderText = "장소"
    text.translatesAutoresizingMaskIntoConstraints = false
    text.style = CustomTextInputStyle()
    //        text.type = .numeric
    return text
  }()
  let  cityTextInput : AnimatedTextInput = {
    let text = AnimatedTextInput()
    text.placeHolderText = "도시"
    text.translatesAutoresizingMaskIntoConstraints = false
    text.style = CustomTextInputStyle()
    //        text.type = .numeric
    return text
  }()
  let selection : AnimatedTextInput = {
    let select = AnimatedTextInput()
    select.translatesAutoresizingMaskIntoConstraints = false
    select.placeHolderText = "중요도 컬러 선택"
    select.type = .selection
    select.tapAction = {
      print("tap")
    }
    //            { [weak self] in
    //            guard let strongself = self else { return }
    //            strongself.tap()
    //            } as (() -> Void)
    return select
  }()
  let categoryLabel1 : UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    label.text = "장소 편집"
    //        label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  let categoryLabel2 : UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    label.text = "시간 설정"
    //        label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let categoryLabel3 : UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    label.text = "중요도"
    //        label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.isHidden = true
    return label
  }()
  
  let categoryLabel4 : UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    label.text = "메모"
    //        label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  let deleteBtn : UIButton = {
    let button = UIButton()
    button.backgroundColor = UIColor.myRed
    button.setTitle("취소", for: .normal)
    
    button.translatesAutoresizingMaskIntoConstraints=false
    return button
  }()
  let addBtn : UIButton = {
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
    stack.isHidden = true
    
    stack.translatesAutoresizingMaskIntoConstraints=false
    
    return stack
  }()
  
  
  
  let  memoTextInput : AnimatedTextInput = {
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
  let  miniMemoTextInput : AnimatedTextInput = {
    let text = AnimatedTextInput()
    text.placeHolderText = "한줄 메모"
    text.translatesAutoresizingMaskIntoConstraints = false
    text.style = CustomTextInputStyle()
    //        text.type = .numeric
    return text
  }()
  
  
  let timeStack : UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.distribution = .fillEqually
    stack.axis = .horizontal
    return stack
  }()
  let timeSelectionStart : AnimatedTextInput = {
    let select = AnimatedTextInput()
    select.translatesAutoresizingMaskIntoConstraints = false
    select.placeHolderText = "시작 시간"
    select.type = .selection
    select.style = CustomTextInputStyle()
    //            { [weak self] in
    //            guard let strongself = self else { return }
    //            strongself.tap()
    //            } as (() -> Void)
    return select
  }()
  let timeSelectionEnd : AnimatedTextInput = {
    let select = AnimatedTextInput()
    select.translatesAutoresizingMaskIntoConstraints = false
    select.placeHolderText = "종료 시간"
    select.type = .selection
    select.style = CustomTextInputStyle()
    select.tapAction = {
      print("tap")
    }
    //            { [weak self] in
    //            guard let strongself = self else { return }
    //            strongself.tap()
    //            } as (() -> Void)
    return select
  }()
  
  let timePickerStart : UIDatePicker = {
    let picker = UIDatePicker()
    picker.isHidden = true
    picker.translatesAutoresizingMaskIntoConstraints = false
    picker.datePickerMode = .time
    return picker
  }()
  let timePickerEnd : UIDatePicker = {
    let picker = UIDatePicker()
    picker.isHidden = true
    picker.translatesAutoresizingMaskIntoConstraints = false
    picker.datePickerMode = .time
    return picker
  }()
  let timeSaveBtn : UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.isHidden = true
    button.backgroundColor = .gray
    button.layer.cornerRadius = 10 / 2.0
    button.titleLabel?.text = "저장"
    button.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
    return button
  }()
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    self.timeSelectionStart.style = CustomTextInputStyle()
    self.timeSelectionEnd.style = CustomTextInputStyle()
    self.endEditing(true)
    
  }
  //    let collectionView : UICollectionView = {
  //        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
  //        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  //        layout.itemSize = CGSize(width: 100, height: 700)
  //
  //        let myCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
  //        myCollectionView.isHidden = true
  //        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
  //        myCollectionView.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
  ////        myCollectionView
  //        return myCollectionView
  //    }()
  //    let timePickerEnd : UIDatePicker = {
  //        let picker = UIDatePicker()
  //        picker.translatesAutoresizingMaskIntoConstraints = false
  //
  //        picker.datePickerMode = .time
  //        return picker
  //    }()
  
  //        let timePicker: UIPickerView = UIPickerView()
  //        //assign delegate and datasoursce to its view controller
  //        timePicker.delegate = self
  //        timePicker.dataSource = self
  //
  //        // setting properties of the pickerView
  //        timePicker.translatesAutoresizingMaskIntoConstraints = false
  ////        timePicker.frame = CGRect(x: 0, y: 50, width: frame.width, height: 200)
  //        timePicker.backgroundColor = .white
  //
  
  //    func tap() {
  //        let vc = UIViewController()
  //        vc.view.backgroundColor = UIColor.blue
  //        present(vc, animated: true) {
  //            if let text = self.textInputs[3].text, text.isEmpty {
  //                self.textInputs[3].text = "Some option the user did select"
  //            } else {
  //                self.textInputs[3].text = nil
  //            }
  //            vc.dismiss(animated: true, completion: nil)
  //        }
  //    }
}
extension changeDetailView {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  // hsb random color
  func HSBrandomColor(num : CGFloat) -> UIColor{
    let saturation : CGFloat =  0.45
    let brigtness : CGFloat = 0.85
    let randomHue = num
    //        print(UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1))
    return UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! colorCVCell
    cell.colorView.backgroundColor =  HSBrandomColor(num : CGFloat(Double((indexPath.row + 1) * 10) / Double(100)))
    cell.colorView.layer.borderColor = UIColor.clear.cgColor
    //        cell.colorView.layer.borderWidth = 1
    return cell
  }
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
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! colorCVCell
    print("select!~!")
    print(indexPath.row)
    cell.colorView.layer.borderWidth = 3
    let color = cell.colorView.backgroundColor
    let darkenedBase = UIColor(displayP3Red: color!.cgColor.components![0] / 2, green: color!.cgColor.components![1] / 2, blue: color!.cgColor.components![2] / 2, alpha: 1)
    
    cell.colorView.layer.borderColor = darkenedBase.cgColor
    
    colorPik = cell.colorView.backgroundColor!.toString()
    
    var stylee = CustomTextInputStyle()
    stylee.setPlace(color: color ?? UIColor.gray)
    selection.style = stylee
    
  }
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! colorCVCell
    print("deselect!~!")
    print(indexPath.row)
    cell.colorView.layer.borderWidth = 3
    
    cell.colorView.layer.borderColor = UIColor.clear.cgColor
    
    
    
  }
}
class colorCVCell : UICollectionViewCell {
  let widthSize = CGFloat(40)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    //        backgroundColor = .red
    setupView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func setupView(){
    addSubview(colorView)
    colorView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    colorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    colorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    colorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    
  }
  let colorView : UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    view.layer.cornerRadius = 40/2.0
    view.clipsToBounds = true
    
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
}
struct selectColorChange: AnimatedTextInputStyle {
  let placeholderInactiveColor = UIColor.red
  let activeColor = Defaull_style.mainTitleColor
  let inactiveColor = UIColor.gray.withAlphaComponent(0.3)
  let lineInactiveColor = UIColor.gray.withAlphaComponent(0.3)
  let lineActiveColor = UIColor.gray.withAlphaComponent(0.3)
  let lineHeight: CGFloat = 1
  let errorColor = UIColor.red
  let textInputFont = UIFont.systemFont(ofSize: 14)
  let textInputFontColor = UIColor.black
  let placeholderMinFontSize: CGFloat = 12
  let counterLabelFont: UIFont? = UIFont.systemFont(ofSize: 12)
  let leftMargin: CGFloat = 5
  let topMargin: CGFloat = 20
  let rightMargin: CGFloat = 5
  let bottomMargin: CGFloat = 5
  let yHintPositionOffset: CGFloat = 7
  let yPlaceholderPositionOffset: CGFloat = 0
  public let textAttributes: [String: Any]? = nil
  
}
struct CustomTextInputStyle: AnimatedTextInputStyle {
  var placeholderInactiveColor = UIColor.gray
  let activeColor = Defaull_style.mainTitleColor
  let inactiveColor = UIColor.gray.withAlphaComponent(0.3)
  let lineInactiveColor = UIColor.gray.withAlphaComponent(0.3)
  let lineActiveColor = UIColor.gray.withAlphaComponent(0.3)
  let lineHeight: CGFloat = 1
  let errorColor = UIColor.red
  let textInputFont = UIFont.systemFont(ofSize: 14)
  let textInputFontColor = UIColor.black
  let placeholderMinFontSize: CGFloat = 12
  let counterLabelFont: UIFont? = UIFont.systemFont(ofSize: 12)
  let leftMargin: CGFloat = 5
  let topMargin: CGFloat = 20
  let rightMargin: CGFloat = 5
  let bottomMargin: CGFloat = 5
  let yHintPositionOffset: CGFloat = 7
  let yPlaceholderPositionOffset: CGFloat = 0
  public let textAttributes: [String: Any]? = nil
  
  mutating func setPlace(color : UIColor) {
    placeholderInactiveColor = color
  }
}

//import UIKit
//import AnimatedTextInput
//
//class changeDetailOfViewContoller: UIViewController {
//    var textInputs = AnimatedTextInput()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(textInputs)
//
//        view.backgroundColor = .white
//
//        textInputs.placeHolderText = "Paswword"
//        textInputs.translatesAutoresizingMaskIntoConstraints = false
//        textInputs.style = CustomTextInputStyle()
//        textInputs.type = .password(toggleable: true)
//
//        NSLayoutConstraint.activate([
//            textInputs.topAnchor.constraint(equalTo: view.topAnchor),
//            textInputs.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            textInputs.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            textInputs.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//
//
//            ])
//
//    }
//
//}
//
//struct CustomTextInputStyle: AnimatedTextInputStyle {
//    let placeholderInactiveColor = UIColor.gray
//    let activeColor = #colorLiteral(red: 0.4588235294, green: 0.7176470588, blue: 0.1803921569, alpha: 1)
//    let inactiveColor = UIColor.gray.withAlphaComponent(0.3)
//    let lineInactiveColor = UIColor.gray.withAlphaComponent(0.3)
//    let lineActiveColor = UIColor.gray.withAlphaComponent(0.3)
//    let lineHeight: CGFloat = 1
//    let errorColor = UIColor.red
//    let textInputFont = UIFont.systemFont(ofSize: 14)
//    let textInputFontColor = UIColor.black
//    let placeholderMinFontSize: CGFloat = 12
//    let counterLabelFont: UIFont? = UIFont.systemFont(ofSize: 12)
//    let leftMargin: CGFloat = 0
//    let topMargin: CGFloat = 20
//    let rightMargin: CGFloat = 0
//    let bottomMargin: CGFloat = 10
//    let yHintPositionOffset: CGFloat = 7
//    let yPlaceholderPositionOffset: CGFloat = 0
//    public let textAttributes: [String: Any]? = nil
//}
