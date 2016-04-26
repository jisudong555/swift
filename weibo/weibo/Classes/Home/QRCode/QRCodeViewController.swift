//
//  QRCodeViewController.swift
//  weibo
//
//  Created by jisudong on 16/4/15.
//  Copyright © 2016年 jisudong. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController{
    /// 自定义tabbar
    @IBOutlet weak var customTabBar: UITabBar!
    /// 冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    /// 扫描容器高度约束
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    /// 冲击波视图顶部约束
    @IBOutlet weak var scanLineConstraint: NSLayoutConstraint!
    /// 扫描结果
    @IBOutlet weak var resultLabel: UILabel!
    
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.frame = UIScreen.mainScreen().bounds
        
        customTabBar.selectedItem = customTabBar.items![0]
        customTabBar.delegate = self
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        startCustomAnimation()
        startScan()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startCustomAnimation()
    }
    

    @IBAction func closeButtonClick(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func qrCodeCardAction(sender: AnyObject)
    {
        let vc = QRCodeCardViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func startCustomAnimation()
    {
        self.scanLineConstraint.constant = -self.containerHeightConstraint.constant
        self.scanLineView.layoutIfNeeded()
        UIView.animateWithDuration(5.0) { 
            self.scanLineConstraint.constant = self.containerHeightConstraint.constant
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.scanLineView.layoutIfNeeded()
        };
    }
    
    private func startScan()
    {
        // 判断是否能够将输入添加到会话中
        if !session.canAddInput(deviceInput) {
            return
        }
        
        // 判断是否能够将输出添加到会话中
        if !session.canAddOutput(output) {
            return
        }
        
        // 将输入和输出添加到会话中
        session.addInput(deviceInput)
        print(output.availableMetadataObjectTypes)
        session.addOutput(output)
        print(output.availableMetadataObjectTypes)
        
        // 设置输出能够解析的数据类型（一定要在输出对象添加到会话之后设置，否则会报错）
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        print(output.availableMetadataObjectTypes)
        
        // 设置输出对象的代理，只要解析成功就会通知代理
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        // 添加到预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        
        // 开始扫描
        session.startRunning()
    }

    
    // MARK: - 懒加载
        /// 会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    
        /// 拿到输入设备
    private lazy var deviceInput: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: device)
            return input
        } catch
        {
            print(error)
            return nil
        }
    
    }()
    
        /// 拿到输出设备
    private lazy var output: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    
        /// 创建预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.session)
        layer.frame = UIScreen.mainScreen().bounds
        
        return layer
    }()
    
        /// 创建用于绘制边线的图层
    private lazy var drawLayer: CALayer = {
        let layer = CALayer()
        layer.frame = UIScreen.mainScreen().bounds
        return layer
    }()
  
}

extension QRCodeViewController: UITabBarDelegate, AVCaptureMetadataOutputObjectsDelegate
{
    // MARK: - UITabBarDelegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.tag == 1 {
            self.containerHeightConstraint.constant = 300
        } else {
            self.containerHeightConstraint.constant = 150
        }
        
        self.scanLineView.layer.removeAllAnimations()
        
        startCustomAnimation()
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    // 只要解析到数据就会调用
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!)
    {
        // 1.清空图层
        clearCorners()
        
        // 2.获取扫描到的数据
        // 注意：要使用stringValue
        print(metadataObjects.last?.stringValue)
        resultLabel.text = metadataObjects.last?.stringValue
        
        // 3.获取扫描到二维码的位置
        for object in metadataObjects
        {
            // 判断当前获取到的数据，是否是机器可识别的类型
            if object is AVMetadataMachineReadableCodeObject
            {
                let codeObject = previewLayer.transformedMetadataObjectForMetadataObject(object as! AVMetadataObject) as! AVMetadataMachineReadableCodeObject
                
                // 绘制图形
                drawCorners(codeObject)
            }
        }
    }
    
    private func clearCorners()
    {
        // 判断drawLayer上是否有其他图层
        if drawLayer.sublayers == nil || drawLayer.sublayers?.count == 0
        {
            return
        }
        
        for subLayer in drawLayer.sublayers!
        {
            subLayer.removeFromSuperlayer()
        }
    }
    
    private func drawCorners(codeObject: AVMetadataMachineReadableCodeObject)
    {
        if codeObject.corners.isEmpty
        {
            return
        }
        
        // 1.创建一个图层
        let layer = CAShapeLayer()
        layer.lineWidth = 4
        layer.strokeColor = UIColor.redColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        // 2.创建路径
        let path = UIBezierPath()
        var point = CGPointZero
        var index: Int = 0
        
        // 移动到第一个点
        CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
        path.moveToPoint(point)
        
        // 移动到其他点
        while index < codeObject.corners.count
        {
            CGPointMakeWithDictionaryRepresentation((codeObject.corners[index++] as! CFDictionaryRef), &point)
        }
        
        // 关闭路径
        path.closePath()
        
        // 绘制路径
        layer.path = path.CGPath
        
        // 将绘制好的图层添加到drawLayer上
        drawLayer.addSublayer(layer)
    }
    


}


