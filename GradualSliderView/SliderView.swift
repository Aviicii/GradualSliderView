//
//  SliderView.swift
//  GradualSliderView
//
//  Created by Avicii on 2023/10/12.
//

import UIKit
import SnapKit

class SliderView: UIView {
    
    public var sliderValueCallback:((_ value:Float)->())?
    
    var titles:[String] = [] {
        didSet {
            setupViews()
            self.sliderValueEnd(self.slider)
        }
    }
    var sliderValue:Float = 0.0 {
        didSet {
            self.slider.value = self.sliderValue
            self.sliderValueEnd(self.slider)
        }
    }
    private var views:[GradientView] = []
    
    private lazy var slider: ESSlider = {
        self.slider = .init()
        self.slider.h = 8
        self.slider.minimumValue = 0
        self.slider.maximumValue = 100
        self.slider.value = 0
        self.slider.minimumTrackTintColor = UIColor.hex(hexString: "12B3FF")
        self.slider.maximumTrackTintColor = .gray
        self.slider.setThumbImage(.init(named: "rececving_car_oil_ic"), for: .normal)
        self.slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        self.slider.addTarget(self, action: #selector(sliderValueEnd), for: .touchUpInside)
        return self.slider
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        self.backgroundColor = .white
        addSubview(self.slider)
        
        slider.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(12)
            make.height.equalTo(30)
        }
    }
    
    private func setupViews() {
        let w:CGFloat = frame.width
        for i in 0..<titles.count {
            
            let v:GradientView = .init()
            v.text = titles[i]
            addSubview(v)
            let spaceW:CGFloat = CGFloat(w - 14 - CGFloat(18 * titles.count)) / CGFloat(titles.count - 1)
            let space = CGFloat(7 + 18 * i) + spaceW * CGFloat(i)
            v.snp.makeConstraints { make in
                make.top.equalTo(7)
                make.width.equalTo(18)
                make.height.equalTo(40)
                make.left.equalTo(space)
            }
            views.append(v)
        }
        self.bringSubviewToFront(slider)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let sliderValue:CGFloat = CGFloat(sender.value)
        let lineLong:CGFloat = CGFloat(slider.maximumValue) / CGFloat(views.count - 1)
        for (index, v) in views.enumerated() {
            let targetPoint:CGFloat = lineLong * CGFloat(index)
            if (sliderValue - v.frame.width / 2) >= (targetPoint - v.frame.width) {
                v.progress = (sliderValue - (targetPoint - v.frame.width / 2)) / (v.frame.width / 2)
            }else{
                v.progress = 0
            }
        }
    }
    
    @objc func sliderValueEnd(_ sender: UISlider) {
        let sliderValue = Float(sender.value)
        let segmentSize:Float = Float(sender.maximumValue) / Float(views.count - 1)
        // 计算最近的点
        let nearestValue = round(sliderValue / segmentSize) * segmentSize
        sender.setValue(nearestValue, animated: true)
        
        let lineLong:Float = Float(slider.maximumValue) / Float(views.count - 1)
        for (index, v) in views.enumerated() {
            let targetPoint:Float = lineLong * Float(index)
            if nearestValue == targetPoint {
                v.progress = 1
                break
            }
        }
        
        sliderValueCallback?(nearestValue)
    }
    
}


private class ESSlider: UISlider {
    
    var h:CGFloat = 5.0
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return .init(x: 0, y: 0, width: CGRectGetWidth(self.frame), height: h)
    }
    
}

private class GradientCircleView: UIView {
    var progress: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setConfig()
    }
    
    private func setConfig() {
        backgroundColor = .gray
        layer.cornerRadius = 9
        layer.masksToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setFillColor(UIColor.hex(hexString: "12B3FF").cgColor)
        let fillRect = CGRect(x: 0, y: 0, width: rect.size.width * progress, height: rect.size.height)
        context.clip(to: fillRect)
        context.setBlendMode(.sourceIn)
        context.fill(rect)
    }
}

private class GradientLab: UILabel {
    var progress: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setConfig()
    }
    
    private func setConfig() {
        text = "123"
        font = .boldSystemFont(ofSize: 10)
        textColor = .gray
        textAlignment = .center
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setFillColor(UIColor.hex(hexString: "12B3FF").cgColor)
        let fillRect = CGRect(x: 0, y: 0, width: rect.size.width * progress, height: rect.size.height)
        context.clip(to: fillRect)
        context.setBlendMode(.sourceIn)
        context.fill(rect)
    }
}

private class GradientView: UIView {
    
    var progress: CGFloat = 0.0 {
        didSet {
            self.v.progress = progress
            self.l.progress = progress
        }
    }
    
    var text: String = "" {
        didSet {
            self.l.text = text
        }
    }
    
    var textColor: UIColor = .gray {
        didSet {
            self.l.textColor = textColor
        }
    }
    
    let v:GradientCircleView = .init(frame: .init(x: 0, y: 0, width: 18, height: 18))
    let l:GradientLab = .init(frame: .init(x: 0, y: 0, width: 18, height: 12))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        addSubview(v)
        addSubview(l)
        
        v.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(18)
        }
        
        l.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
}

