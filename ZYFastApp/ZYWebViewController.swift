//
//  ZYWebViewController.swift
//  ZYFastApp
//
//  Created by MAC on 16/8/16.
//  Copyright © 2016年 TongBuWeiYe. All rights reserved.
//

import UIKit
import WebKit
class ZYWebViewController: UIViewController {
    var httpURL: String?
    let httpWebView = WKWebView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height+48))
    let progressView = UIProgressView(frame: CGRectMake(0, 64, UIScreen.mainScreen().bounds.size.width, 30))
    override func viewDidLoad() {
        super.viewDidLoad()
        initItem()
        initData()
    }
    //MARK: - 初始化界面
    func initItem() {
        view.backgroundColor = UIColor.whiteColor()
        
        httpWebView.allowsBackForwardNavigationGestures = true
        view.addSubview(httpWebView)
        
        progressView.progress = 0.0
        self.progressView.hidden = true
        self.progressView.tintColor = UIColor(ZYCustomColor.darkCyanColor.rawValue)
        view.addSubview(progressView)
        
        httpWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    }
    //MARK: - 加载数据
    func initData() {
        var request = NSURLRequest()
        if let urlStr = httpURL {
            if let url = NSURL(string: urlStr) where urlStr.length >= 6 && urlStr.substringWithRange(urlStr.rangeFromNSRange(NSMakeRange(0, 4))!) == "http" {
                request = NSURLRequest(URL: url)
            }else if let url = NSURL(string: "http://\(urlStr)") {
                request = NSURLRequest(URL: url)
            }
            httpWebView.loadRequest(request)
        }
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "loading" {
            
        }else if keyPath == "title" {
            title = httpWebView.title
        }else if keyPath == "URL" {
            
        }else if keyPath == "estimatedProgress" {
            if object as? WKWebView == httpWebView  {
                let progress = self.httpWebView.estimatedProgress
                if progress == 1 {
                    progressView.hidden = true
                    self.progressView.setProgress(0, animated: false)
                }else {
                    self.progressView.hidden = false
                    self.progressView.setProgress(Float(progress), animated: true)
                }
            }else {
                super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
            }
        }
    }
    deinit {
        httpWebView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}
