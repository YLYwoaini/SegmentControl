//
//  SegmentedControlBar.swift
//  SegmentControl
//
//  Created by mac on 2019/7/29.
//  Copyright © 2019 YLY. All rights reserved.
//

import UIKit

@objc protocol SegmentedControlBarProtocol {
    @objc optional func didSelectedIndex(_ index: Int)
}

class SegmentedControlBar: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    fileprivate var _titles: [String] = []
    var titles: [String] {
        get {
            return _titles
        }
        set {
            _titles = newValue
            
            widthArray.removeAll()
            orginXArray.removeAll()
            configItemAttributes()
            
            collectionView.reloadData()
            layoutIfNeeded()
            
            lineView.frame = CGRect(x: orginXArray[firstIndex], y: bounds.height - 2, width: widthArray[firstIndex], height: 2)
            collectionView.addSubview(lineView)
            
            adjustContentOffsetToIndex(firstIndex, completeHandle: {}, animation: false)
            delegate?.didSelectedIndex?(firstIndex)
        }
    }
    let itemSpace: CGFloat = 30.0
    
    var firstIndex = 0
    weak var delegate: SegmentedControlBarProtocol?
    var lineView: UIView!
    var isDragging = false
    
    var collectionView: UICollectionView!
    var widthArray: [CGFloat] = []
    var orginXArray: [CGFloat] = []
    
    var currentIndex: Int = 0
    var lastContentOffsetX: CGFloat = 0.0
    
    var associateView: UIScrollView?
    var lastAssociateViewOffsetX: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = itemSpace
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: itemSpace, bottom: 0, right: itemSpace)
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        collectionView.register(TitleBarItem.self, forCellWithReuseIdentifier: "TitleBarItem")
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        lineView = UIView()
        lineView.backgroundColor = UIColor.red
    }
    
    func configItemAttributes() {
        var orginX = itemSpace
        for string in titles {
            let size = NSString(string: string).size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)])
            orginXArray.append(orginX)
            widthArray.append(ceil(size.width))
            orginX = orginX + ceil(size.width) + itemSpace
        }
    }
    
    func configSelectedIndex(index: Int) {
        currentIndex = index
        adjustContentOffsetToIndex(index, completeHandle: {
            let item = self.collectionView.cellForItem(at: IndexPath(row: self.currentIndex, section: 0)) as! TitleBarItem
            item.titleLabel.textColor = UIColor.red
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TitleBarItemChangeColor"), object: nil, userInfo: ["index" : self.currentIndex, "color" : UIColor.black])
        }, animation: true)
    }
    
    func adjustContentOffsetToIndex(_ index: Int, completeHandle: @escaping () -> Void, animation: Bool) {
        if index >= titles.count || index < 0 {
            return
        }
        let maxOffsetX = orginXArray[orginXArray.count - 1] + widthArray[widthArray.count - 1] + itemSpace - width
        let indexCenterOffsetX = orginXArray[index] + widthArray[index] * 0.5 - width * 0.5
        
        var point: CGPoint
        if indexCenterOffsetX > maxOffsetX {
            point = CGPoint(x: maxOffsetX, y: 0)
        } else if indexCenterOffsetX <= 0 {
            point = CGPoint(x: 0, y: 0)
        } else {
            point = CGPoint(x: indexCenterOffsetX, y: 0)
        }
        self.scrollToPoint(point, completeHandle: completeHandle, animation: animation)
    }
    
    func scrollToPoint(_ point: CGPoint, completeHandle: @escaping () -> Void, animation: Bool) {
        if animation {
            UIView.animate(withDuration: 0.2, animations: {
                self.collectionView.contentOffset = point
                self.lineView.width = self.widthArray[self.currentIndex]
                self.lineView.left = self.orginXArray[self.currentIndex]
            }) { (finished) in
                completeHandle()
            }
        } else {
            collectionView.contentOffset = point
            lineView.width = widthArray[currentIndex]
            lineView.left = orginXArray[currentIndex]
            completeHandle()
        }
    }
    
    func responseScrollAction(scrollView: UIScrollView, isLeft: Bool) {
        if !isDragging {
            return
        }
        var nextWidth: CGFloat = 0.0
        var nextOrginx: CGFloat = 0.0
        if isLeft {
            let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
            if index >= titles.count || index < 0 {
                return
            }
            let currentWidth = widthArray[index]
            let currentOrginX = orginXArray[index]
            if index + 1 == titles.count {
                return
            }
            
            nextWidth = widthArray[index + 1]
            nextOrginx = orginXArray[index + 1]
            
            let orginDistance = nextOrginx - currentOrginX
            let distance = scrollView.contentOffset.x - lastContentOffsetX
            
            lineView.x = lineView.x + orginDistance / scrollView.width * distance
            
            let widthDistance = nextWidth - currentWidth
            lineView.width = lineView.width + distance / scrollView.width * widthDistance
            lastContentOffsetX = scrollView.contentOffset.x
            if lastContentOffsetX == lastAssociateViewOffsetX {
                return
            }
            
            let leftItem = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? TitleBarItem
            let rightItem = collectionView.cellForItem(at: IndexPath(row: index + 1, section: 0)) as? TitleBarItem
            if let item = leftItem {
                item.titleLabel.textColor = UIColor.changeRGBColor(color: item.titleLabel.textColor, value: -distance / scrollView.width)
            }
            if let item = rightItem {
                item.titleLabel.textColor = UIColor.changeRGBColor(color: item.titleLabel.textColor, value: distance / scrollView.width)
            }
        } else {
            let index = Int(scrollView.contentOffset.x / scrollView.frame.width) + 1
            if index >= titles.count || index < 0 {
                return
            }
            let currentWidth = widthArray[index]
            let currentOrginX = orginXArray[index]
            if index - 1 < 0 {
                return
            }
            nextWidth = widthArray[index - 1]
            nextOrginx = orginXArray[index - 1]
            let orginDistance = nextOrginx - currentOrginX
            let distance = scrollView.contentOffset.x - lastContentOffsetX
            lineView.x = lineView.x - orginDistance / scrollView.width * distance
            
            let widthDistance = nextWidth - currentWidth
            lineView.width = lineView.width - distance / scrollView.width * widthDistance
            lastContentOffsetX = scrollView.contentOffset.x
            if lastContentOffsetX == lastAssociateViewOffsetX {
                return
            }
            
            let leftItem = collectionView.cellForItem(at: IndexPath(row: index - 1, section: 0)) as? TitleBarItem
            let rightItem = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? TitleBarItem
            if let item = leftItem {
                item.titleLabel.textColor = UIColor.changeRGBColor(color: item.titleLabel.textColor, value: -distance / scrollView.width)
            }
            if let item = rightItem {
                item.titleLabel.textColor = UIColor.changeRGBColor(color: item.titleLabel.textColor, value: distance / scrollView.width)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SegmentedControlBar {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isDragging = false
        lastContentOffsetX = associateView!.width * CGFloat(indexPath.row)
        currentIndex = indexPath.row
        let item = collectionView.cellForItem(at: IndexPath(row: currentIndex, section: 0)) as! TitleBarItem
        item.titleLabel.textColor = UIColor.red
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TitleBarItemChangeColor"), object: nil, userInfo: ["index" : self.currentIndex, "color" : UIColor.black])
        adjustContentOffsetToIndex(currentIndex, completeHandle: {}, animation: true)
        delegate?.didSelectedIndex?(currentIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleBarItem", for: indexPath) as! TitleBarItem
        item.titleLabel.text = titles[indexPath.row]
        item.index = Int(indexPath.row)
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: widthArray[indexPath.row], height: bounds.height)
    }
}
