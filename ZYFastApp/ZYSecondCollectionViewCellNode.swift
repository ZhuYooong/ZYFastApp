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
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = floor((screenWidth / 2) - (spacing / 2))
        let itemHeight = floor((screenWidth / 3) - (spacing / 2))
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func viewFrame() -> CGRect {
        return CGRect(x: 0, y: 0, width: nodeSize.width, height: nodeSize.height)
    }
    override func calculateLayoutThatFits(_ constrainedSize: ASSizeRange) -> ASLayout {//加载界面布局
//        return ASLayout(layoutableObject: self, constrainedSizeRange: ASSizeRangeMake(nodeSize, nodeSize), size: nodeSize)
        return ASLayout(layoutElement: self, size: nodeSize)
    }
    //MARK: - 设置界面
    func configure() {
        backgroundColor = UIColor.black
        configureLoadingIndicator()
        configureImageNode()
        configureCaptionNodes()
    }
    func loadingIndicatorCenter() -> CGPoint {//加载图片
        let centerX = nodeSize.width / 2
        let centerY = nodeSize.height / 2 - captionContainerFrame().height / 2
        return CGPoint(x: centerX, y: centerY)
    }
    var loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    func configureLoadingIndicator() {
        loadingIndicator.center = loadingIndicatorCenter()
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
    var imageNode = ASNetworkImageNode()//imageNode
    func configureImageNode() {
        imageNode.frame = viewFrame()
        imageNode.delegate = self
        imageNode.url = URL(string: hotNewsInfo.thumbnail!)
        imageNode.isLayerBacked = true
        addSubnode(imageNode)
    }
    func configureCaptionNodes() {//标题栏
        configureCaptionBlurView()
        configureCaptionContainerNode()
        configureCaptionLabelNode()
    }
    func captionContainerFrame() -> CGRect {//标题栏尺寸
        let containerHeight: CGFloat = 35
        return CGRect(x: 0, y: nodeSize.height - containerHeight, width: nodeSize.width, height: containerHeight)
    }
    //毛玻璃
    var blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    func configureCaptionBlurView() {
        blurView.frame = captionContainerFrame()
        view.addSubview(blurView)
    }
    //标题界面背景颜色
    var captionContainerNode = ASDisplayNode()
    func configureCaptionContainerNode() {
        captionContainerNode.frame = captionContainerFrame()
        captionContainerNode.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        captionContainerNode.isLayerBacked = true
        addSubnode(captionContainerNode)
    }
    //标题 LabelNode
    var captionLabelNode = AttributedTextNode()
    func configureCaptionLabelNode() {
        captionLabelNode.configure(hotNewsInfo.title!, size: 16, textAlignment: .center)
        let constrainedSize = CGSize(width: nodeSize.width, height: CGFloat.greatestFiniteMagnitude)
        let labelNodeHeight: CGFloat = captionLabelNode.attributedText!.boundingRect(with: constrainedSize, options: .usesFontLeading, context: nil).height
        let labelNodeYValue = captionContainerFrame().height / 2 - labelNodeHeight / 2
        captionLabelNode.frame = CGRect(x: 0, y: labelNodeYValue, width: nodeSize.width, height: labelNodeHeight)
        captionLabelNode.isLayerBacked = true
        captionContainerNode.addSubnode(captionLabelNode)
    }
}
//MARK: - ASNetworkImageNodeDelegate
extension ZYSecondCollectionViewCellNode: ASNetworkImageNodeDelegate {
    func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {//图片加载完停止动画
        loadingIndicator.stopAnimating()
    }
}
//MARK: - 标题LabelNode文字格式
class AttributedTextNode: ASTextNode {
    func configure(_ text: String, size: CGFloat, color: UIColor = UIColor.white, textAlignment: NSTextAlignment = .left) {
        let mutableString = NSMutableAttributedString(string: text)
        let range = NSMakeRange(0, text.characters.count)
        mutableString.addAttribute(NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: size), range: range)
        mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        mutableString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: range)
        attributedText = mutableString
    }
}
