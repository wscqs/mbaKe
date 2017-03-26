//
//  BarWaveView.swift
//  FMDemo
//
//  Created by mba on 17/1/19.
//  Copyright © 2017年 mbalib. All rights reserved.
//

import UIKit
protocol CutBarWaveViewDelegate: NSObjectProtocol{
    func changceTimeLabel(cutBarWaveView: CutBarWaveView, centerX: CGFloat, thumbPointXIndex: Int)
    //    func changceEndDraggingTimeLabel(cutBarWaveView: CutBarWaveView, centerX: CGFloat, thumbPointXIndex: Int)
}

class CutBarWaveView: UIView {
    
    var playHightView: UIView = UIView()
    var playBackView: UIView = UIView()
//    var play
    weak var delegate: CutBarWaveViewDelegate?
    
    var pointXArray: Array<CGFloat>? {
        didSet{
            guard pointXArray != nil else {
                return
            }
            setNeedsDisplay()
        }
    }
    var minSecond: CGFloat = 3.0
    
    fileprivate var slider = UISlider()
    fileprivate var scrollView = UIScrollView()
    fileprivate var thumbBarImage: UIImageView = UIImageView()
    fileprivate var thumbPointXIndex: Int = 0
    
    var widthScaling: CGFloat = 1.0
    let heightScaling: CGFloat = 0.9
    
    let kLineWidth: CGFloat = 2.0
    let spaceW: CGFloat = 2.0 * 2
    
    var boundsH: CGFloat = 0
    var boundsW: CGFloat = 0
    var scrollViewContenW: CGFloat = 0
    
    /// 边框及底部颜色
    var waveBackgroundColor = UIColor.colorWithHexString("2b95ff") {
        didSet {
            layer.borderWidth = 3.0
            layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
            backgroundColor = waveBackgroundColor
        }
    }
    
    /// 声波的颜色.colorWithHexString("2e80d1")
    var waveStrokeColor = UIColor.colorWithHexString("2e80d1") {
        didSet {
            
        }
    }
    
    var waveHightStrokeColor = UIColor.white {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setupView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        frame = bounds
        backgroundColor = waveBackgroundColor
        layer.cornerRadius = 3.0
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        layer.masksToBounds = true
        
        addSubview(scrollView)
        scrollView.addSubview(playBackView)
        scrollView.addSubview(playHightView)
        
        
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        
        addSubview(thumbBarImage)
        thumbBarImage.image = #imageLiteral(resourceName: "record_volume_control_ico")
        thumbBarImage.contentMode = .scaleAspectFit
        
        thumbBarImage.isUserInteractionEnabled = true
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(actionPan(sender:)))
        thumbBarImage.addGestureRecognizer(panGes)
        
        //        scrollView.addSubview(slider)
        //        slider.setThumbImage(#imageLiteral(resourceName: "sound_slider_thum"), for: .normal)
        slider.isUserInteractionEnabled = false
        
    }
    
    
    func actionPan(sender: UIPanGestureRecognizer) {
        let transPoint = sender.translation(in: self)
        let transX = transPoint.x
        var newCenter = CGPoint(x: (sender.view?.center.x)! + transX, y: (sender.view?.center.y)!)
        // 设置边界
        let space = 5 * spaceW
        newCenter.x = max(space, newCenter.x)
        newCenter.x = min(min(scrollViewContenW - space, boundsW - space), newCenter.x)
        sender.view?.center = newCenter
        sender.setTranslation(CGPoint.zero, in: self)
        updateCutView(isEndDragging: true)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let pointXArray = pointXArray  else {
            return
        }
        if pointXArray.count == 0 {return}
        let spaceTop: CGFloat = 2
        boundsH = self.bounds.size.height - spaceTop
        boundsW = self.bounds.size.width
        
        let maxiBarTrackImageW = CGFloat(pointXArray.count) * spaceW
        scrollViewContenW = maxiBarTrackImageW
        
        
        let path = UIBezierPath()
        path.lineWidth = kLineWidth
        for i in 0 ..< pointXArray.count {
            let x = CGFloat(i) * spaceW
            path.move(to: CGPoint(x: x, y: boundsH))
            path.addLine(to: CGPoint(x: x, y: boundsH * (1 - pointXArray[i])))
        }
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = self.waveStrokeColor.cgColor
        shapeLayer.path = path.cgPath
        playBackView.layer.addSublayer(shapeLayer)
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.strokeColor = self.waveHightStrokeColor.cgColor
        shapeLayer1.path = path.cgPath
        playHightView.layer.addSublayer(shapeLayer1)
        
        // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        let imageSize = CGSize(width: maxiBarTrackImageW, height: boundsH)
        //        UIGraphicsBeginImageContextWithOptions(imageSize, false, 20)
        print(imageSize.debugDescription)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.synchronize()
        context.scaleBy(x: 1, y: 1)
        //        context.setLineWidth(kLineWidth)
        //
        //        for i in 0 ..< pointXArray.count {
        //            let x = CGFloat(i) * spaceW
        //            context.move(to: CGPoint(x: x, y: boundsH))
        //            context.addLine(to: CGPoint(x: x, y: boundsH * (1 - pointXArray[i])))
        //        }
        //
        //        context.setAlpha(1.0)
        //        context.setShouldAntialias(true) // 去除锯齿
        //        context.setStrokeColor(self.waveStrokeColor.cgColor)
        //        context.setFillColor(self.waveStrokeColor.cgColor)
        //        context.strokePath()
        
        
        
        //        playHightView.backgroundColor = UIColor.green
        //        playHightView.layer.backgroundColor = UIColor.white.cgColor
        
        let maxiTrackImage = UIGraphicsGetImageFromCurrentImageContext()
        
        context.setFillColor(self.waveHightStrokeColor.cgColor)
        UIRectFillUsingBlendMode(CGRect(origin: CGPoint.zero, size: imageSize), .sourceAtop)
        //        UIRectFillUsingBlendMode(bounds, .sourceAtop)
        
        
        let minxTrackImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        slider.maximumValue = Float(pointXArray.count)
        slider.minimumValue = 0
        slider.frame = CGRect(x: 0, y: 0, width: maxiBarTrackImageW, height: boundsH)
        DispatchQueue.main.async {
            self.render(maxiTrackImage: maxiTrackImage, minxTrackImage: minxTrackImage)
        }
        
    }
    
    func render(maxiTrackImage:UIImage?, minxTrackImage: UIImage?) {
        
        slider.setMaximumTrackImage(maxiTrackImage?.resizableImage(withCapInsets: .zero), for: .normal)
        slider.setMinimumTrackImage(minxTrackImage?.resizableImage(withCapInsets: .zero), for: .normal)
        
        
        
        scrollView.contentSize = slider.frame.size
        var cgRect = bounds
        cgRect.origin.y = 4
        scrollView.frame = cgRect
        
        if scrollViewContenW - boundsW > 0 {
            scrollView.contentOffset = CGPoint(x: scrollViewContenW - boundsW, y: 0)
        }
        
        initThumbRect()
        updateCutView()
    }
    
    
    fileprivate func initThumbRect() {
        //        // 初始位置 在结束前3秒
        //        minSecond = 3
        var thumbBarX: CGFloat = 0
        if scrollViewContenW > boundsW {
            thumbBarX = boundsW - spaceW * 5 * minSecond
        } else {
            thumbBarX = scrollView.contentSize.width - spaceW * 5 * minSecond
        }
        thumbBarImage.frame = CGRect(x: thumbBarX, y: 2, width: 40, height: bounds.height)
    }
    
    fileprivate func updateCutView(isEndDragging: Bool? = false) {
        updatePlayViewFrame()
        let point = thumbBarImage.convert(CGPoint(x: -thumbBarImage.bounds.width/2, y: 0), from: scrollView)
        thumbPointXIndex = Int(-point.x / spaceW)
        slider.value = Float(thumbPointXIndex)
        
        let transPoint = thumbBarImage.convert(CGPoint(x: 0, y: 0), from: self)
        
        delegate?.changceTimeLabel(cutBarWaveView: self, centerX: -transPoint.x + thumbBarImage.bounds.size.width/2, thumbPointXIndex: thumbPointXIndex)
        
        //        if isEndDragging! {
        //            delegate?.changceEndDraggingTimeLabel(cutBarWaveView: self, centerX: -transPoint.x + thumbBarImage.bounds.size.width/2, thumbPointXIndex: thumbPointXIndex)
        //        } else {
        //            delegate?.changceTimeLabel(cutBarWaveView: self, centerX: -transPoint.x + thumbBarImage.bounds.size.width/2, thumbPointXIndex: thumbPointXIndex)
        //        }
    }
}

// MARK: - open API
extension CutBarWaveView {
    /// 传入播放的进度
    func setPlayProgress(thumbPointXIndex :Int) {
        self.thumbPointXIndex = thumbPointXIndex
        slider.value = Float(thumbPointXIndex)
//        updatePlayViewFrame()
        setPlayStatusFrame()
    }
    
    
    func updatePlayViewFrame() {
        playHightView.frame = CGRect(x: 0, y: 0, width: -thumbBarImage.convert(CGPoint(x: -thumbBarImage.bounds.width/2, y: 0), from: scrollView).x, height: boundsH)
        playHightView.layer.masksToBounds = true
        playBackView.frame = CGRect(x: 0, y: 0, width: scrollViewContenW, height: boundsH)
    }
    
    func setPlayStatusFrame() {
        playHightView.frame = CGRect(x: 0, y: 0, width: CGFloat(thumbPointXIndex * 4), height: boundsH)
    }
}

extension CutBarWaveView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCutView()
    }
    
    //    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //        updateCutView(isEndDragging: true)
    //    }
}

