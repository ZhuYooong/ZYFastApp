//
//  HotNewsInfo.swift
//  ZYFastApp
//
//  Created by MAC on 16/8/17.
//  Copyright © 2016年 TongBuWeiYe. All rights reserved.
//

import UIKit
import RealmSwift
class HotNewsInfo: Object {
    @objc dynamic var news_id: String? = ""
    @objc dynamic var url: String? = ""
    @objc dynamic var thumbnail: String? = ""
    @objc dynamic var title: String? = ""
    
    override class func primaryKey() -> String? {
        return "news_id"
    }
}
