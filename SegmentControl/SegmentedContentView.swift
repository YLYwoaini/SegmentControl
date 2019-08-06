//
//  SegmentedContentView.swift
//  SegmentControl
//
//  Created by mac on 2019/7/31.
//  Copyright © 2019 YLY. All rights reserved.
//

import UIKit

@objc protocol SegmentedContentViewDelegate {
    @objc optional func contentViewDidEndChangeIndex(contentView: SegmentedContentView)
    @objc optional func contentViewDidScroll(scrollView: UIScrollView, isLeft: Bool)
    @objc optional func contentViewWillBeginDragging(contentView: SegmentedContentView)
}

class SegmentedContentView: UIView, UIScrollViewDelegate {
    weak var delegate: SegmentedContentViewDelegate?
    let scrollView: UIScrollView
    var currentIndex = 0
    var isAnimation = false
    var totalCount = 0
    var isPageMove = false
    var lastContentOffsetX: CGFloat = 0
    var firstContentOffsetX: CGFloat = 0
    
    
    override init(frame: CGRect) {
        scrollView = UIScrollView()
        super.init(frame: frame)
        
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.totalCount = 7
        scrollView.contentSize = CGSize(width: frame.width * CGFloat(self.totalCount), height: frame.height)
        for index in 0 ..< self.totalCount {
            let view = UIView()
            view.frame = CGRect(x: CGFloat(index) * frame.width, y: 0, width: frame.width, height: frame.height)
            view.backgroundColor = UIColor.randomColor()
            scrollView.addSubview(view)
        }
    }
    
    func moveToIndex(index: Int, animation: Bool) {
        isAnimation = animation
        if !animation {
            lastContentOffsetX = frame.width * CGFloat(index)
        } else {
            lastContentOffsetX = frame.width * CGFloat(currentIndex)
        }
        currentIndex = index
        isPageMove = true
        if CGFloat(index) * bounds.width == scrollView.contentOffset.x {
            endChangeIndex()
        } else {
            scrollView.setContentOffset(CGPoint(x: CGFloat(index) * bounds.width, y: 0), animated: animation)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var index = Int(scrollView.contentOffset.x / bounds.width)
        var isLeft = false
        
        if lastContentOffsetX < scrollView.contentOffset.x {
            if CGFloat(index) * bounds.width != scrollView.contentOffset.x {
                index = index + 1
            }
            isLeft = true
        } else {
            isLeft = false
        }
        delegate?.contentViewDidScroll?(scrollView: scrollView, isLeft: isLeft)
        if index >= totalCount {
            return
        }
        if !isPageMove || isAnimation {
            
        } else {
            endChangeIndex()
        }
        isPageMove = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isPageMove = false
        lastContentOffsetX = scrollView.contentOffset.x
        firstContentOffsetX = lastContentOffsetX
        delegate?.contentViewWillBeginDragging?(contentView: self)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / bounds.width)
        endChangeIndex()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / bounds.width)
        endChangeIndex()
    }
    
    func endChangeIndex() {
        delegate?.contentViewDidEndChangeIndex?(contentView: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        let hue = CGFloat(arc4random() % 256) / 256.0
        let saturation = CGFloat(arc4random() % 128) / 256.0 + 0.5
        let brightness = CGFloat(arc4random() % 128) / 256.0 + 0.5
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    static func changeRGBColor(color: UIColor, value: CGFloat) -> UIColor {
        let rgbList = color.getRGB()
        return UIColor(red: rgbList[0] + value, green: rgbList[1], blue: rgbList[2], alpha: rgbList[3])

    }
    
    func getRGB() -> [CGFloat] {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return [red, green, blue, alpha]
    }
}

