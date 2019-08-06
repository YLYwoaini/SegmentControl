//
//  PrefixHeader.swift
//  SegmentControl
//
//  Created by mac on 2019/7/31.
//  Copyright © 2019 YLY. All rights reserved.
//

import UIKit
import SnapKit

func isIPhoneXLater() -> Bool {
    var iPhoneXLater = false
    if #available(iOS 11.0, *) {
        let mainWindow = UIApplication.shared.delegate?.window
        if let area = mainWindow??.safeAreaInsets, area.bottom > 0.0 {
            iPhoneXLater = true
        }
    }
    return iPhoneXLater
}

let hasHomeButton = { () -> Bool in
    var iPhoneXLater = false
    if #available(iOS 11.0, *) {
        let mainWindow = UIApplication.shared.delegate?.window
        if let area = mainWindow??.safeAreaInsets, area.bottom > 0.0 {
            iPhoneXLater = true
        }
    }
    return iPhoneXLater
}()

let StatusBarHeight = CGFloat(hasHomeButton ? 44 : 20)
let NavigationBarHeight = StatusBarHeight + CGFloat(44)
let HomeIndicatorHeight = CGFloat(hasHomeButton ? 34 : 0)

