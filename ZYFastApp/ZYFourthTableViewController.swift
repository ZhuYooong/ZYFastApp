//
//  ZYFourthTableViewController.swift
//  ZYFastApp
//
//  Created by MAC on 16/9/13.
//  Copyright © 2016年 TongBuWeiYe. All rights reserved.
//

import UIKit

class ZYFourthTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initItem()
    }
    //MARK: - 初始化界面
    func initItem() {
        tableView.tableFooterView = UIView()
    }
    var groups: [SettingSection] {
        get {
            var groups = [SettingSection]()
            let section1 = SettingSection(headerTitle: "个人信息", footerTitle: nil,  items: [SettingItem(title: "Zhuyooong", image: UIImage(named: "user_icon"), height: 64), SettingItem(title: "", image: nil, height: nil, type: .none)])
            groups.append(section1)
            let section2 = SettingSection(headerTitle: nil, footerTitle: nil, items: [SettingItem(title: "Item1", image: nil), SettingItem(title: "Item2", image: nil), SettingItem(title: "Item3", image: nil), SettingItem(title: "Item4", image: nil)])
            groups.append(section2)
            let section3 = SettingSection(headerTitle: nil, footerTitle: "© 2016 Setting", items: [SettingItem(title: "Item1", image: nil)])
            groups.append(section3)
            return groups
        }
    }
    //MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups[section].items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "SettingCellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
        }
        let section = groups[(indexPath as NSIndexPath).section]
        let item = section.items[(indexPath as NSIndexPath).row]
        cell?.textLabel?.text = item.title
        cell?.imageView?.image = item.image
        cell?.accessoryType = item.type ?? .none
        return cell!
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let group = groups[section]
        return group.headerTitle
    }
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let group = groups[section]
        return group.footerTitle
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = self.groups[(indexPath as NSIndexPath).section]
        let item = section.items[(indexPath as NSIndexPath).row]
        return item.height ?? 44
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
