//
//  LatestNewsInfo.swift
//  ZYFastApp
//
//  Created by MAC on 16/8/15.
//  Copyright © 2016年 TongBuWeiYe. All rights reserved.
//

import UIKit
import RealmSwift
class LatestNewsInfo: Object {
    @objc dynamic var id: String? = ""
    @objc dynamic var title: String? = ""
    @objc dynamic var images: String? = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
