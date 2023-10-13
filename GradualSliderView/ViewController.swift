//
//  ViewController.swift
//  GradualSliderView
//
//  Created by Avicii on 2023/10/12.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let v:SliderView = .init(frame: .init(x: UIScreen.main.bounds.size.width * 0.2,
                                              y: 200,
                                              width: UIScreen.main.bounds.size.width * 0.6,
                                              height: 60))
        /*
         底部数值
         */
        v.titles = ["11", "22", "33", "44", "55"]
        /*
         初始值
         */
        v.sliderValue = 20
        v.sliderValueCallback = { value in
            debugPrint(value)
        }
        /*
         上面第一次先设置初始值，在执行回调 --> 没有回调
         下面第一次先执行回调，再设置初始值 --> 有回调
         请根据业务需求来选择
        
        v.sliderValueCallback = { value in
            debugPrint(value)
        }
        v.sliderValue = 20
         
         */
        view.addSubview(v)
    }
    
}

extension UIColor {
    
    convenience init(r:UInt32 ,g:UInt32 , b:UInt32 , a:CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: a)
    }
    
    class func hex(hexString: String) -> UIColor {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        if cString.count < 6 { return UIColor.black }
        
        let index = cString.index(cString.endIndex, offsetBy: -6)
        let subString = cString[index...]
        if cString.hasPrefix("0X") { cString = String(subString) }
        if cString.hasPrefix("#") { cString = String(subString) }
        
        if cString.count != 6 { return UIColor.black }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(r: r, g: g, b: b)
    }
    
}

