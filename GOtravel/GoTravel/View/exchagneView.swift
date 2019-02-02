//
//  exchagneView.swift
//  GOtravel
//
//  Created by OOPSLA on 28/01/2019.
//  Copyright © 2019 haeun. All rights reserved.
//

import Foundation
import UIKit

class exchangeView : UIView,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var screenSize         = UIScreen.main.bounds
    var mainCV     : UICollectionView!
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
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal

        mainCV = UICollectionView(frame: CGRect(x: 0, y: 5 , width: self.bounds.width , height: self.bounds.height / 10), collectionViewLayout: flowLayout)
        mainCV.register(exchangeCVCell.self, forCellWithReuseIdentifier: "exchangeCVCell")
        mainCV.backgroundColor = UIColor.clear
        mainCV.delegate = self
        mainCV.dataSource = self
        mainCV.showsHorizontalScrollIndicator = false
        self.addSubview(mainCV)
        self.addSubview(belowView)
        
        NSLayoutConstraint.activate([
            belowView.topAnchor.constraint(equalTo: mainCV.bottomAnchor, constant: 5),
            belowView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            belowView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            belowView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            ])
    }
    let belowView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exchangeCVCell", for: indexPath) as! exchangeCVCell
        cell.dayLabel.text = "\(indexPath.row) 일"
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.red.cgColor
        cell.layer.cornerRadius = 5

//        cell.backgroundColor = .red
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: collectionView.frame.width / 5, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        belowView.backgroundColor = HSBrandomColor()
    }
    func HSBrandomColor() -> UIColor{
        let saturation : CGFloat =  0.45
        let brigtness : CGFloat = 0.85
        let randomHue = CGFloat.random(in: 0.0..<1.0)
        //        print(UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1))
        return UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1)
    }

}
