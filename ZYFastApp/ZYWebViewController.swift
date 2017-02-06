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
    let httpWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height+48))
    let progressView = UIProgressView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 30))
    override func viewDidLoad() {
        super.viewDidLoad()
        initItem()
        initData()
    }
    //MARK: - 初始化界面
    func initItem() {
        view.backgroundColor = UIColor.white
        
        httpWebView.allowsBackForwardNavigationGestures = true
        view.addSubview(httpWebView)
        
        progressView.progress = 0.0
        self.progressView.isHidden = true
        self.progressView.tintColor = UIColor(ZYCustomColor.darkCyanColor.rawValue)
        view.addSubview(progressView)
        
        httpWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    //MARK: - 加载数据
    func initData() {
        var request: URLRequest?
        if let urlStr = httpURL {
            if let url = URL(string: urlStr) , urlStr.length >= 6 && urlStr.substring(with: urlStr.rangeFromNSRange(NSMakeRange(0, 4))!) == "http" {
                request = URLRequest(url: url)
            }else if let url = URL(string: "http://\(urlStr)") {
                request = URLRequest(url: url)
            }
            httpWebView.load(request!)
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            
        }else if keyPath == "title" {
            title = httpWebView.title
        }else if keyPath == "URL" {
            
        }else if keyPath == "estimatedProgress" {
            if object as? WKWebView == httpWebView  {
                let progress = self.httpWebView.estimatedProgress
                if progress == 1 {
                    progressView.isHidden = true
                    self.progressView.setProgress(0, animated: false)
                }else {
                    self.progressView.isHidden = false
                    self.progressView.setProgress(Float(progress), animated: true)
                }
            }else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }
    }
    deinit {
        httpWebView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}
