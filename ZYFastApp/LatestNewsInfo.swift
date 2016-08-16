//
//  LatestNewsInfo.swift
//  ZYFastApp
//
//  Created by MAC on 16/8/15.
//  Copyright © 2016年 TongBuWeiYe. All rights reserved.
//

import UIKit
import Realm
class LatestNewsInfo: RLMObject {
    dynamic var id: String? = ""
    dynamic var title: String? = ""
    dynamic var images: String? = ""
}
