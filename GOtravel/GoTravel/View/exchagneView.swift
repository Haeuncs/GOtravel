//
//  exchagneView.swift
//  GOtravel
//
//  Created by OOPSLA on 28/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

class exchangeView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(mainCV)
        
        NSLayoutConstraint.activate([
            mainCV.topAnchor.constraint(equalTo: self.topAnchor),
            mainCV.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            mainCV.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainCV.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    let mainCV : UICollectionView = {
        let table = UICollectionView()
        table.allowsMultipleSelection = false
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
}
