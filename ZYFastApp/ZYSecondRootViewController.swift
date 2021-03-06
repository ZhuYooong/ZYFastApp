//
//  ZYSecondRootViewController.swift
//  ZYFastApp
//
//  Created by MAC on 16/8/15.
//  Copyright © 2016年 TongBuWeiYe. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import SwiftyJSON

class ZYSecondRootViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        initData()
    }
    //MARK: - CollectionView 界面
    var collectionNode: ASCollectionNode!
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionNode = ASCollectionNode(frame: view.frame, collectionViewLayout: layout)
        collectionNode.backgroundColor = UIColor.white
        collectionNode.dataSource = self
        view.addSubnode(collectionNode)
    }
    //MARK: - 数据加载
    var contentNewsArray = [HotNewsInfo]()
    func initData() {
        NetDataManager.shareNetDataManager.findHotNews { (data) in
            if let data = data {
                let json = JSON(data: data)
                let rootDictionary = json.dictionaryValue
                if let recentJson = rootDictionary["recent"] {
                    self.contentNewsArray = [HotNewsInfo]()
                    for subJson in recentJson.arrayValue {
                        let hotNewsInfo = HotNewsInfo()
                        hotNewsInfo.news_id = subJson["news_id"].stringValue
                        hotNewsInfo.thumbnail = subJson["thumbnail"].stringValue
                        hotNewsInfo.title = subJson["title"].stringValue
                        hotNewsInfo.url = subJson["url"].stringValue
                        self.contentNewsArray.append(hotNewsInfo)
                    }
                    self.collectionNode.reloadData()
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
//MARK: - ASCollectionDataSource
extension ZYSecondRootViewController: ASCollectionDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentNewsArray.count
    }
    func collectionView(_ collectionView: ASCollectionView, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        return ZYSecondCollectionViewCellNode(hotNewsInfo: contentNewsArray[(indexPath as NSIndexPath).row])
    }
}
