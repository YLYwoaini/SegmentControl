//
//  TitleBarItem.swift
//  SegmentControl
//
//  Created by mac on 2019/7/30.
//  Copyright © 2019 YLY. All rights reserved.
//

import UIKit

class TitleBarItem: UICollectionViewCell {
    let titleLabel: UILabel!
    var index: Int = 0
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(changeColor(notifacation:)), name: NSNotification.Name(rawValue: "TitleBarItemChangeColor"), object: nil)
        
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func changeColor(notifacation: Notification) {
        let index = notifacation.userInfo!["index"] as! Int
        if self.index == index {
            return
        }
        titleLabel.textColor = notifacation.userInfo!["color"] as? UIColor
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
