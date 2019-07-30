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
    // cell click delegate
    weak var delegate : exchangeCVCDelegate?

    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                self.layer.borderWidth = 2
                delegate?.exchangeCVCDelegateDidTap(self)
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
        self.addSubview(dayLabel)
        
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }

}
