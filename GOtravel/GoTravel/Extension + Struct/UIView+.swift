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
//extension UIView {
//    
//    func setCardView(view : UIView){
//        
//        view.layer.cornerRadius = 5.0
////        view.layer.borderColor  =  UIColor.clear.cgColor
////        view.layer.borderWidth = 5.0
//        view.layer.shadowOpacity = 0.2
//        view.layer.shadowColor =  UIColor.lightGray.cgColor
//        view.layer.shadowRadius = 5.0
//        view.layer.shadowOffset = CGSize(width:3, height: 3)
//        view.layer.masksToBounds = true
//        
//    }
//}
extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}
extension UIView {
    
    func setCardView(view : UIView){
        
        view.layer.cornerRadius = 5.0
        view.layer.borderColor  =  UIColor.clear.cgColor
        view.layer.borderWidth = 5.0
        view.layer.shadowOpacity = 0.5
        view.layer.shadowColor =  UIColor.lightGray.cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width:5, height: 5)
        view.layer.masksToBounds = true
        
    }
}
