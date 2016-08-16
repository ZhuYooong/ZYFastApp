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
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
            return from ..< to
        }
        return nil
    }
    var md5: String! {//md5加密
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.dealloc(digestLen)
        return String(hash).uppercaseString
    }
    func textHeightWithFont(font: UIFont, constrainedToSize size:CGSize) -> CGFloat {
        var textSize:CGSize!
        if CGSizeEqualToSize(size, CGSizeZero) {
            let attributes = [NSFontAttributeName: font]
            textSize = self.sizeWithAttributes(attributes)
        } else {
            let option = NSStringDrawingOptions.UsesLineFragmentOrigin
            let attributes = [NSFontAttributeName: font]
            let stringRect = self.boundingRectWithSize(size, options: option, attributes: attributes, context: nil)
            textSize = stringRect.size
        }
        return textSize.height + 2
    }
}
enum ZYCustomColor: Int {//特定色值
    case tittleHeaderColor = 0x7acc8e
    case lightCyanColor = 0x0cb4b7
    case darkCyanColor = 0x1a9593
    case blueLineColor = 0x67bcd1
}