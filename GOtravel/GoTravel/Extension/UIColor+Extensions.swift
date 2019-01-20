//
//  UIColor+Extensions.swift
//  CenteredCollectionView
//
//  Created by Benjamin Emdon on 2017-01-11.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

extension UIColor {
	static var peach: UIColor {
		return  UIColor(red: 1, green: 0.5764705882, blue: 0.5843137255, alpha: 1)
	}

	static var orange: UIColor {
		return UIColor(red: 1, green: 0.5764705882, blue: 0.462745098, alpha: 1)
	}
    static var myRed : UIColor{
        return #colorLiteral(red: 0.8544613487, green: 0.4680916344, blue: 0.4745311296, alpha: 1)
    }
    static var myBlue : UIColor{
        return #colorLiteral(red: 0.4680916344, green: 0.6239366865, blue: 0.8544613487, alpha: 1)
    }
    static var myGreen : UIColor {
        return #colorLiteral(red: 0.6286184273, green: 0.8544613487, blue: 0.4680916344, alpha: 1)
    }
    // hsb random color
    func HSBrandomColor() -> UIColor{
        let saturation : CGFloat =  0.45
        let brigtness : CGFloat = 0.85
        let randomHue = CGFloat.random(in: 0.0..<1.0)
        //        print(UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1))
        return UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1)
    }
}
