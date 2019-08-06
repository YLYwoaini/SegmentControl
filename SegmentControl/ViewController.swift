//
//  ViewController.swift
//  SegmentControl
//
//  Created by mac on 2019/7/17.
//  Copyright © 2019 YLY. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SegmentedContentViewDelegate, SegmentedControlBarProtocol {
    
    var topBar: SegmentedControlBar!
    var contentView: SegmentedContentView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "🙄"
        
        topBar = SegmentedControlBar()
        topBar.delegate = self
        view.addSubview(topBar)
        topBar.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.left.right.equalToSuperview()
            make.top.equalTo(NavigationBarHeight)
        }
        
        contentView = SegmentedContentView(frame: CGRect(x: 0, y: NavigationBarHeight + 44, width: view.bounds.width, height: view.bounds.height - NavigationBarHeight - 44))
        contentView.delegate = self
        view.addSubview(contentView)
        
        topBar.associateView = contentView.scrollView
        topBar.titles = ["🙄🙄🙄", "🙄🙄", "🙄🙄🙄🙄", "🙄🙄🙄", "🙄🙄", "🙄🙄🙄🙄", "🙄🙄🙄"]
//        topBar.titles = ["呵呵呵", "呵呵", "呵呵呵呵", "呵呵呵", "呵呵", "呵呵呵呵", "呵呵呵"]
    }
    
    func didSelectedIndex(_ index: Int) {
        contentView.moveToIndex(index: index, animation: false)
    }

    func contentViewDidScroll(scrollView: UIScrollView, isLeft: Bool) {
        topBar.responseScrollAction(scrollView: scrollView, isLeft: isLeft)
    }
    
    func contentViewWillBeginDragging(contentView: SegmentedContentView) {
        topBar.isDragging = true
        topBar.lastAssociateViewOffsetX = contentView.scrollView.contentOffset.x
    }
    
    func contentViewDidEndChangeIndex(contentView: SegmentedContentView) {
        topBar.configSelectedIndex(index: contentView.currentIndex)
    }
}

