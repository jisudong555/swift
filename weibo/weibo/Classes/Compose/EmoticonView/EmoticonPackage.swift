//
//  EmoticonPackage.swift
//  EmoticonView
//
//  Created by 纪素东 on 16/9/12.
//  Copyright © 2016年 纪素东. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {
    
    var id: String?
    var group_name_cn: String?
    var emoticons: [Emoticon]?
    
    class func loadPackages() -> [EmoticonPackage]
    {
        var packages = [EmoticonPackage]()
        
        let pk = EmoticonPackage(id: "")
        pk.group_name_cn = "最近"
        pk.emoticons = [Emoticon]()
        pk.appendEmtyEmoticons()
        packages.append(pk)
        
        let path = NSBundle.mainBundle().pathForResource("emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        let dict = NSDictionary(contentsOfFile: path)!
        let dictArray = dict["packages"] as! [[String: AnyObject]]
        for d in dictArray
        {
            let package = EmoticonPackage(id: d["id"]! as! String)
            packages.append(package)
            package.loadEmoticon()
            package.appendEmtyEmoticons()
        }
        return packages
    }
    
    init(id: String) {
        self.id = id
    }

    func appendEmtyEmoticons()
    {
        let count = (emoticons?.count)! % 21
        for _ in count..<20 {
            emoticons?.append(Emoticon(isRemoveButton: false))
            
        }
        emoticons?.append(Emoticon(isRemoveButton: true))
    }
    
    func appendEmoticons(emoticon: Emoticon)
    {
        if emoticon.isRemoveButton
        {
            return
        }
        
        let contains = emoticons!.contains(emoticon)
        if !contains
        {
            emoticons?.removeLast()
            emoticons?.append(emoticon)
        }
        
        var result = emoticons?.sort({ (e1, e2) -> Bool in
            return e1.times > e2.times
        })
        
        if !contains
        {
            result?.removeLast()
            result?.append(Emoticon(isRemoveButton: true))
            emoticons = result
        }
    }
    
    func loadEmoticon()
    {
        let emoticonDict = NSDictionary(contentsOfFile: infoPath("info.plist"))!
        
        group_name_cn = emoticonDict["group_name_cn"] as? String
        let dictArray = emoticonDict["emoticons"] as! [[String: String]]
        emoticons = [Emoticon]()
        var index = 0
        for dict in dictArray
        {
            if index == 20
            {
                emoticons?.append(Emoticon(isRemoveButton: true))
                index = 0
            }
            emoticons?.append(Emoticon(dict: dict, id: id!))
            index += 1
        }
    }
    
    func infoPath(fileName: String) -> String
    {
        return (EmoticonPackage.emoticonPath().stringByAppendingPathComponent(id!) as NSString).stringByAppendingPathComponent(fileName)
    }
    
    class func emoticonPath() -> NSString
    {
        return (NSBundle.mainBundle().bundlePath as NSString).stringByAppendingPathComponent("Emoticons.bundle")
    }
}

class Emoticon: NSObject {
    
    var chs: String?
    var png: String? {
        didSet {
            imagePath = (EmoticonPackage.emoticonPath().stringByAppendingPathComponent(id!) as NSString).stringByAppendingPathComponent(png!)
        }
    }
    
    var code: String? {
        didSet {
            // 1.从字符串中取出十六进制的数
            // 创建一个扫描器, 扫描器可以从字符串中提取我们想要的数据
            let scanner = NSScanner(string: code!)
            
            // 2.将十六进制转换为字符串
            var result: UInt32 = 0
            scanner.scanHexInt(&result)
            
            // 3.将十六进制转换为emoji字符串
            let character = Character(UnicodeScalar(result))
            emojiStr = "\(character)"
        }
    }
    
    var emojiStr: String?
    var id: String?
    var imagePath: String?
    var isRemoveButton: Bool = false
    var times: Int = 0
    
    init(isRemoveButton: Bool)
    {
        super.init()
        self.isRemoveButton = isRemoveButton
    }
    
    init(dict: [String: String], id: String) {
        super.init()
        self.id = id
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
}
