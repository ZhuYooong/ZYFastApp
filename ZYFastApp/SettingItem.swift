//
//  SettingItem.swift
//  ZYFastApp
//
//  Created by MAC on 16/9/13.
//  Copyright © 2016年 TongBuWeiYe. All rights reserved.
//

import UIKit

class SettingItem: NSObject {
    var title = ""
    var image: UIImage?
    var height: CGFloat? = 44
    var type: UITableViewCellAccessoryType?
    init(title: String, image: UIImage?, height: CGFloat? = 44, type: UITableViewCellAccessoryType? = .disclosureIndicator) {
        self.title = title
        if let image = image {
            self.image = image
        }
        if let height = height {
            self.height = height
        }
        if let type = type {
            self.type = type
        }
    }
}
