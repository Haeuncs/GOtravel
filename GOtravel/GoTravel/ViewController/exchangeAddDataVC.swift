//
//  exchangeAddDataVC.swift
//  GOtravel
//
//  Created by OOPSLA on 04/02/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import AnimatedTextInput
import IQKeyboardManagerSwift


// exchangeVC 에서 추가 시 나타나는 뷰
class exchangeAddDataVC : UIViewController {
    
    // addDetailVC 에서 전달 받는 데이터
    var countryRealmDB = countryRealm()
    var selectDay = 0

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let rightButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = rightButton

//        IQKeyboardManager.shared.enable = true
        if selectDay != 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M월 dd일"
            dateFormatter.locale = Locale(identifier: "ko-KR")
            let startDay = dateFormatter.string(from: (Calendar.current.date(byAdding: .day, value: selectDay - 1, to: countryRealmDB.date!)!))
            self.navigationItem.title = "\(selectDay)일차, \(startDay)"
        }else{
            self.navigationItem.title = "여행 전"
        }
        
        catecoryCVV.categoryListRealmDB = countryRealmDB.categoryList
        
        view.backgroundColor = .white
        stack.addArrangedSubview(catecoryLabel)
        stack.addArrangedSubview(catecoryCVV)
        stack.addArrangedSubview(mountOfMoney)
        stack.addArrangedSubview(mountView)
        stack.addArrangedSubview(memoLabel)
        stack.addArrangedSubview(memoTextField)
        self.addLineToView(view: memoTextField, position:.LINE_POSITION_BOTTOM, color: UIColor.darkGray, width: 0.5)
        
//        stack.addArrangedSubview(miniMemoTextInput)
        view.addSubview(stack)
        
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
//            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            
            catecoryCVV.heightAnchor.constraint(equalToConstant: 100),
            mountView.heightAnchor.constraint(equalToConstant: 200)
            ])
    }
    let stack  : UIStackView = {
       let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.axis = .vertical
        return stack
    }()
    let catecoryLabel : UILabel = {
       let label = UILabel()
        label.text = "카테고리"
        label.textColor = Defaull_style.mainTitleColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    let catecoryCVV : catecoryCVView = {
        let cv = catecoryCVView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .yellow
        return cv
    }()
    // 환율, 한화
    let mountView : moneyExchangeView = {
        let cv = moneyExchangeView()
        cv.translatesAutoresizingMaskIntoConstraints = false

        cv.backgroundColor = #colorLiteral(red: 0.9349880424, green: 0.9349917763, blue: 0.9349917763, alpha: 1)
        cv.layer.cornerRadius = 8
        return cv
    }()

    let mountOfMoney : UILabel = {
        let label = UILabel()
        label.text = "금액"
        label.textColor = Defaull_style.mainTitleColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    let memoLabel : UILabel = {
        let label = UILabel()
        label.text = "한줄 메모"
        label.textColor = Defaull_style.mainTitleColor
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    let memoTextField : UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    // 텍스트 필드 아래에 줄 추가
    enum LINE_POSITION {
        case LINE_POSITION_TOP
        case LINE_POSITION_BOTTOM
    }
    
    func addLineToView(view : UIView, position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        view.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
        
        switch position {
        case .LINE_POSITION_TOP:
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        default:
            break
        }
    }

    let  miniMemoTextInput : AnimatedTextInput = {
        let text = AnimatedTextInput()
        text.placeHolderText = "한줄 메모"
        text.translatesAutoresizingMaskIntoConstraints = false
        text.style = CustomMemoTextInputStyle()
        //        text.type = .numeric
        return text
    }()
    

    // 화면 터치 시 키보드 없앰
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
        
    }

    func initView(){
        
    }
    
}
class moneyExchangeView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectStackView.addArrangedSubview(koreaMoneyButton)
        selectStackView.addArrangedSubview(foreignMoneyButton)
    
        leftView.addSubview(leftLabel)
        leftView.addSubview(leftBelowLabel)
        rightView.addSubview(rightLabel)
        rightView.addSubview(rightBelowLabel)
        
        selectStackCountry.addArrangedSubview(leftView)
        selectStackCountry.addArrangedSubview(rightView)

        leftTextFieldView.addSubview(uiviewLine)
        leftTextFieldView.addSubview(leftTextField)
        rightTextFieldView.addSubview(rightTextField)
        
        moneyTextFieldStack.addArrangedSubview(leftTextFieldView)
        moneyTextFieldStack.addArrangedSubview(rightTextFieldView)
        
        stack.addArrangedSubview(selectStackView)
        stack.addArrangedSubview(selectStackCountry)
        stack.addArrangedSubview(moneyTextFieldStack)
        
//        uiviewLine.frame = CGRect(x: 0, y: 0, width: 10, height: 3)
        
        
        self.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            
            leftLabel.bottomAnchor.constraint(equalTo: leftView.centerYAnchor, constant: 0),
            leftLabel.centerXAnchor.constraint(equalTo: leftView.centerXAnchor, constant: 0),
            
            leftBelowLabel.topAnchor.constraint(equalTo: leftLabel.bottomAnchor, constant: 0),
            leftBelowLabel.centerXAnchor.constraint(equalTo: leftView.centerXAnchor, constant: 0),
            
            
            rightLabel.bottomAnchor.constraint(equalTo: rightView.centerYAnchor, constant: 0),
            rightLabel.centerXAnchor.constraint(equalTo: rightView.centerXAnchor, constant: 0),
            
            rightBelowLabel.topAnchor.constraint(equalTo: rightLabel.bottomAnchor, constant: 0),
            rightBelowLabel.centerXAnchor.constraint(equalTo: rightView.centerXAnchor, constant: 0),

//            uiviewLine.centerXAnchor.constraint(equalTo: leftTextFieldView.centerXAnchor, constant: 0),
//            uiviewLine.centerYAnchor.constraint(equalTo: leftTextFieldView.centerYAnchor, constant: 0),
//            uiviewLine.widthAnchor.constraint(equalToConstant: 10),
//            uiviewLine.heightAnchor.constraint(equalToConstant: 3),
            
            ])
        
    }
    let stack : UIStackView = {
      let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    // 한화인지 한율인지
    let selectStackView : UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
//        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let koreaMoneyButton : UIButton = {
       let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Defaull_style.mainTitleColor, for: .normal)
        button.setTitle("한화", for: .normal)
        return button
    }()
    let foreignMoneyButton : UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(Defaull_style.mainTitleColor, for: .normal)

        button.setTitle("환율", for: .normal)
        return button
    }()
    let selectStackCountry : UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
//        view.spacing = 5
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let leftView : UIView = {
       let view = UIView()
//        view.layer.cornerRadius = 3
        view.backgroundColor = #colorLiteral(red: 0.9349880424, green: 0.9349917763, blue: 0.9349917763, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let rightView : UIView = {
        let view = UIView()
//        view.layer.cornerRadius = 3
        view.backgroundColor = #colorLiteral(red: 0.9349880424, green: 0.9349917763, blue: 0.9349917763, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let leftLabel : UILabel = {
        let label = UILabel()
        label.text = "한국-원"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = Defaull_style.mainTitleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let leftBelowLabel : UILabel = {
        let label = UILabel()
        label.text = "KRW"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = Defaull_style.mainTitleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rightLabel : UILabel = {
        let label = UILabel()
        label.text = "한국-원"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = Defaull_style.mainTitleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let rightBelowLabel : UILabel = {
        let label = UILabel()
        label.text = "KRW"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = Defaull_style.mainTitleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let moneyTextFieldStack : UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let leftTextFieldView : UIView = {
        let view = UIView()
//        view.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let leftTextField : UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    let rightTextField : UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()

    let rightTextFieldView : UIView = {
        let view = UIView()
//        view.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let uiviewLine : UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
}
class catecoryCVView : UIView ,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , UICollectionViewDelegate{
    
    var catecoryCV     : UICollectionView!
    // addDetailVC 에서 전달 받는 데이터
    var categoryListRealmDB = List<categoryDetailRealm>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("layout")
        
        print(self.frame)
        self.backgroundColor = .yellow
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: 50, height: 50)
        
        
        catecoryCV = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), collectionViewLayout: layout)
        catecoryCV.register(exchangeCVCell2.self, forCellWithReuseIdentifier: "Cell")

        catecoryCV.backgroundColor = .red
        catecoryCV.delegate = self
        catecoryCV.dataSource = self
        catecoryCV.showsHorizontalScrollIndicator = false
        
        self.addSubview(catecoryCV)
        
//        NSLayoutConstraint.activate([
//            catecoryCV.topAnchor.constraint(equalTo: self.topAnchor),
//            catecoryCV.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            catecoryCV.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            catecoryCV.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            
////            catecoryCV.centerXAnchor.constraint(equalTo: self.centerXAnchor),
////            catecoryCV.centerYAnchor.constraint(equalTo: self.centerYAnchor)
//            ])
//        

    }
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: 50, height: 50)
//
//        catecoryCV.register(exchangeCVCell2.self, forCellWithReuseIdentifier: "Cell")
//
//        catecoryCV = UICollectionView(frame: self.frame, collectionViewLayout: layout)
//        catecoryCV.backgroundColor = UIColor.clear
//        catecoryCV.delegate = self
//        catecoryCV.dataSource = self
//        catecoryCV.showsHorizontalScrollIndicator = false
//
//        self.addSubview(catecoryCV)
//
////        NSLayoutConstraint.activate([
////            catecoryCV.topAnchor.constraint(equalTo: self.topAnchor),
////            catecoryCV.bottomAnchor.constraint(equalTo: self.bottomAnchor),
////            catecoryCV.leadingAnchor.constraint(equalTo: self.leadingAnchor),
////            catecoryCV.trailingAnchor.constraint(equalTo: self.trailingAnchor),
////
//////            catecoryCV.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//////            catecoryCV.centerYAnchor.constraint(equalTo: self.centerYAnchor)
////            ])
//    }
//
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryListRealmDB.count
    }
//
//
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! exchangeCVCell2
        cell.dayLabel.text = categoryListRealmDB[indexPath.row].title
        return cell
    }
//////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//////    {
//////
//////        return CGSize(width: 100, height: myCollectionViewHeight)
//////
//////    }
//////
//////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
////
//////    {
//////
//////        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//////    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
//        // 선택된 셀 보더 바꾸기
//        let cell = collectionView.cellForItem(at: indexPath) as! exchangeCVCell
//        cell.layer.borderWidth = 2
//        print(indexPath.row)
//        //        belowView.backgroundColor = HSBrandomColor()
    }
////    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
////        let cell=collectionView.cellForItem(at: indexPath)
////        cell?.layer.borderWidth = 1
////
////    }
//
//    let CV : UICollectionView = {
//        let view = UICollectionView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
}
class exchangeCVCell2 : UICollectionViewCell {
    let dayLabel : UILabel = {
        let label = UILabel()
        label.text = "1일"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = Defaull_style.dateColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func layoutInit(){
        self.backgroundColor = .green
        self.addSubview(dayLabel)
        
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
    }
}
struct CustomMemoTextInputStyle: AnimatedTextInputStyle {
    let placeholderInactiveColor = Defaull_style.mainTitleColor
    let activeColor = Defaull_style.mainTitleColor
    let inactiveColor = Defaull_style.mainTitleColor
    let lineInactiveColor = Defaull_style.mainTitleColor
    let lineActiveColor = Defaull_style.mainTitleColor
    let lineHeight: CGFloat = 1
    let errorColor = UIColor.red
    let textInputFont = UIFont.systemFont(ofSize: 16)
    let textInputFontColor = UIColor.black
    let placeholderMinFontSize: CGFloat = 16
    let counterLabelFont: UIFont? = UIFont.systemFont(ofSize: 16)
    let leftMargin: CGFloat = 5
    let topMargin: CGFloat = 25
    let rightMargin: CGFloat = 5
    let bottomMargin: CGFloat = 5
    let yHintPositionOffset: CGFloat = 7
    let yPlaceholderPositionOffset: CGFloat = 0
    public let textAttributes: [String: Any]? = nil
}
