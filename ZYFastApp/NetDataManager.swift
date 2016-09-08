//
//  NetDataManager.swift
//  ZYFastApp
//
//  Created by MAC on 16/8/15.
//  Copyright © 2016年 TongBuWeiYe. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class NetDataManager: NSObject {
    static let shareNetDataManager = NetDataManager()
    private override init() {}
    let pageSize = 20
    //baseURL
    let V2EXBaseURL = "http://news-at.zhihu.com/api"
    //get方法
    func GETRequest(URLString: URLStringConvertible, NetData: (data: NSData?)->Void) {
        HUD.show(.LabeledProgress(title: "正在加载", subtitle: ""))
        Alamofire.request(.GET, URLString).responseJSON {
            response in
            switch response.result {
            case .Success:
                NetData(data: response.data)
                HUD.hide()
            case .Failure( _):
                HUD.show(.LabeledError(title: "连接服务器失败", subtitle: ""))
                HUD.hide()
            }
        }
    }
}
extension NetDataManager {
    func findLatestNews(NetData: (data: NSData?)->Void) {// 最新消息
        GETRequest("\(V2EXBaseURL)/4/news/latest", NetData: NetData)
    }
    func findHotNews(NetData: (data: NSData?)->Void) {// 热门消息
        GETRequest("\(V2EXBaseURL)/3/news/hot", NetData: NetData)
    }
    func findSections(NetData: (data: NSData?)->Void) {// 栏目总览
        GETRequest("\(V2EXBaseURL)/3/sections", NetData: NetData)
    }
}