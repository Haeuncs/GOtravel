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
class exchangeAddDataVC : UIViewController,exchangeDidTapInViewDelegate {
    
    let realm = try! Realm()
    
    // addDetailVC 에서 전달 받는 데이터
    var countryRealmDB = countryRealm()
    var selectDay = 0
    
    // 저장 시 사용되는 변수
    var subTitle = "기타"
    var exchange = "KRW"
    var money : Double?
    var titleStr : String?
    
    // 계산 시 사용 변수
    var selectForeignMoneyDouble : Double? = nil
    var belowLabel = ""

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @objc func saveAction(){
        if exchange == "KRW" {
            money = mountView.leftTextField.text?.replacingOccurrences(of: ",", with: "").toDouble()
        }else{
            money = mountView.rightTextField.text?.replacingOccurrences(of: ",", with: "").toDouble()
        }
        titleStr = memoTextField.text
        
        let moneyDetailRealmDB = moneyDetailRealm()
        moneyDetailRealmDB.exchange = self.exchange
        moneyDetailRealmDB.subTitle = self.subTitle
        // optional 데이터 체크
        if self.titleStr != "" {
            moneyDetailRealmDB.title = self.titleStr!
        }else{
            showAlert(str: "한줄 메모")
        }
        if self.money != 0.0 {
            moneyDetailRealmDB.money = self.money!
        }else{
            showAlert(str: "금액")
        }
//
        if self.titleStr != "" {
            if self.money != 0.0{
                try! self.realm.write {
                    countryRealmDB.moneyList[selectDay].detailList.append(moneyDetailRealmDB)
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    func showAlert(str : String){
        let alertController = UIAlertController(title: "알림", message: "\(str) 을/를 채워주세요 !", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))

        self.present(alertController, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        mountView.delegate = self
        catecoryCVV.delegate = self
        
        let rightButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(self.saveAction))
        self.navigationItem.rightBarButtonItem = rightButton

        IQKeyboardManager.shared.enable = true
        
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
        stack.addArrangedSubview(memoLabel)
        stack.addArrangedSubview(memoTextField)
        self.addLineToView(view: memoTextField, position:.LINE_POSITION_BOTTOM, color: UIColor.darkGray, width: 0.5)
        stack.addArrangedSubview(mountOfMoney)
        stack.addArrangedSubview(mountView)
        
        view.addSubview(stack)
        
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            catecoryCVV.heightAnchor.constraint(equalToConstant: 100),
            mountView.heightAnchor.constraint(equalToConstant: 200),
            catecoryLabel.heightAnchor.constraint(equalToConstant: 50),
            memoLabel.heightAnchor.constraint(equalToConstant: 50),
            mountOfMoney.heightAnchor.constraint(equalToConstant: 50),
            ])
    }
    let stack  : UIStackView = {
       let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.distribution = .fill
        stack.axis = .vertical
        return stack
    }()
    let catecoryLabel : UILabel = {
       let label = UILabel()
        label.text = " 카테고리"
        label.textColor = Defaull_style.mainTitleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    let catecoryCVV : catecoryCVView = {
        let cv = catecoryCVView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    // 환율, 한화
    let mountView : moneyExchangeView = {
        let cv = moneyExchangeView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = Defaull_style.topTableView
        cv.layer.cornerRadius = CGFloat(Defaull_style.topTableViewCorner)
        return cv
    }()

    let mountOfMoney : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = " 금액"
        label.textColor = Defaull_style.mainTitleColor
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    let memoLabel : UILabel = {
        let label = UILabel()
        label.text = " 한줄 메모"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Defaull_style.mainTitleColor
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    let memoTextField : UITextField = {
        let text = UITextField()
        text.clearButtonMode = .whileEditing
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    // 텍스트 필드 아래에 줄 추가
    
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
    // delegate moneyExchangeView 에서 뷰 이동
    func exchangeDidTapInView(_ sender : moneyExchangeView,selectIndex : Int){
        print("view select")
//        print(sender)
        let cv = exchangeSelectForeignVC()
        cv.delegate = self
        cv.selectIndex = selectIndex
        self.navigationController?.pushViewController(cv, animated: true)
    }
    func exchangeKWR(){
        exchange = "KRW"
        view.endEditing(true)
    }
    func exchangeSelectForeignDidTapCell(selectIndex : Int ,label : String,belowLabel:String, doubleMoney : Double){
        
        selectForeignMoneyDouble = doubleMoney
        print(label)
        print(belowLabel)
        self.belowLabel = belowLabel
        exchange = belowLabel
        view.endEditing(true)
        if selectIndex == 0 {
            self.mountView.leftLabel.text = label
            self.mountView.leftBelowLabel.text = belowLabel
        }else{
            self.mountView.rightLabel.text = label
            self.mountView.rightBelowLabel.text = belowLabel
        }
    }
    func calculatorKoreaMoney(textFieldDouble : Double){
        if selectForeignMoneyDouble != nil {
            if belowLabel != "" {
                if belowLabel == "JPY(100)" || belowLabel == "IDR(100)"{
                    print(selectForeignMoneyDouble)
                    print(textFieldDouble)
                    let divide =  selectForeignMoneyDouble! / Double(100)
                    print(divide)
                    let calculatorText = divide * textFieldDouble
                    print(calculatorText)
                    self.mountView.rightTextField.text =                         String(format: "%.2f", calculatorText)

                }else{
                    print(textFieldDouble * selectForeignMoneyDouble!)
                    self.mountView.rightTextField.text =
                        String(format: "%.2f", textFieldDouble * selectForeignMoneyDouble!)
                }
            }
        }
        
    }
    func collectionViewDidTapCell(subTitle : String){
        self.subTitle = subTitle
    }
}
protocol exchangeDidTapInViewDelegate : class {
    // 뷰 선택 시 이동하는 delegate
    func exchangeDidTapInView(_ sender : moneyExchangeView,selectIndex : Int)
    // 선택한 테이블 셀에서 선택한 데이터
    func exchangeSelectForeignDidTapCell(selectIndex : Int,label : String,belowLabel:String, doubleMoney : Double)
    // 카테고리 collectionView Cell 클릭 시 이벤트
    func collectionViewDidTapCell(subTitle : String)
    // 한화
    func exchangeKWR()
    // 한화로 계산
    func calculatorKoreaMoney(textFieldDouble : Double)
}

enum LINE_POSITION {
    case LINE_POSITION_TOP
    case LINE_POSITION_BOTTOM
}

class moneyExchangeView : UIView ,UITextFieldDelegate{
    weak var delegate : exchangeDidTapInViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func koreaMoneyAction(){
        delegate?.exchangeKWR()
//        leftTextField.text = ""
        rightTextField.text = ""
        
        self.rightTextFieldView.isHidden = true
        self.moneyTextFieldStack.isHidden = false
        self.selectStackCountry.isHidden = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.moneyTextFieldStack.alpha = 1
        }, completion:  nil)
        koreaMoneyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        foreignMoneyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)

    }
    @objc func foreignMoneyAction(){
//        leftTextField.text = ""
        delegate?.exchangeKWR()

        rightTextField.text = ""

        self.rightTextFieldView.isHidden = false
        self.moneyTextFieldStack.isHidden = false
        self.selectStackCountry.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.selectStackCountry.alpha = 1
            self.moneyTextFieldStack.alpha = 1
        }, completion:  nil)

        koreaMoneyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        foreignMoneyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)

    }
    
    var selectView = UIView()
    
    @objc func leftAction(sender : UITapGestureRecognizer) {
        selectView = leftView
        delegate?.exchangeDidTapInView(self, selectIndex: 0)
    }
    @objc func rightAction(sender : UITapGestureRecognizer) {
        selectView = rightView
        delegate?.exchangeDidTapInView(self, selectIndex: 1)

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        koreaMoneyButton.addTarget(self, action: #selector(koreaMoneyAction), for: .touchUpInside)
        foreignMoneyButton.addTarget(self, action: #selector(foreignMoneyAction), for: .touchUpInside)
        
        leftTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        leftTextField.addTarget(self, action: #selector(textFieldDidStart(_:)), for: .touchDown)
        
        rightTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        rightTextField.addTarget(self, action: #selector(textFieldDidStart(_:)), for: .touchDown)
        
        // 뷰 선택 시 사용되는 거
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.leftAction))
//        let gesture2 = UITapGestureRecognizer(target: self, action:  #selector(self.rightAction))

        self.leftView.addGestureRecognizer(gesture)
//        self.rightView.addGestureRecognizer(gesture2)
        
        // 이거 뭔지 기억 안남;ㅜㅜㅜㅜ
//        leftTextField.delegate = self
        
        selectStackView.addArrangedSubview(koreaMoneyButton)
        selectStackView.addArrangedSubview(foreignMoneyButton)
    
        leftView.addSubview(leftLabel)
        leftView.addSubview(leftBelowLabel)
        
        leftView.addSubview(arrowHead)
//        rightView.addSubview(arrowHead2)
        
        rightView.addSubview(rightLabel)
        rightView.addSubview(rightBelowLabel)
        
        selectStackCountry.addArrangedSubview(leftView)
        selectStackCountry.addArrangedSubview(rightView)
//
        leftTextFieldView.addSubview(uiviewLine)
        
        leftTextFieldView.addSubview(leftTextField)
        rightTextFieldView.addSubview(rightTextField)
        
        moneyTextFieldStack.addArrangedSubview(leftTextFieldView)
        moneyTextFieldStack.addArrangedSubview(rightTextFieldView)
        
        stack.addArrangedSubview(selectStackView)
        stack.addArrangedSubview(selectStackCountry)
        stack.addArrangedSubview(moneyTextFieldStack)
        
        self.selectStackCountry.alpha = 0
        self.moneyTextFieldStack.alpha = 0
        selectStackCountry.isHidden = true
        moneyTextFieldStack.isHidden = true
        
//        uiviewLine.frame = CGRect(x: 0, y: 0, width: 10, height: 3)
        
        let lineView = UIView()
        lineView.translatesAutoresizingMaskIntoConstraints = false
        //        lineView.layer.borderWidth = 1.0
        lineView.layer.cornerRadius = 5
        lineView.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        //        lineView.layer.borderColor = UIColor.black.cgColor
        self.leftTextFieldView.addSubview(lineView)
        
        let rightLineView = UIView()
        rightLineView.translatesAutoresizingMaskIntoConstraints = false
        rightLineView.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        rightLineView.layer.cornerRadius = 5

        self.rightTextFieldView.addSubview(rightLineView)
        
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
            
            arrowHead.centerYAnchor.constraint(equalTo: leftView.centerYAnchor, constant: 0),
            arrowHead.trailingAnchor.constraint(equalTo: leftView.trailingAnchor, constant: -10),
            arrowHead.heightAnchor.constraint(equalToConstant: 10),
            arrowHead.widthAnchor.constraint(equalToConstant: 8),
            
//            arrowHead2.centerYAnchor.constraint(equalTo: rightView.centerYAnchor, constant: 0),
//            arrowHead2.trailingAnchor.constraint(equalTo: rightView.trailingAnchor, constant: -10),
//            arrowHead2.heightAnchor.constraint(equalToConstant: 10),
//            arrowHead2.widthAnchor.constraint(equalToConstant: 8),

            rightLabel.bottomAnchor.constraint(equalTo: rightView.centerYAnchor, constant: 0),
            rightLabel.centerXAnchor.constraint(equalTo: rightView.centerXAnchor, constant: 0),
            
            rightBelowLabel.topAnchor.constraint(equalTo: rightLabel.bottomAnchor, constant: 0),
            rightBelowLabel.centerXAnchor.constraint(equalTo: rightView.centerXAnchor, constant: 0),

            leftTextField.centerYAnchor.constraint(equalTo: leftTextFieldView.centerYAnchor, constant: 0),
            leftTextField.leadingAnchor.constraint(equalTo: leftTextFieldView.leadingAnchor, constant: 10),
            leftTextField.trailingAnchor.constraint(equalTo: leftTextFieldView.trailingAnchor, constant: -10),
            
            rightTextField.centerYAnchor.constraint(equalTo: rightTextFieldView.centerYAnchor, constant: 0),
            rightTextField.leadingAnchor.constraint(equalTo: rightTextFieldView.leadingAnchor, constant: 10),
            rightTextField.trailingAnchor.constraint(equalTo: rightTextFieldView.trailingAnchor, constant: -10),
            
            lineView.centerXAnchor.constraint(equalTo: leftTextFieldView.centerXAnchor),
            lineView.topAnchor.constraint(equalTo: leftTextField.bottomAnchor),
            lineView.widthAnchor.constraint(equalToConstant: 60),
            lineView.heightAnchor.constraint(equalToConstant: 3),
            
            rightLineView.centerXAnchor.constraint(equalTo: rightTextFieldView.centerXAnchor),
            rightLineView.topAnchor.constraint(equalTo: rightTextField.bottomAnchor),
            rightLineView.widthAnchor.constraint(equalToConstant: 60),
            rightLineView.heightAnchor.constraint(equalToConstant: 3)

            ])
        

    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        //        print(textField.text?.count)
//        print(textField.text)
        if textField.text?.count != 0 {
            if (textField.text?.contains("."))!{
                if let range = textField.text!.range(of: ".") {
                    let dotBefore = textField.text![..<range.lowerBound]
                    let dotAfter = textField.text![range.lowerBound...] // or str[str.startIndex..<range.lowerBound]
                    print(dotBefore)  // Prints ab
                    
                    let subtractionDot = dotBefore.replacingOccurrences(of: ",", with: "")
                    delegate?.calculatorKoreaMoney(textFieldDouble: Double(textField.text!) ?? 0)
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = NumberFormatter.Style.decimal
                    var formattedNumber = numberFormatter.string(from: NSNumber(value:(subtractionDot.toDouble())!))
                    
                    formattedNumber?.append(String(dotAfter))
                    textField.text = formattedNumber

                }
        }else{
                let subtractionDot = textField.text?.replacingOccurrences(of: ",", with: "")
                delegate?.calculatorKoreaMoney(textFieldDouble: Double(subtractionDot!) ?? 0)
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
                let formattedNumber = numberFormatter.string(from: NSNumber(value:Double(subtractionDot!)!))
                
                textField.text = formattedNumber
            }
        }
    }
    @objc func textFieldDidStart(_ textField: UITextField) {
//        print("start \(textField.text)")
        if textField.text == "0" {
            textField.text = ""
        }
    }
    
    let arrowHead : UIImageView = {
        let image = UIImageView(image: UIImage(named: "arrowHead"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let arrowHead2 : UIImageView = {
        let image = UIImageView(image: UIImage(named: "arrowHead"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

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
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let leftView : UIView = {
       let view = UIView()
//        view.layer.cornerRadius = 3
//        view.backgroundColor = #colorLiteral(red: 0.9349880424, green: 0.9349917763, blue: 0.9349917763, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let rightView : UIView = {
        let view = UIView()
//        view.layer.cornerRadius = 3
//        view.backgroundColor = #colorLiteral(red: 0.9349880424, green: 0.9349917763, blue: 0.9349917763, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let leftLabel : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.text = "대한민국-원"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = Defaull_style.mainTitleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let leftBelowLabel : UILabel = {
        let label = UILabel()
        label.text = "KRW"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = Defaull_style.mainTitleColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rightLabel : UILabel = {
        let label = UILabel()
        label.text = "대한민국-원"
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
        text.text = "0"
        text.minimumFontSize = 12
        text.adjustsFontSizeToFitWidth = true
        text.clearButtonMode = .whileEditing
//        text.backgroundColor = .blue
        text.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        text.textAlignment = .center
        text.keyboardType = .decimalPad
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    var rightTextField : UITextField = {
        let text = UITextField()
        text.text = "0"
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
    
    weak var delegate : exchangeDidTapInViewDelegate?

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
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        layout.itemSize = CGSize(width: 80, height: 50)
        
        
        catecoryCV = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), collectionViewLayout: layout)
        catecoryCV.register(exchangeCVCell2.self, forCellWithReuseIdentifier: "Cell")

        catecoryCV.layer.cornerRadius = CGFloat(Defaull_style.topTableViewCorner)
        catecoryCV.backgroundColor = Defaull_style.topTableView
        catecoryCV.delegate = self
        catecoryCV.dataSource = self
        catecoryCV.showsHorizontalScrollIndicator = true
        
        self.addSubview(catecoryCV)
        

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryListRealmDB.count
    }
//
//
    var selectedIndexPath: NSIndexPath?

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! exchangeCVCell2
        cell.dayLabel.text = categoryListRealmDB[indexPath.row].title
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)

        delegate?.collectionViewDidTapCell(subTitle: categoryListRealmDB[indexPath.row].title)
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }
//
    
}
class exchangeCVCell2 : UICollectionViewCell {
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.layer.borderWidth = 2
            }else{
                self.layer.borderWidth = 0
            }
        }
    }

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
        self.backgroundColor = Defaull_style.insideTableView
        self.layer.cornerRadius = CGFloat(Defaull_style.insideTableViewCorner)
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
