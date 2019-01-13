//
//  WeekdaysView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

class WeekdaysView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        
        setupViews()
    }
    
    func setupViews() {
        addSubview(myStackView)
        myStackView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        myStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        myStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        myStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
        
        var daysArr = ["일", "월", "화", "수", "목", "금", "토"]
        for i in 0..<7 {
            let lbl=UILabel()
            lbl.font=UIFont.systemFont(ofSize: 12)
            lbl.text=daysArr[i]
            lbl.textAlignment = .center
            if i == 0{
                lbl.textColor = UIColor.red
            }else if i == 6{
                lbl.textColor = UIColor.blue
            }else{
                lbl.textColor = Style.weekdaysLblColor
            }
            myStackView.addArrangedSubview(lbl)
        }
    }
    
    let myStackView: UIStackView = {
        let stackView=UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints=false
        return stackView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
