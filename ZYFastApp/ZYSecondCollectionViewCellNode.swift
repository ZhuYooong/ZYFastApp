//
//  ZYSecondCollectionViewCellNode.swift
//  ZYFastApp
//
//  Created by MAC on 16/8/17.
//  Copyright © 2016年 TongBuWeiYe. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import SnapKit
class ZYSecondCollectionViewCellNode: ASCellNode {
    let hotNewsInfo: HotNewsInfo
    init(hotNewsInfo: HotNewsInfo) {
        self.hotNewsInfo = hotNewsInfo
        super.init()
        configure()
    }
    //MARK: - 界面布局
    var nodeSize: CGSize {
        let spacing: CGFloat = 1
        let screenWidth = UIScreen.mainScreen().bounds.width
        let itemWidth = floor((screenWidth / 2) - (spacing / 2))
        let itemHeight = floor((screenWidth / 3) - (spacing / 2))
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func viewFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: nodeSize.width, height: nodeSize.height)
    }
    override func calculateLayoutThatFits(constrainedSize: ASSizeRange) -> ASLayout {//加载界面布局
        return ASLayout(layoutableObject: self, constrainedSizeRange: ASSizeRangeMake(nodeSize, nodeSize), size: nodeSize)
    }
    //MARK: - 设置界面
    func configure() {
        backgroundColor = UIColor.blackColor()
        configureLoadingIndicator()
        configureImageNode()
        configureCaptionNodes()
    }
    //加载图片
    func loadingIndicatorCenter() -> CGPoint {
        let centerX = nodeSize.width / 2
        let centerY = nodeSize.height / 2 - captionContainerFrame().height / 2
        return CGPoint(x: centerX, y: centerY)
    }
    var loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    func configureLoadingIndicator() {
        loadingIndicator.center = loadingIndicatorCenter()
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    //imageNode
    var imageNode = ASNetworkImageNode()
    func configureImageNode() {
        imageNode.frame = viewFrame()
        imageNode.delegate = self
        imageNode.URL = NSURL(string: hotNewsInfo.thumbnail!)
        imageNode.layerBacked = true
        addSubnode(imageNode)
    }
    //标题栏
    func configureCaptionNodes() {
        configureCaptionBlurView()
        configureCaptionContainerNode()
        configureCaptionLabelNode()
    }
    func captionContainerFrame() -> CGRect {//标题栏尺寸
        let containerHeight: CGFloat = 35
        return CGRect(x: 0, y: nodeSize.height - containerHeight, width: nodeSize.width, height: containerHeight)
    }
    //毛玻璃
    var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
    func configureCaptionBlurView() {
        blurView.frame = captionContainerFrame()
        view.addSubview(blurView)
    }
    //标题界面背景颜色
    var captionContainerNode = ASDisplayNode()
    func configureCaptionContainerNode() {
        captionContainerNode.frame = captionContainerFrame()
        captionContainerNode.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        captionContainerNode.layerBacked = true
        addSubnode(captionContainerNode)
    }
    //标题 LabelNode
    var captionLabelNode = AttributedTextNode()
    func configureCaptionLabelNode() {
        captionLabelNode.configure(hotNewsInfo.title!, size: 16, textAlignment: .Center)
        let constrainedSize = CGSize(width: nodeSize.width, height: CGFloat.max)
        let labelNodeHeight: CGFloat = captionLabelNode.attributedString!.boundingRectWithSize(constrainedSize, options: .UsesFontLeading, context: nil).height
        let labelNodeYValue = captionContainerFrame().height / 2 - labelNodeHeight / 2
        captionLabelNode.frame = CGRect(x: 0, y: labelNodeYValue, width: nodeSize.width, height: labelNodeHeight)
        captionLabelNode.layerBacked = true
        captionContainerNode.addSubnode(captionLabelNode)
    }
}
//MARK: - ASNetworkImageNodeDelegate
extension ZYSecondCollectionViewCellNode: ASNetworkImageNodeDelegate {
    func imageNode(imageNode: ASNetworkImageNode, didLoadImage image: UIImage) {//图片加载完停止动画
        loadingIndicator.stopAnimating()
    }
}
//MARK: - 标题LabelNode文字格式
class AttributedTextNode: ASTextNode {
    func configure(text: String, size: CGFloat, color: UIColor = UIColor.whiteColor(), textAlignment: NSTextAlignment = .Left) {
        let mutableString = NSMutableAttributedString(string: text)
        let range = NSMakeRange(0, text.characters.count)
        mutableString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(size), range: range)
        mutableString.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        mutableString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
        attributedString = mutableString
    }
}