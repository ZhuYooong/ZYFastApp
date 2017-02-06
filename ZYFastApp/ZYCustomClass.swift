//
//  ZYCustomClass.swift
//  ZYFastApp
//
//  Created by MAC on 16/8/15.
//  Copyright © 2016年 TongBuWeiYe. All rights reserved.
//

import UIKit

class ZYCustomClass: NSObject {

}
//MARK: - 字符串的扩展
extension String {
    var length: Int {
        return characters.count
    }
    func rangeFromNSRange(_ nsRange : NSRange) -> Range<String.Index>? {
        if let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex) {
            if let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex) {
                if let from = String.Index(from16, within: self),
                    let to = String.Index(to16, within: self) {
                    return from ..< to
                }
            }
        }
        return nil
    }
    var md5: String! {//md5加密
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate(capacity: digestLen)
        return String(hash).uppercased()
    }
    func textHeightWithFont(_ font: UIFont, constrainedToSize size:CGSize) -> CGFloat {
        var textSize:CGSize!
        if size.equalTo(CGSize.zero) {
            let attributes = [NSFontAttributeName: font]
            textSize = self.size(attributes: attributes)
        } else {
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let attributes = [NSFontAttributeName: font]
            let stringRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
            textSize = stringRect.size
        }
        return textSize.height + 2
    }
}
//MARK: - HexColor的扩展
extension UIColor {
    public convenience init(_ value: Int) {
        let components = UIColor.getColorComponents(value)
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: 1.0)
    }
    public convenience init(_ value: Int, alpha: CGFloat) {
        let components = UIColor.getColorComponents(value)
        self.init(red: components.red, green: components.green, blue: components.blue, alpha: alpha)
    }
    public func alpha(_ value: CGFloat) -> UIKit.UIColor {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIKit.UIColor(red: red, green: green, blue: blue, alpha: value)
    }
    public func mix(with color: UIColor, amount: Float) -> UIColor {
        var comp1: [CGFloat] = Array(repeating: 0, count: 4);
        self.getRed(&comp1[0], green: &comp1[1], blue: &comp1[2], alpha: &comp1[3])
        var comp2: [CGFloat] = Array(repeating: 0, count: 4);
        color.getRed(&comp2[0], green: &comp2[1], blue: &comp2[2], alpha: &comp2[3])
        var comp: [CGFloat] = Array(repeating: 0, count: 4);
        for i in 0...3 {
            comp[i] = comp1[i] + (comp2[i] - comp1[i]) * CGFloat(amount)
        }
        return UIColor(red:comp[0], green: comp[1], blue: comp[2], alpha: comp[3])
    }
    private static func getColorComponents(_ value: Int) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let r = CGFloat(value >> 16 & 0xFF) / 255.0
        let g = CGFloat(value >> 8 & 0xFF) / 255.0
        let b = CGFloat(value & 0xFF) / 255.0
        return (r, g, b)
    }
}
enum ZYCustomColor: Int {//特定色值
    case tittleHeaderColor = 0x7acc8e
    case lightCyanColor = 0x0cb4b7
    case darkCyanColor = 0x1a9593
    case blueLineColor = 0x67bcd1
}
