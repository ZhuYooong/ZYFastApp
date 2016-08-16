//
//  ZYFirstTableViewCell.swift
//  ZYFastApp
//
//  Created by MAC on 16/8/16.
//  Copyright © 2016年 TongBuWeiYe. All rights reserved.
//

import UIKit

class ZYFirstTableViewCell: UITableViewCell {
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
