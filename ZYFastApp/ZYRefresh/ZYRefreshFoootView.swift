//
//  ZYRefreshFoootView.swift
//  a
//
//  Created by MAC on 2017/2/15.
//  Copyright © 2017年 TongBuWeiYe. All rights reserved.
//

import UIKit

class ZYRefreshFoootView: UIView {
    var scrollView:UIScrollView
    var loadMoreAction: (() -> Void)
    var isEndLoadMore = false
    
    enum RefreshStatus{
        case normal, loadMore, end
    }
    var refreshStatus:RefreshStatus = .normal
    var originInset: UIEdgeInsets
    var activityView: UIActivityIndicatorView
    init(action: @escaping (() -> ()), scrollView:UIScrollView){
        self.loadMoreAction = action
        self.scrollView = scrollView
        refreshStatus = .normal
        self.originInset = scrollView.contentInset
        activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        super.init(frame: CGRect.zero)
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        scrollView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        activityView.frame = CGRect(origin: CGPoint(x: (scrollView.frame.size.width-activityView.frame.size.width)/2.0, y: kZYRefreshFoootViewHeight/2.0), size: activityView.frame.size)
        self.addSubview(activityView)
    }
    required public init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        let contentHeight = self.scrollView.contentSize.height
        let scrollHeight = self.scrollView.frame.size.height  - self.originInset.top - self.originInset.bottom
        var rect:CGRect = self.frame;
        rect.origin.y =  contentHeight > scrollHeight ? contentHeight : scrollHeight
        self.frame = rect
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let y = scrollView.contentOffset.y
        if keyPath == "contentSize" {
            willMove(toSuperview: nil)
        } else if keyPath == "contentOffset" {
            if y > 0 {
                let nowContentOffsetY:CGFloat = y + self.scrollView.frame.size.height
                if (nowContentOffsetY - scrollView.contentSize.height) > 0 && scrollView.contentOffset.y != 0 {
                    if isEndLoadMore == false && refreshStatus == .normal {
                        refreshStatus = .loadMore
                        loadMoreAction()
                        
                        activityView.startAnimating()
                        UIView.animate(withDuration: 0.25, animations: {
                            self.scrollView.contentInset = UIEdgeInsetsMake(self.scrollView.contentInset.top, 0, kZYRefreshFoootViewHeight, 0)
                        })
                    }
                }
            }
        }
    }
    func getViewControllerWithView(_ vcView:UIView) -> AnyObject {
        if( (vcView.next?.isKind(of: UIViewController.self) ) == true){
            return vcView.next as! UIViewController
        }
        if(vcView.superview == nil){
            return vcView
        }
        return self.getViewControllerWithView(vcView.superview!)
    }
    deinit {
        self.scrollView.removeObserver(self, forKeyPath: "contentOffset", context: nil)
        self.scrollView.removeObserver(self, forKeyPath: "contentSize", context: nil)
    }
}
