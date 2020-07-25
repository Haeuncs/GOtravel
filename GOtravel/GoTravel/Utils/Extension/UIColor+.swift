//
//  UIColor+Extensions.swift
//  CenteredCollectionView
//
//  Created by Benjamin Emdon on 2017-01-11.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

extension UIColor {
    @nonobjc class var dim: UIColor {
        return UIColor(red: 4.0 / 255.0, green: 4.0 / 255.0, blue: 15.0 / 255.0, alpha: 0.4)
    }

    @nonobjc class var white: UIColor {
        return UIColor(white: 1.0, alpha: 1.0)
    }

    @nonobjc class var whiteText: UIColor {
        return UIColor(white: 250.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var grey01: UIColor {
        return UIColor(white: 242.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var grey02: UIColor {
        return UIColor(white: 239.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var grey03: UIColor {
        return UIColor(white: 219.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var grey04: UIColor {
        return UIColor(white: 183.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var grey05: UIColor {
        return UIColor(white: 112.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var fitcoOrange: UIColor {
        return UIColor(red: 241.0 / 255.0, green: 90.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var like: UIColor {
        return UIColor(red: 1.0, green: 100.0 / 255.0, blue: 92.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var delete: UIColor {
        return UIColor(red: 250.0 / 255.0, green: 39.0 / 255.0, blue: 27.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var favorite: UIColor {
        return UIColor(red: 1.0, green: 216.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var tealish: UIColor {
        return UIColor(red: 48.0 / 255.0, green: 180.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var greyishTeal: UIColor {
        return UIColor(red: 77.0 / 255.0, green: 182.0 / 255.0, blue: 172.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var blush: UIColor {
        return UIColor(red: 230.0 / 255.0, green: 154.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var lightPeriwinkle: UIColor {
        return UIColor(red: 192.0 / 255.0, green: 186.0 / 255.0, blue: 1.0, alpha: 1.0)
    }

    @nonobjc class var greyishBrown: UIColor {
        return UIColor(white: 69.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var veryLightPink: UIColor {
        return UIColor(white: 204.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var whiteTwo: UIColor {
        return UIColor(white: 245.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var brownGrey: UIColor {
        return UIColor(white: 158.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var black: UIColor {
        return UIColor(white: 33.0 / 255.0, alpha: 1.0)
    }

    @nonobjc class var turquoiseBlue: UIColor {
        return UIColor(red: 0.0, green: 188.0 / 255.0, blue: 212.0 / 255.0, alpha: 1.0)
    }

}

extension UIColor {
    @nonobjc class var butterscotch: UIColor {
        return UIColor(red: 249.0 / 255.0, green: 186.0 / 255.0, blue: 72.0 / 255.0, alpha: 1.0)
    }
    //  @nonobjc class var black: UIColor {
    //    return #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
    //  }
    static var peach: UIColor {
        return  UIColor(red: 1, green: 0.5764705882, blue: 0.5843137255, alpha: 1)
    }

    static var orange: UIColor {
        return UIColor(red: 1, green: 0.5764705882, blue: 0.462745098, alpha: 1)
    }
    static var myRed: UIColor{
        return #colorLiteral(red: 0.8544613487, green: 0.4680916344, blue: 0.4745311296, alpha: 1)
    }
    static var myBlue: UIColor{
        return #colorLiteral(red: 0.4680916344, green: 0.6239366865, blue: 0.8544613487, alpha: 1)
    }
    static var myGreen: UIColor {
        return #colorLiteral(red: 0.6286184273, green: 0.8544613487, blue: 0.4680916344, alpha: 1)
    }
    func toString() -> String {
        let colorRef = self.cgColor
        return CIColor(cgColor: colorRef).stringRepresentation
    }

    func stringToColor(
        red: String,
        green: String,
        blue: String,
        alpha: String
    ) -> UIColor {
        return UIColor.init(
            red: red.toCGFloat(),
            green: green.toCGFloat(),
            blue: blue.toCGFloat(),
            alpha: alpha.toCGFloat()
        )
    }
}

extension UIColor {
    
    class func color(data:Data) -> UIColor? {
         return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
    }

    func encode() -> Data? {
         return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
    }

    func HSBrandomColor() -> UIColor{
        let saturation: CGFloat = 0.45
        let brigtness: CGFloat = 0.85
        let randomHue = CGFloat.random(in: 0.0..<1.0)
        return UIColor(hue: CGFloat(randomHue), saturation: saturation, brightness: brigtness, alpha: 1)
    }
}

extension UIColor {
    func darker() -> UIColor {

        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0

        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
        }

        return UIColor()
    }

    func lighter() -> UIColor {

        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0

        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: min(r + 0.2, 1.0), green: min(g + 0.2, 1.0), blue: min(b + 0.2, 1.0), alpha: a)
        }

        return UIColor()
    }
}

