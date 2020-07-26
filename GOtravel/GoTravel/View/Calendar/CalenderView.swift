//
//  CalenderView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit


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

class CalenderView: UIView, MonthViewDelegate {

    var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)

    var firstSelectCount = 0
    var didSelectCount = 0
    var firstDate: Date?
    var secondData: Date?
    var dateRange = [Date]()
    var selectCount = 0

    let sectionInsets = UIEdgeInsets(top: 5.0, left: 1.0, bottom: 5.0, right: 5.0)
    var calcWidth = 0
    var itemNum = 0

    let addBtn: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.cornerRadius = 5
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
        let v = MonthView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let weekdaysView: WeekdaysView = {
        let v = WeekdaysView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        //        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        let myCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints = false
        myCollectionView.backgroundColor = UIColor.clear
        myCollectionView.allowsMultipleSelection = false
        return myCollectionView
    }()

    let ddayLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .tealish
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
        search(year: currentYear, month: currentMonthIndex)
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

    func search(year: Int,month: Int){
        var dateCombine = ""
        dateCombine = "\(year)-\(month)-01"
        print(dateCombine)
        let date = Date.parse(dateCombine)

    }

    func search(year: Int,month: Int,day: Int) -> [UILabel]{
        var dateBelowLabel: [UILabel] = []

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
        firstWeekDayOfMonth = getFirstWeekDay()

        //for leap years, make february month of 29 days
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex - 1] = 29
        }
        //end

        presentMonthIndex = currentMonthIndex
        presentYear = currentYear

        setupViews()

        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(DateCell.self, forCellWithReuseIdentifier: "Cell")

    }

    func setupViews() {
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        monthView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        monthView.heightAnchor.constraint(equalToConstant: 58).isActive = true
        monthView.delegate = self

        addSubview(ddayLabel)
        ddayLabel.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive = true
        ddayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        monthView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true

        addSubview(weekdaysView)
        weekdaysView.topAnchor.constraint(equalTo: ddayLabel.bottomAnchor).isActive = true
        weekdaysView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        weekdaysView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        weekdaysView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: weekdaysView.bottomAnchor, constant: 0).isActive = true
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

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

    @objc func buttonClicked(sender: UIButton){
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalenderView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {

        let day = indexPath.row - (firstWeekDayOfMonth - 2)
        let dateCombine = "\(currentYear)-\(currentMonthIndex)-\(day)"
        let currentSelectedDate = Date.parse(dateCombine)

        guard let currentFirstSelectedDate = firstDate else {
            firstDate = currentSelectedDate
            dateRange.append(currentSelectedDate)
            collectionView.reloadData()
            addBtn.isHidden = true
            return
        }

        guard secondData != nil else {
            secondData = currentSelectedDate
            // 만약 첫번째 터치가 두번째 터치보다 크다면 SWAP
            if currentFirstSelectedDate > currentSelectedDate {
                let temp = secondData
                secondData = firstDate
                firstDate = temp
            }
            dateRange.append(currentSelectedDate)

            guard (firstDate != nil) && (secondData != nil) else {
                return
            }

            // swiftlint:disable force_unwrapping
            // for cell day Selected
            var addDate = Calendar.current.date(byAdding: .day, value: 1, to: firstDate!)
            while addDate! < secondData! {
                dateRange.append(addDate!)
                addDate = Calendar.current.date(byAdding: .day, value: 1, to: addDate!)!
            }

            dateRange = dateRange.sorted(by: { $0 < $1 })

            let travelDays = secondData!.interval(ofComponent: .day, fromDate: firstDate!)

            let (type, day) = firstDate!.startDayDDay()

            let ddayStr: String
            switch type {
            case .traveling, .past:
                ddayStr = "D+" + String(day)
            case .future:
                ddayStr = "D-" + String(day)
            }
            
            DispatchQueue.main.async {
                self.ddayLabel.text = "\(travelDays)박 \(travelDays + 1)일, \(ddayStr)"
                self.addBtn.isHidden = false
            }
            collectionView.reloadData()
            return
        }
        // swiftlint:enable force_unwrapping

        // Remove All Selected Day And New Selected
        dateRange.removeAll()

        DispatchQueue.main.async {
            self.ddayLabel.text = " "
            self.addBtn.isHidden = true
        }

        firstDate = currentSelectedDate
        secondData = nil
        dateRange.append(currentSelectedDate)
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * 7
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / 7
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension CalenderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemNum = numOfDaysInMonth[currentMonthIndex - 1] + firstWeekDayOfMonth - 1
        print(itemNum)
        return itemNum
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell",
            for: indexPath) as? DateCell else {
                return UICollectionViewCell()
        }

        guard indexPath.item > firstWeekDayOfMonth - 2 else {
            cell.isHidden = true
            return cell
        }
        cell.isHidden = false

        var dateCombine = ""
        let calcDate = indexPath.row - firstWeekDayOfMonth + 2
        dateCombine = "\(currentYear)-\(currentMonthIndex)-\(calcDate)"

        let date = Date.parse(dateCombine)
        let today = Date()
        if today > date{
            cell.unabledDay()
        }
        else {
            cell.enabledDay()
        }
        cell.dayLabel.text = "\(calcDate)"

        if date.isInSameYear(date: today) &&
            date.isInSameMonth(date: today) &&
            date.isInSameDay(date: today) {
            cell.today()
        }

        if (dateRange.contains(date)) {
            for i in dateRange {
                print(i.localDateString())
            }
            let isFirstOrLastDay = (date == dateRange.first || date == dateRange.last)
            cell.selectedDay(isMiddle: isFirstOrLastDay)
        }
        return cell
    }

    func getFirstWeekDay() -> Int {
        let day = ("\(currentYear)-\(currentMonthIndex)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }

    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex = monthIndex + 1
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

        firstWeekDayOfMonth = getFirstWeekDay()

        myCollectionView.reloadData()

        //        monthView.btnLeft.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)
    }
}
