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
    fileprivate override init() {}
    let pageSize = 20
    //baseURL
    let V2EXBaseURL = "http://news-at.zhihu.com/api"
    //get方法
    func GETRequest(_ URLString: URLConvertible, NetData: @escaping (_ data: Data?)->Void) {
        HUD.show(.labeledProgress(title: "正在加载", subtitle: ""))
        Alamofire.request(URLString, method: .get).responseJSON {
            response in
            switch response.result {
            case .success:
                NetData(response.data)
                HUD.hide()
            case .failure( _):
                HUD.show(.labeledError(title: "连接服务器失败", subtitle: ""))
                HUD.hide()
            }
        }
    }
}
extension NetDataManager {
    func findLatestNews(_ NetData: @escaping (_ data: Data?)->Void) {// 最新消息
        GETRequest("\(V2EXBaseURL)/4/news/latest", NetData: NetData)
    }
    func findHotNews(_ NetData: @escaping (_ data: Data?)->Void) {// 热门消息
        GETRequest("\(V2EXBaseURL)/3/news/hot", NetData: NetData)
    }
    func findSections(_ NetData: @escaping (_ data: Data?)->Void) {// 栏目总览
        GETRequest("\(V2EXBaseURL)/3/sections", NetData: NetData)
    }
}
