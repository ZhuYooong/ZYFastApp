//
//  SettingSection.swift
//  ZYFastApp
//
//  Created by MAC on 16/9/13.
//  Copyright © 2016年 TongBuWeiYe. All rights reserved.
//

import UIKit

class SettingSection: NSObject {
    var headerTitle: String?
    var footerTitle: String?
    var items = [SettingItem]()
    init(headerTitle: String?, footerTitle: String?, items: [SettingItem]) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.items = items
    }
}
