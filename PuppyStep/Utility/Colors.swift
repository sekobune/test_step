//
//  Colors.swift
//  PuppyStep
//
//  Created by Sergey on 9/26/20.
//
// I use this module instead of SwiftGen for this small project
//

import Foundation
import UIKit

let clearColor: UIColor = .clear

extension UIColor {
    class func mainFirst() -> UIColor {
        return UIColor(named: "mainFirst") ?? clearColor
    }
    class func mainSecond() -> UIColor {
        return UIColor(named: "mainSecond") ?? clearColor
    }
    class func secondary() -> UIColor {
        return UIColor(named: "secondary") ?? clearColor
    }
    class func secondaryPressed() -> UIColor {
        return UIColor(named: "secondaryPressed") ?? clearColor
    }
    class func blackWhite() -> UIColor {
        return UIColor(named: "blackWhite") ?? clearColor
    }
}
