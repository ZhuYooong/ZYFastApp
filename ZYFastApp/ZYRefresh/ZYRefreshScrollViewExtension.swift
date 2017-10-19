//
//  ZYRefreshScrollViewExtension.swift
//  a
//
//  Created by MAC on 2017/2/15.
//  Copyright © 2017年 TongBuWeiYe. All rights reserved.
//

import UIKit
let kZYRefreshHeaderViewTag = 101
let kZYRefreshFoootViewTag = 102

let kZYRefreshHeaderViewHeight: CGFloat = 50
let kZYRefreshFoootViewHeight: CGFloat = 80

public extension UIScrollView {
    func toRefresh(_ action :@escaping (() -> ())) {//下拉刷新
        self.alwaysBounceVertical = true
        
        let headView:ZYRefreshHeaderView = ZYRefreshHeaderView(action: action,frame: CGRect(x: 0, y: -kZYRefreshHeaderViewHeight, width: frame.size.width, height: kZYRefreshHeaderViewHeight),scrollView: self)
        headView.tag = kZYRefreshHeaderViewTag
        addSubview(headView)
        headView.autoresizingMask = .flexibleWidth
    }
    func toLoadMore(_ action :@escaping (() -> ())) {//上拉加载更多
        alwaysBounceVertical = true
        
        let footView = ZYRefreshFoootView(action: action, scrollView: self)
        footView.tag = kZYRefreshFoootViewTag
        addSubview(footView)
    }
    func nowRefresh(_ action :(() -> ())? = nil) {//MARK: 立即下拉刷新
        guard let headerView = self.viewWithTag(kZYRefreshHeaderViewTag) as? ZYRefreshHeaderView else {
            if let action = action {
                toRefresh(action)
                self.nowRefresh(action)
            }
            return
        }
        headerView.start()
    }
    func endLoadMore() {//MARK: 数据加载完毕
        if let footView = self.viewWithTag(kZYRefreshFoootViewTag) as? ZYRefreshFoootView {
            footView.refreshStatus = .end
        }
    }
    func doneRefresh() {//MARK: 完成刷新
        if let headerView = self.viewWithTag(kZYRefreshHeaderViewTag) as? ZYRefreshHeaderView {
            headerView.stopAnimation()
        }
        if let footView = self.viewWithTag(kZYRefreshFoootViewTag) as? ZYRefreshFoootView {
            footView.refreshStatus = .normal
            footView.activityView.stopAnimating()
        }
    }
}
