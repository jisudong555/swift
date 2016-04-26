//
//  QRCodeCardViewController.swift
//  weibo
//
//  Created by jisudong on 16/4/23.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit

class QRCodeCardViewController: UIViewController {

    // MARK: - 懒加载
    private lazy var iconView: UIImageView = UIImageView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        title = "我的名片"
        view.addSubview(iconView)
        iconView.snp_makeConstraints { (make) in
            make.center.equalTo(view)
        }
        let string = "素东播客"
        let qrCodeImage = createQRCodeImage(string)
        
        iconView.image = qrCodeImage
    }
    
    private func createQRCodeImage(stringData: String) -> UIImage?
    {
        // 1.创建滤镜
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        // 2.还原滤镜的默认属性
        filter?.setDefaults()
        
        // 3.设置需要生成二维码的数据
        filter?.setValue(stringData.dataUsingEncoding(NSUTF8StringEncoding), forKey: "inputMessage")
        
        // 4.从滤镜中取出生成的图片
        let ciImage =  filter?.outputImage
        
        // 5.生成高清的图片
        let bgImage = createNonInterpolatedUIImageFormCIImage(ciImage!, size: CGSize(width: 300, height: 300))
        
        let icon = UIImage(named: "nange.jpg")
        
        let newImage = createImage(bgImage, iconImage: icon!)
        
        return newImage
    }
    
    /**
     根据CIImage生成指定大小的高清UIImage
     
     - parameter ciImage: 指定的CIImage
     - parameter size:    指定的大小
     
     - returns: 生成的图片
     */
    private func createNonInterpolatedUIImageFormCIImage(ciImage: CIImage, size: CGSize) -> UIImage
    {
        let extent: CGRect = CGRectIntegral(ciImage.extent)
        let scale = min(size.width/CGRectGetWidth(extent), size.height/CGRectGetHeight(extent))
        
        let width = CGRectGetWidth(extent) * scale
        let height = CGRectGetHeight(extent) * scale
        let cs: CGColorSpaceRef = CGColorSpaceCreateDeviceGray()!
        let bitmapRef = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, cs, 0)!
        let context = CIContext(options: nil)
        let bitmapImage: CGImage = context.createCGImage(ciImage, fromRect: extent)
        CGContextSetInterpolationQuality(bitmapRef, CGInterpolationQuality.None)
        CGContextScaleCTM(bitmapRef, scale, scale)
        CGContextDrawImage(bitmapRef, extent, bitmapImage)
        
        let scaledImage: CGImageRef = CGBitmapContextCreateImage(bitmapRef)!
        
        return UIImage(CGImage: scaledImage)
    }
    
    /**
     合成图片
     
     - parameter bgImage:   背景图片
     - parameter iconImage: 头像
     */
    private func createImage(bgImage: UIImage, iconImage: UIImage) -> UIImage
    {
        // 开启图片上下文
        UIGraphicsBeginImageContext(bgImage.size)
        
        // 绘制背景图片
        bgImage.drawInRect(CGRect(origin: CGPointZero, size: bgImage.size))
        
        // 绘制头像
        let width: CGFloat = 50
        let height: CGFloat = width
        let x = (bgImage.size.width - width) * 0.5
        let y = (bgImage.size.height - height) * 0.5
        iconImage.drawInRect(CGRect(x: x, y: y, width: width, height: height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
        
    }

}
