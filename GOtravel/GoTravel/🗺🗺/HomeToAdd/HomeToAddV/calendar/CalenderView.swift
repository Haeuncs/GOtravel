//
//  CalenderView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit
import RealmSwift

struct Colors {
    static var darkGray = #colorLiteral(red: 0.3764705882, green: 0.3647058824, blue: 0.3647058824, alpha: 1)
    static var darkRed = #colorLiteral(red: 0.5019607843, green: 0.1529411765, blue: 0.1764705882, alpha: 1)
}

struct Style {
    static var bgColor = UIColor.white
    static var monthViewLblColor = UIColor.black
    static var monthViewBtnRightColor = UIColor.black
    static var monthViewBtnLeftColor = UIColor.black
    static var activeCellLblColor = UIColor.black
    static var activeCellLblColorHighlighted = UIColor.white
    static var weekdaysLblColor = UIColor.black
    
    static func themeDark(){
        bgColor = Colors.darkGray
        monthViewLblColor = UIColor.white
        monthViewBtnRightColor = UIColor.white
        monthViewBtnLeftColor = UIColor.white
        activeCellLblColor = UIColor.white
        activeCellLblColorHighlighted = UIColor.black
        weekdaysLblColor = UIColor.white
    }
    
    static func themeLight(){
        bgColor = UIColor.white
        monthViewLblColor = UIColor.black
        monthViewBtnRightColor = UIColor.black
        monthViewBtnLeftColor = UIColor.black
        activeCellLblColor = UIColor.black
        activeCellLblColorHighlighted = UIColor.white
        weekdaysLblColor = UIColor.black
    }
}

class CalenderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate {
    
    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        search(year: currentYear, month: currentMonthIndex)
        let height = myCollectionView.collectionViewLayout.collectionViewContentSize.height
        print(height)
    }
    
    convenience init(theme: MyTheme) {
        self.init()
        Style.themeLight()

//        if theme == .dark {
//            Style.themeDark()
//        } else {
//            Style.themeLight()
//        }
//
        initializeView()
    }
    
    func search(year:Int,month:Int){
        var dateCombine = ""
        dateCombine = "\(year)-\(month)-01"
        print(dateCombine)
        let date = Date.parse(dateCombine)
        
    }
    func search(year:Int,month:Int,day:Int) -> [UILabel]{
        var dateBelowLabel:[UILabel] = []
        
        
        let dateCombine = "\(year)-\(month)-\(day)"
        print(dateCombine)
        let date = Date.parse(dateCombine)
        return dateBelowLabel
    }
    func changeTheme() {
        myCollectionView.reloadData()
        
        monthView.lblName.textColor = Style.monthViewLblColor
        monthView.btnRight.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        monthView.btnLeft.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        
        for i in 0..<7 {
            (weekdaysView.myStackView.subviews[i] as! UILabel).textColor = Style.weekdaysLblColor
        }
    }
    
    func initializeView() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth=getFirstWeekDay()
        
        //for leap years, make february month of 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex-1] = 29
        }
        //end
        
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        
        setupViews()
        
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemNum = numOfDaysInMonth[currentMonthIndex-1] + firstWeekDayOfMonth - 1
        print(itemNum)
        return itemNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell
        cell.backgroundColor=UIColor.clear
        cell.layer.borderColor = UIColor.clear.cgColor
        
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden=true
        } else {
            var dateCombine = ""
            let calcDate = indexPath.row-firstWeekDayOfMonth+2

            dateCombine = "\(currentYear)-\(currentMonthIndex)-\(calcDate)"
            let date = Date.parse(dateCombine)
            let today = Date()
            if today > date{
                cell.isUserInteractionEnabled=false
                cell.lbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                
            }else{
                cell.isUserInteractionEnabled=true
                cell.lbl.textColor = Style.activeCellLblColor
            }
            cell.isHidden=false
            cell.lbl.text="\(calcDate)"
            
            if date.isInSameYear(date: today) && date.isInSameMonth(date: today) && date.isInSameDay(date: today) {
                cell.lbl.textColor = .red
                cell.isUserInteractionEnabled=true
            }
            
            if (dateRange.contains(date)){
                cell.lbl.textColor = .white
                if date == dateRange.first || date == dateRange.last{
                    print(dateRange)
                    cell.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                }
                else{
                    cell.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
                    
                    
                }
            }

            //아래 코드가 없으면 재사용 셀이기 때문에 데이터가 겹쳐서 호출 될 수도 있음!
            for sub in cell.lbl.subviews{
                sub.removeFromSuperview()
            }
        }
        return cell
    }
    var firstSelectCount = 0
    var didSelectCount = 0
//    var presentMonthIndex = 0
//    var presentYear = 0

    var firstDate : Date?
    var secondData : Date?
    var dateRange = [Date]()
    var selectCount = 0
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell=collectionView.cellForItem(at: indexPath)
        let cell2=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! dateCVCell

        let day = indexPath.row-(firstWeekDayOfMonth - 2)
        var dateCombine = ""
        dateCombine = "\(currentYear)-\(currentMonthIndex)-\(day)"
        var date = Date.parse(dateCombine)
//        date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        // Formatter for printing the date, adjust it according to your needs:
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy/MM/dd"
        // Date Range calc!
        if firstDate == nil{
            firstDate = date
            dateRange.append(firstDate!)
            myCollectionView.reloadData()
        }else if firstDate != nil && secondData == nil{
            secondData = date
            if firstDate == secondData{
                dateRange.removeAll()
                myCollectionView.reloadData()
            }else{
                // 만약 첫번째 터치가 두번째 터치보다 크다면 SWAP
                if firstDate! > secondData!{
                    let temp = secondData
                    secondData = firstDate
                    firstDate = temp
//                    firstDate = Calendar.current.date(byAdding: .day, value: -1, to: temp!)
                }
                dateRange.append(date)
                var addDate = Calendar.current.date(byAdding: .day, value: 1, to: firstDate!)
//                print(addDate)
                while addDate! < secondData! {
                    dateRange.append(addDate!)
                    addDate = Calendar.current.date(byAdding: .day, value: 1, to: addDate!)!
                }
                dateRange = dateRange.sorted(by: {$0 < $1})
//                print(dateRange)
                // 몇 일 남았는지 계산
                let interval = dateRange.last!.timeIntervalSince(dateRange.first!)
                let days = Int(interval / 86400)
//                // D-day 계산
//                let inervalToday = dateRange.first!.timeIntervalSince(Date())
//                let dday = Int(inervalToday / 86400)
              
              let dday = (dateRange.first!.interval(ofComponent: .day, fromDate: Date()) + 1)

                DispatchQueue.main.async {
                    self.ddayLabel.text = "\(days)박 \(days+1)일, D-\(dday)"
                    self.addBtn.isHidden = false
                    ddayDB = dday + 1
                    nightDB = days + 1
                    dayDate = self.dateRange.first!
                }
                myCollectionView.reloadData()
            }
        }else if firstDate != nil && secondData != nil{
            print("다지움 & first")
            dateRange.removeAll()
            DispatchQueue.main.async {
                self.ddayLabel.text = ""
            }

            firstDate = date
            dateRange.append(firstDate!)
            secondData = nil
            myCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("didclick")
        didSelectCount = 1
        let cell=collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.clear.cgColor
//        cell?.backgroundColor=UIColor.clear
//        let lbl = cell?.subviews[1] as! UILabel
//        lbl.textColor = Style.activeCellLblColor
//        let stack = cell?.subviews[2] as! UIStackView
//        let test = stack.subviews[0] as! UILabel
//        test.textColor = UIColor.darkGray

    }
    let sectionInsets = UIEdgeInsets(top: 5.0, left: 1.0, bottom: 5.0, right: 5.0)
    var calcWidth = 0
    var itemNum = 0
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = CGFloat(Int(collectionView.frame.width/7))
        let paddingSpace = sectionInsets.left * 7
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / 7
        let height: CGFloat = 80
        return CGSize(width: widthPerItem, height: widthPerItem)
        
//        let paddingSpace = sectionInsets.left * 7
//        let availableWidth = collectionView.frame.width - paddingSpace
//        let widthPerItem = availableWidth / 7
//        let heightPerItem = widthPerItem + 21
//
//        return CGSize(width: widthPerItem, height: widthPerItem)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex=monthIndex+1
        currentYear = year
        
        //for leap year, make february month of 29 days
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        //end
        
        firstWeekDayOfMonth=getFirstWeekDay()
        
        myCollectionView.reloadData()
        
//        monthView.btnLeft.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)
    }
    
    func setupViews() {
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive=true
        monthView.delegate=self
        
        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive=true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 0).isActive=true
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive=true
        myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
        addSubview(ddayLabel)
        ddayLabel.bottomAnchor.constraint(equalTo: monthView.topAnchor).isActive=true
        //        ddayLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant:-5).isActive = true
        ddayLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//
//        addSubview(addBtn)
//        addBtn.topAnchor.constraint(equalTo: myCollectionView.bottomAnchor,constant: 20).isActive=true
//        //        ddayLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant:-5).isActive = true
//        addBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        addBtn.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive=true
//        addBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive=true
//        addBtn.heightAnchor.constraint(equalToConstant: 50).isActive=true
//
        }
    @objc func buttonAction(sender: UIButton!) {
        let btnsendtag: UIButton = sender
        print("select")
        if btnsendtag.tag == 0 {
            let sb: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let uvc = sb.instantiateViewController(withIdentifier: "mainViewController")
            let nav = UINavigationController(rootViewController: uvc)

            nav.popToRootViewController(animated: true)
        }
    }
    @objc func buttonClicked(sender : UIButton){
        print("??SFLnkdshfhdslj")
//        let alert = UIAlertController(title: "Clicked", message: "You have clicked on the button", preferredStyle: .alert)
//
//        present(alert, animated: true, completion: nil)
    }

    let addBtn : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints=false
        b.layer.cornerRadius = 5
//        b.puls()
        b.backgroundColor = #colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)
        b.isHidden = true
        b.setTitle("일정 추가하기", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.tag = 0
        b.isSelected = true
        b.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return b
    }()
    let monthView: MonthView = {
        let v=MonthView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let weekdaysView: WeekdaysView = {
        let v=WeekdaysView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let myCollectionView=UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.clear
        myCollectionView.allowsMultipleSelection=false
        return myCollectionView
    }()
    let ddayLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class dateCVCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.clear
        layer.cornerRadius = 5
        layer.masksToBounds=true
        
        setupViews()
    }
//    let stack = UIStackView()
    let selectDateRange = UIView()
    func setupViews() {
        addSubview(lbl)
//        addSubview(selectDateRange)
//        lbl.wi.constraint(equalTo: widthAnchor).isActive=true
//        lbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
//        lbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        lbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        //            stackView.topAnchor.constraint(equalTo: self.subView.topAnchor, constant: 10)
        lbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

//        selectDateRange.topAnchor.constraint(equalTo: lbl.bottomAnchor, constant: 5).isActive = true
//        selectDateRange.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
//        selectDateRange.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
//        selectDateRange.bottomAnchor.constraint(equalTo: bottomAnchor,constant : 10).isActive = true
//        selectDateRange.translatesAutoresizingMaskIntoConstraints = false

//        lbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    let lbl: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 16)
        label.textColor=Colors.darkGray
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    let titleLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 12)
        label.textColor=Colors.darkGray
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}







extension UIButton {
    func puls(){
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.95
        pulse.fromValue = 0.97
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = Float.infinity
        
//        pulse.initialVelocity = 0.9
//        pulse.damping = 1.0
        layer.add(pulse,forKey:nil)

    }
}






