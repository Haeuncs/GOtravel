//
//  UIView+Extensions.swift
//  CenteredCollectionView
//
//  Created by Benjamin Emdon on 2017-01-11.
//

import UIKit

extension UIView {
	func applyGradient() {
		let gradient = CAGradientLayer()
		gradient.frame = bounds
		gradient.locations = [0, 1]
		gradient.startPoint = CGPoint(x: 0, y: 0)
		gradient.endPoint = CGPoint(x: 1, y: 1)
		gradient.colors = [
			UIColor.peach.cgColor,
			UIColor.orange.cgColor
		]
		layer.insertSublayer(gradient, at: 0)
	}
}
extension UIView {
    
    func setCardView(view : UIView){
        
        view.layer.cornerRadius = 5.0
//        view.layer.borderColor  =  UIColor.clear.cgColor
//        view.layer.borderWidth = 5.0
        view.layer.shadowOpacity = 0.2
        view.layer.shadowColor =  UIColor.lightGray.cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width:3, height: 3)
        view.layer.masksToBounds = true
        
    }
}
