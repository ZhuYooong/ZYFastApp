//
//  ZYThirdRootViewController.swift
//  ZYFastApp
//
//  Created by MAC on 16/8/15.
//  Copyright © 2016年 TongBuWeiYe. All rights reserved.
//

import UIKit

class ZYThirdRootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "threeWebSegueID" {
            let destinationViewController = segue.destinationViewController as? ZYWebViewController
            destinationViewController?.title = "简书"
            destinationViewController?.httpURL = "http://www.jianshu.com"
        }
    }
}
