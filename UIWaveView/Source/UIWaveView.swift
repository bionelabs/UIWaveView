//
//  WaveAmimationView.swift
//  WaveAnimationView
//
//  Created by Cao Phuoc Thanh on 4/23/20.
//  Copyright © 2020 Cao Phuoc Thanh. All rights reserved.
//  Edit From Source: https://github.com/yourtion/YXWaveView/blob/master/YXWaveView/YXWaveView.swift

import UIKit

open class UIWaveView: UIView {
    
    open var waveCurvature: CGFloat = 1.5
    
    open var waveSpeed: CGFloat =  0.6
    
    open var waveHeight: CGFloat =  8
    
    open var progress:Float {
        get{ return _progress }
        set{
            guard newValue >= 0 && newValue <= 100 else {  return }
            self._progress = newValue
        }
    }
    
    open var borderColor: UIColor = UIColor.orange {
        didSet{
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
    open var color: UIColor = UIColor.orange {
        didSet{
            self.realWaveColor = self.color
            if self.color == UIColor.clear {
                self.maskWaveColor = self.realWaveColor
            } else {
                self.maskWaveColor = self.color.withAlphaComponent(0.5)
            }
        }
    }
    
    /// real wave color
    private var realWaveColor: UIColor = UIColor.orange {
        didSet {
            self.realWaveLayer.fillColor = self.realWaveColor.cgColor
        }
    }
    /// mask wave color
    private var maskWaveColor: UIColor = UIColor.orange.withAlphaComponent(0.5) {
        didSet {
            self.maskWaveLayer.fillColor = self.maskWaveColor.cgColor
        }
    }
    /// float over View
    open var overView: UIView?
    
    fileprivate var _progress: Float = 0 {
        didSet{
            var frame = self.bounds
            frame.origin.y = frame.size.height - _waveHeight/3 - (frame.size.height/100*CGFloat(_progress))
            if _progress == 0 {
                frame.origin.y = frame.size.height + _waveHeight
            }
            if _progress == 100 {
                frame.origin.y = -_waveHeight
            }
            frame.size.height = self.frame.size.height //_waveHeight
            maskWaveLayer.frame = frame
            realWaveLayer.frame = frame
        }
    }
    
    /// wave timmer
    fileprivate var timer: CADisplayLink?
    /// real aave
    fileprivate var realWaveLayer :CAShapeLayer = CAShapeLayer()
    /// mask wave
    fileprivate var maskWaveLayer :CAShapeLayer = CAShapeLayer()
    
    /// offset
    fileprivate var offset :CGFloat = 0
    
    fileprivate var _waveCurvature: CGFloat = 0
    fileprivate var _waveSpeed: CGFloat = 0
    fileprivate var _waveHeight: CGFloat = 0
    fileprivate var _starting: Bool = false
    fileprivate var _stoping: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.realWaveLayer.fillColor = self.realWaveColor.cgColor
        self.maskWaveLayer.fillColor = self.maskWaveColor.cgColor
        
        self.layer.addSublayer(self.realWaveLayer)
        self.layer.addSublayer(self.maskWaveLayer)
        
        
    }
    
    
    public convenience init(frame: CGRect, color:UIColor) {
        self.init(frame: frame)
        self.realWaveColor = color
        self.maskWaveColor = color.withAlphaComponent(0.5)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func addOverView(_ view: UIView) {
        overView = view
        overView?.center = self.center
        overView?.frame.origin.y = self.frame.height - (overView?.frame.height)!
        self.addSubview(overView!)
    }
    
    open func start() {
        if !_starting {
            _stop()
            _starting = true
            _stoping = false
            _waveHeight = 0
            _waveCurvature = 0
            _waveSpeed = 0
            
            timer = CADisplayLink(target: self, selector: #selector(wave))
            timer?.add(to: RunLoop.current, forMode: .common)
        }
    }
    
    open func _stop(){
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }
    
    open func stop(){
        if !_stoping {
            _starting = false
            _stoping = true
        }
    }
    
    @objc func wave() {
        
        if _starting {
            if _waveHeight < waveHeight {
                _waveHeight = _waveHeight + waveHeight/100.0
                var frame = self.bounds
                frame.origin.y = frame.size.height - _waveHeight/3 - (frame.size.height/100*CGFloat(_progress))
                if _progress == 0 {
                    frame.origin.y = frame.size.height + _waveHeight
                }
                if _progress == 100 {
                    frame.origin.y = -_waveHeight
                }
                frame.size.height = self.frame.size.height //_waveHeight
                maskWaveLayer.frame = frame
                realWaveLayer.frame = frame
                _waveCurvature = _waveCurvature + waveCurvature / 100.0
                _waveSpeed = _waveSpeed + waveSpeed / 100.0
            } else {
                _starting = false
            }
        }
        
        if _stoping {
            if _waveHeight > 0 {
                _waveHeight = _waveHeight - waveHeight/50.0
                var frame = self.bounds
                frame.origin.y = frame.size.height - _waveHeight/3 - (frame.size.height/100*CGFloat(_progress))
                if _progress == 0 {
                    frame.origin.y = frame.size.height + _waveHeight
                }
                if _progress == 100 {
                    frame.origin.y = -_waveHeight
                }
                frame.size.height = _waveHeight
                maskWaveLayer.frame = frame
                realWaveLayer.frame = frame
                _waveCurvature = _waveCurvature - waveCurvature / 50.0
                _waveSpeed = _waveSpeed - waveSpeed / 50.0
            } else {
                _stoping = false
                _stop()
            }
        }
        
        offset += _waveSpeed
        
        let width = frame.width
        let height = CGFloat(_waveHeight)
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: height))
        
        var y: CGFloat = 0
        
        let maskpath = CGMutablePath()
        maskpath.move(to: CGPoint(x: 0, y: height))
        
        let offset_f = Float(offset * 0.045)
        let waveCurvature_f = Float(0.01 * _waveCurvature)
        
        for x in 0...Int(width) {
            y = height * CGFloat(sinf( waveCurvature_f * Float(x) + offset_f))
            path.addLine(to: CGPoint(x: CGFloat(x), y: y))
            maskpath.addLine(to: CGPoint(x: CGFloat(x), y: -y))
        }
        
        if (overView != nil) {
            let centX = self.bounds.size.width/2
            let centY = height * CGFloat(sinf(waveCurvature_f * Float(centX)  + offset_f))
            let center = CGPoint(x: centX , y: centY + self.bounds.size.height - overView!.bounds.size.height/2)
            overView?.center = center
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width, y: height + self.bounds.size.height))
        path.addLine(to: CGPoint(x: 0, y: height + self.bounds.size.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        
        maskpath.addLine(to: CGPoint(x: width, y: height))
        maskpath.addLine(to: CGPoint(x: width, y: height + self.bounds.size.height))
        maskpath.addLine(to: CGPoint(x: 0, y: height + self.bounds.size.height))
        maskpath.addLine(to: CGPoint(x: 0, y: 0))
        
        maskpath.closeSubpath()
        path.closeSubpath()
        
        
        self.realWaveLayer.path = path
        
        self.maskWaveLayer.path = maskpath
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        var frame = rect
        frame.origin.y = frame.size.height
        maskWaveLayer.frame = frame
        realWaveLayer.frame = frame
        layer.masksToBounds = true
        layer.borderColor = self.borderColor.cgColor
        layer.borderWidth = 3
        self.start()
    }
}
