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
  
  @nonobjc class var blackText: UIColor {
    return UIColor(white: 15.0 / 255.0, alpha: 1.0)
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
  
}


extension UIColor {
  @nonobjc class var butterscotch: UIColor {
    return UIColor(red: 249.0 / 255.0, green: 186.0 / 255.0, blue: 72.0 / 255.0, alpha: 1.0)
  }
  @nonobjc class var black: UIColor {
    return #colorLiteral(red: 0.07843137255, green: 0.07843137255, blue: 0.07843137255, alpha: 1)
  }
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
    func toString() -> String {
        let colorRef = self.cgColor
        return CIColor(cgColor: colorRef).stringRepresentation
    }

}
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    func characterToCgfloat() -> CGFloat {
        let n = NumberFormatter().number(from: self)
        return n as! CGFloat
    }
    func addDotInNumber() -> String{
        if self.count != 0 {
            let subtractionDot = self.replacingOccurrences(of: ",", with: "")

            if (subtractionDot.contains(".")){
                if let range = subtractionDot.range(of: ".") {
                    let dotBefore = subtractionDot[..<range.lowerBound]
                    let dotAfter = subtractionDot[range.lowerBound...] // or str[str.startIndex..<range.lowerBound]
                    print(dotBefore)  // Prints ab
                    
                    let subtractionDot = dotBefore.replacingOccurrences(of: ",", with: "")
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = NumberFormatter.Style.decimal
                    var formattedNumber = numberFormatter.string(from: NSNumber(value:(subtractionDot.toDouble())!))
                    
                    formattedNumber?.append(String(dotAfter))
                    return formattedNumber ?? ""
                    
                }
            }else{
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
                let formattedNumber = numberFormatter.string(from: NSNumber(value:(subtractionDot.toDouble())!))
                
                return formattedNumber ?? ""
            }
        }
        return ""
    }

}

extension Int {
  func toNumber() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    return numberFormatter.string(from: NSNumber(value: self)) ?? "0"
  }
}
extension Double {
  func toNumber() -> String {
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    return numberFormatter.string(from: NSNumber(value: self)) ?? "0"
  }
}
extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
//        self.separatorStyle = .singleLine
    }
}
extension UILabel {
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    public var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            self.drawText(in: rect.inset(by: insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
//    override open var intrinsicContentSize: CGSize {
//        guard let text = self.text else { return super.intrinsicContentSize }
//        
//        var contentSize = super.intrinsicContentSize
//        var textWidth: CGFloat = frame.size.width
//        var insetsHeight: CGFloat = 0.0
//        var insetsWidth: CGFloat = 0.0
//        
//        if let insets = padding {
//            insetsWidth += insets.left + insets.right
//            insetsHeight += insets.top + insets.bottom
//            textWidth -= insetsWidth
//        }
//        
//        let newSize = text.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
//                                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
//                                        attributes: [NSAttributedString.Key.font: self.font], context: nil)
//        
//        contentSize.height = ceil(newSize.size.height) + insetsHeight
//        contentSize.width = ceil(newSize.size.width) + insetsWidth
//        
//        return contentSize
//    }
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
