//
//  UIViewExtension.swift
//  SegmentControl
//
//  Created by mac on 2019/8/2.
//  Copyright © 2019 YLY. All rights reserved.
//

import UIKit //为什么还需要导入UIKit

extension UIView {
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    
    public var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    
    public var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var r = self.frame
            r.origin.x = newValue - r.size.width
            self.frame = r
        }
    }
    
    public var top: CGFloat{
        get {
            return self.frame.origin.y
        }
        set {
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    
    public var bottom: CGFloat{
        get {
            return self.frame.origin.y+self.frame.size.height
        }
        set {
            var r = self.frame
            r.origin.y = newValue - self.frame.size.height
            self.frame = r
        }
    }
    
    public var width: CGFloat{
        get {
            return self.frame.size.width
        }
        set {
            var r = self.frame
            r.size.width = newValue
            self.frame = r
        }
    }
    
    public var height: CGFloat{
        get {
            return self.frame.size.height
        }
        set {
            var r = self.frame
            r.size.height = newValue
            self.frame = r
        }
    }
    
    public func removeAllSubviews()  {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}
