//
//  exchangeCell.swift
//  GOtravel
//
//  Created by OOPSLA on 01/02/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

class exchangeCVCell : UICollectionViewCell {
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
        self.addSubview(dayLabel)
        
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
//            dayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            dayLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            ])
    }

}
//class exchangeTVCell : UITableViewCell {
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.backgroundColor = .blue
//        contentView.addSubview(mainCV)
//
//        NSLayoutConstraint.activate([
//            mainCV.topAnchor.constraint(equalTo: contentView.topAnchor),
//            mainCV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            mainCV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            mainCV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
//            ])
//    }
//
//    let mainCV : UICollectionView = {
//        let table = UICollectionView()
//        table.allowsMultipleSelection = false
//        table.translatesAutoresizingMaskIntoConstraints = false
//        return table
//    }()
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = UICollectionViewCell()
//        cell.backgroundColor = .red
//        return cell
//    }
//
//
//}
