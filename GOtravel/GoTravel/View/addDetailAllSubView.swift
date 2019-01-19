//
//  addDetailView.swift
//  GOtravel
//
//  Created by OOPSLA on 18/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


class addDetailView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // titleView label 정의
    var countryLabel : UILabel = {
        let label = UILabel()
        label.text = "일본 여행 🗺"
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var subLabel : UILabel = {
        let label = UILabel()
        label.text = "오사카 교토"
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var dateLabel : UILabel = {
        let label = UILabel()
        label.text = "2019.02.10~2019.02.16 5박6일"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func initView() {
        
        addSubview(countryLabel)
        addSubview(subLabel)
        addSubview(dateLabel)
        // iphone 은 8 ipad 는 15
        let lableConstant = CGFloat(8)

        NSLayoutConstraint.activate([
            countryLabel.topAnchor.constraint(equalTo: topAnchor),
            countryLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant:lableConstant),
            countryLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            subLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor),
            subLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant:lableConstant),
            subLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: subLabel.bottomAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant:lableConstant),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            // data size에 맞추기 위한 앵커
            bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor,constant:lableConstant),

            ])
    }

}
class addDetailViewCellView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let dateLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "test"
        label.numberOfLines = 0
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 1
        label.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let dayOfTheWeek : UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "월요일"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    func initView(){
        
        addSubview(dateLabel)
        addSubview(dayOfTheWeek)

        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant:5),
            dateLabel.topAnchor.constraint(equalTo: topAnchor,constant:5),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant:-5),
            // 정사각형으로 만들기!
            dateLabel.heightAnchor.constraint(equalTo: widthAnchor, constant: -10),
            
            dayOfTheWeek.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayOfTheWeek.topAnchor.constraint(equalTo: dateLabel.bottomAnchor,constant:5),
            dayOfTheWeek.trailingAnchor.constraint(equalTo: trailingAnchor),
            

            ])
    }
}
class addDetailViewCellButtonView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let addBtn : UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "addBtn")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    var moneyBtn : UIButton = {
        let button = UIButton(type: .custom)
        button.alpha = 0.0
        let image = UIImage(named: "moneyBtn")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    let detailBtn : UIButton = {
        let button = UIButton(type: .custom)
        button.alpha = 0.0
        let image = UIImage(named: "detailBtn")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    let view : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    func initView(){
        
        addSubview(moneyBtn)
        addSubview(detailBtn)
        addSubview(addBtn)
        NSLayoutConstraint.activate([
            addBtn.topAnchor.constraint(equalTo: topAnchor,constant:5),
            addBtn.heightAnchor.constraint(equalToConstant: 35),
            addBtn.widthAnchor.constraint(equalToConstant: 35),
            addBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            moneyBtn.topAnchor.constraint(equalTo: topAnchor,constant:5),
            moneyBtn.heightAnchor.constraint(equalToConstant: 35),
            moneyBtn.widthAnchor.constraint(equalToConstant: 35),
            
            detailBtn.topAnchor.constraint(equalTo: topAnchor,constant:5),
            detailBtn.heightAnchor.constraint(equalToConstant: 35),
            detailBtn.widthAnchor.constraint(equalToConstant: 35),
            
            detailBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            moneyBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            ])
        
    }
    
}
