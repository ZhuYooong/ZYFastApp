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
    dynamic var news_id: String? = ""
    dynamic var url: String? = ""
    dynamic var thumbnail: String? = ""
    dynamic var title: String? = ""
    
    override class func primaryKey() -> String? {
        return "news_id"
    }
}
