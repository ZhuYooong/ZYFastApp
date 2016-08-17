//
//  ViewController.swift
//  ZYFastApp
//
//  Created by MAC on 16/8/12.
//  Copyright © 2016年 TongBuWeiYe. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import PKHUD
import HexColor
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet weak var firstScrollView: UIView!
    @IBOutlet weak var firstTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initItem()
        initData()
    }
    //MARK: - 初始化界面
    func initItem() {
        creatDefultFirstScrollView()
        firstTableView.tableFooterView = UIView()
    }
    //MARK: ViewPager 页面
    var advertisementDefultImageView = UIImageView(image: UIImage(named: "first_defult_banner"))
    func creatDefultFirstScrollView() {
        advertisementDefultImageView.userInteractionEnabled = true
        advertisementDefultImageView.contentMode = .ScaleToFill
        firstScrollView.addSubview(advertisementDefultImageView)
        advertisementDefultImageView.snp_makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(firstScrollView)
        }
    }
    let advertisementScrollView = UIScrollView()
    var advertisementPageController = UIPageControl()
    func creatFirstScrollViewWithArray(newsArray: [LatestNewsInfo]) {
        if newsArray.count == 1 {
            if let url = NSURL(string: newsArray[0].images!) {
                advertisementDefultImageView.kf_setImageWithURL(url, placeholderImage: UIImage(named: "banner"))
                let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.defultImageViewTap(_:)))
                advertisementDefultImageView.addGestureRecognizer(tap)
            }
            if let titleString = newsArray[0].title {
                let advertisementTitleLabel = UILabel()
                advertisementTitleLabel.text = titleString
                advertisementTitleLabel.textColor = UIColor.whiteColor()
                advertisementDefultImageView.addSubview(advertisementTitleLabel)
                advertisementTitleLabel.snp_makeConstraints(closure: { (make) in
                    make.left.bottom.equalTo(advertisementDefultImageView)
                    make.right.equalTo(advertisementDefultImageView).offset(-8)
                    make.height.equalTo(21)
                })
            }
        }else if newsArray.count >= 2 {
            advertisementDefultImageView.removeFromSuperview()
            let headerView = UIView()
            firstScrollView.addSubview(headerView)
            let advertisementScrollView = UIScrollView()
            advertisementScrollView.delegate = self
            advertisementScrollView.pagingEnabled = true
            advertisementScrollView.showsHorizontalScrollIndicator = false
            firstScrollView.addSubview(advertisementScrollView)
            advertisementScrollView.snp_makeConstraints { (make) in
                make.top.left.bottom.right.equalTo(firstScrollView)
            }
            for indexInt in 0 ..< newsArray.count {
                let advertisementImageView = UIImageView(image: UIImage(named: "first_defult_banner"))
                advertisementImageView.userInteractionEnabled = true
                if let url = NSURL(string: newsArray[indexInt].images!) {
                    advertisementImageView.kf_setImageWithURL(url, placeholderImage: UIImage(named: "first_defult_banner"))
                }
                advertisementImageView.contentMode = .ScaleToFill
                let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.advertisementImageViewTap(_:)))
                advertisementDefultImageView.addGestureRecognizer(tap)
                advertisementScrollView.addSubview(advertisementImageView)
                let xLoca = CGFloat(indexInt) * CGFloat(view.frame.size.width)
                advertisementImageView.snp_makeConstraints(closure: { (make) in
                    make.top.height.width.equalTo(advertisementScrollView)
                    make.left.equalTo(advertisementScrollView).offset(xLoca)
                })
                if let titleString = newsArray[indexInt].title {
                    let advertisementTitleLabel = UILabel()
                    advertisementTitleLabel.text = titleString
                    advertisementTitleLabel.textColor = UIColor.whiteColor()
                    advertisementImageView.addSubview(advertisementTitleLabel)
                    advertisementTitleLabel.snp_makeConstraints(closure: { (make) in
                        make.left.bottom.equalTo(advertisementImageView)
                        make.right.equalTo(advertisementImageView).offset(-8)
                        make.height.equalTo(21)
                    })
                }
            }
            advertisementScrollView.contentSize = CGSizeMake(CGFloat(newsArray.count) * view.frame.size.width, 0)
            //页面指示器
            advertisementPageController.currentPage = 0
            advertisementPageController.currentPageIndicatorTintColor = UIColor(ZYCustomColor.lightCyanColor.rawValue)
            advertisementPageController.numberOfPages = newsArray.count
            advertisementPageController.pageIndicatorTintColor = UIColor(ZYCustomColor.darkCyanColor.rawValue)
            advertisementPageController.userInteractionEnabled = false
            firstScrollView.addSubview(advertisementPageController)
            advertisementPageController.snp_makeConstraints { (make) in
                make.centerX.bottom.width.equalTo(advertisementScrollView)
                make.height.equalTo(30)
            }
        }
    }
    //MARK: - 数据加载
    var contentNewsArray = [LatestNewsInfo]()
    func initData() {
        NetDataManager.shareNetDataManager.findLatestNews { (data) in
            if let data = data {
                let json = JSON(data: data)
                let rootDictionary = json.dictionaryValue
                if let storiesJson = rootDictionary["stories"] {//tableView 数据
                    self.contentNewsArray = [LatestNewsInfo]()
                    for subJson in storiesJson.arrayValue {
                        let newsInfo = LatestNewsInfo()
                        newsInfo.id = subJson["id"].stringValue
                        newsInfo.title = subJson["title"].stringValue
                        newsInfo.images = subJson["images"][0].stringValue
                        self.contentNewsArray.append(newsInfo)
                    }
                    self.firstTableView.reloadData()
                }
                if let topStoriesJson = rootDictionary["top_stories"] {//ViewPager 数据
                    var newsArray = [LatestNewsInfo]()
                    for subJson in topStoriesJson.arrayValue {
                        let newsInfo = LatestNewsInfo()
                        newsInfo.id = subJson["id"].stringValue
                        newsInfo.title = subJson["title"].stringValue
                        newsInfo.images = subJson["image"].stringValue
                        newsArray.append(newsInfo)
                    }
                    self.creatFirstScrollViewWithArray(newsArray)
                }
            }
        }
    }
    //MARK: - 页面跳转
    func defultImageViewTap(recognizer: UITapGestureRecognizer) {//单个广告
        
    }
    func advertisementImageViewTap(recognizer: UITapGestureRecognizer) {//多个广告
        
    }
}
//MARK: - ScrollView 代理
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        advertisementPageController.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
    }
}
//MARK: - TableView 代理
extension ViewController: UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentNewsArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "firstCellID"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! ZYFirstTableViewCell
        if let titleString = contentNewsArray[indexPath.row].title, let url = NSURL(string: contentNewsArray[indexPath.row].images!) {
            cell.titleLabel?.text = titleString
            cell.titleImageView?.kf_setImageWithURL(url, placeholderImage: UIImage(named: "first_defult_banner"))
        }
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "暂无信息")
    }
}