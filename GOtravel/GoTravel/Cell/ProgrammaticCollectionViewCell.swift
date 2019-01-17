//
//  ProgrammaticCollectionViewCell.swift
//  Example
//
//  Created by Benjamin Emdon on 2016-12-28.
//  Copyright © 2016 Benjamin Emdon.
//

import UIKit

class ProgrammaticCollectionViewCell: UICollectionViewCell {
    
    let countryLabel = UILabel()
    let cityLabel = UILabel()
    let ddayLabel = UILabel()
    
    let mainStackView = UIStackView()
    let subStackView = UIStackView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    func initView(){
        
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        mainStackView.distribution = .fillEqually
        mainStackView.alignment = .fill
        mainStackView.axis = .vertical
        
        subStackView.distribution = .fillEqually
        subStackView.alignment = .fill
        subStackView.axis = .vertical
        
        countryLabel.textAlignment = .left
        countryLabel.text = "일본 여행"
        countryLabel.textColor = .white
//        countryLabel.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        
        cityLabel.textAlignment = .left
        cityLabel.text = "오사카"
        cityLabel.textColor = .white
//        cityLabel.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        
        ddayLabel.textAlignment = .right
        ddayLabel.text = "D-100"
        ddayLabel.textColor = .white
//        ddayLabel.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        ddayLabel.adjustsFontSizeToFitWidth = true
        ddayLabel.numberOfLines = 1
        ddayLabel.minimumScaleFactor = 0.1
        ddayLabel.font = UIFont.systemFont(ofSize: 160, weight: .bold)
        ddayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        ddayLabel.font = ddayLabel.font.withSize (50)
        
        cityLabel.adjustsFontSizeToFitWidth = true
        cityLabel.numberOfLines = 1
        cityLabel.minimumScaleFactor = 0.1
        cityLabel.font = UIFont.systemFont(ofSize: 160, weight: .bold)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cityLabel.font = ddayLabel.font.withSize (25)

        countryLabel.adjustsFontSizeToFitWidth = true
        countryLabel.numberOfLines = 1
        countryLabel.minimumScaleFactor = 0.1
        countryLabel.font = UIFont.systemFont(ofSize: 160, weight: .bold)
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        countryLabel.font = ddayLabel.font.withSize (30)
        


        contentView.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(subStackView)
        mainStackView.addArrangedSubview(ddayLabel)
        
        subStackView.addArrangedSubview(countryLabel)
        subStackView.addArrangedSubview(cityLabel)
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        //                subStackView.translatesAutoresizingMaskIntoConstraints = false
        //                countryLabel.translatesAutoresizingMaskIntoConstraints = false
        //                cityLabel.translatesAutoresizingMaskIntoConstraints = false
        //                ddayLabel.translatesAutoresizingMaskIntoConstraints = false
        //
        //        mainStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //        countryLabel.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        //        cityLabel.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        //        ddayLabel.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant:10),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            ])

    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
}
