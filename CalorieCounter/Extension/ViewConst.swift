//
//  ViewConst.swift
//  CalorieCounter
//
//  Created by Thanh Hien on 20/4/24.
//

import Foundation
import UIKit

extension UIScreen {
    static var height = UIScreen.main.bounds.height
    static var width = UIScreen.main.bounds.width
}

struct Vconst {
    static let DESIGN_DEVICE_FRAMESIZE: CGSize = CGSize(width: 375, height: 821)
    static let DESIGN_HEIGHT_RATIO: CGFloat = UIScreen.height / DESIGN_DEVICE_FRAMESIZE.height
    static let DESIGN_WIDTH_RATIO: CGFloat = UIScreen.width / DESIGN_DEVICE_FRAMESIZE.width
}
