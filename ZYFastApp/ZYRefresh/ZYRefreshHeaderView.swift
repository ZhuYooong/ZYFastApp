//
//  ZYRefreshHeaderView.swift
//  a
//
//  Created by MAC on 2017/2/15.
//  Copyright © 2017年 TongBuWeiYe. All rights reserved.
//

import UIKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}
class ZYRefreshHeaderView: UIView {
    var action: (() -> ())
    var scrollView: UIScrollView
    var headImageView: UIImageView
    var originTop: CGFloat
    
    let imageViewW: CGFloat = 113
    var keyboardIsShowing:Bool = false
    init(action :@escaping (() -> ()), frame: CGRect, scrollView:UIScrollView) {
        self.action = action
        self.scrollView = scrollView
        self.headImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.headImageView.autoresizingMask = .flexibleWidth
        self.headImageView.contentMode = .center
        self.originTop = scrollView.contentInset.top
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.headImageView.backgroundColor = UIColor.clear
        self.addSubview(headImageView)
        self.scrollView.addObserver(self, forKeyPath: "contentOffset", options: .initial, context: nil)
        //键盘监听
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboradWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboradWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    required public init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
    @objc func keyboradWillShow(){
        keyboardIsShowing = true
    }
    @objc func keyboradWillHide(){
        keyboardIsShowing = false
    }
    var imgName:String {
        set {
            if(Int(newValue)<2) {
                self.headImageView.image = UIImage(named: "progress_0", in: Bundle(for: self.classForCoder), compatibleWith: nil)
            }else if Int(newValue)>8+2 {
                self.headImageView.image = UIImage(named: "progress_8", in: Bundle(for: self.classForCoder), compatibleWith: nil)
            }else {
                self.headImageView.image = UIImage(named: "progress_\(Int(newValue)!-2)", in: Bundle(for: self.classForCoder), compatibleWith: nil)
            }
        }
        get {return self.imgName}
    }
    func stopAnimation() {
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollView.contentInset = UIEdgeInsetsMake(self.originTop, 0, 0, 0)
        })
        self.headImageView.stopAnimating()
        self.headImageView.isHidden = true
    }
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let y = self.scrollView.contentOffset.y
        let top = self.scrollView.contentInset.top
        if y <= -kZYRefreshHeaderViewHeight - top + 10 && scrollView.isDragging == false && self.headImageView.isAnimating == false && !keyboardIsShowing {
            start()
        }
        if (y <= 0) {
            self.imgName = "\((Int)(abs(y+top)))"
        }
    }
    func start() {
        self.headImageView.isHidden = false
        var results = [UIImage]()
        for i in 1...8{
            if let image = UIImage(named: "progress_\(i)", in: Bundle(for: ZYRefreshHeaderView.self), compatibleWith: nil) {
                results.append(image)
            }
        }
        self.headImageView.animationImages = results
        self.headImageView.animationDuration = 1.5
        
        
        self.headImageView.startAnimating()
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollView.contentInset = UIEdgeInsetsMake(self.originTop + kZYRefreshHeaderViewHeight, 0, 0, 0)
            self.scrollView.contentOffset = CGPoint(x: 0, y: -self.originTop - kZYRefreshHeaderViewHeight)
        })
        self.action()
    }
    deinit {
        self.scrollView.removeObserver(self, forKeyPath: "contentOffset", context: nil)
        NotificationCenter.default.removeObserver(self)
    }
}
