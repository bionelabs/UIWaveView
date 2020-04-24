//
//  ViewController.swift
//  Demo
//
//  Created by Cao Phuoc Thanh on 4/24/20.
//  Copyright © 2020 Cao Phuoc Thanh. All rights reserved.
//

import UIKit
import UIWaveView

// MARK: Controller
class ViewController: UIViewController {
    
    fileprivate var waterView: UIWaveView = UIWaveView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Start wave
        waterView.start()
        timerUpdateProgress()
    }
    
    private func timerUpdateProgress() {
        var p: Float = 100
        self.waterView.progress = p
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (timer) in
            p += 0.5
            self.waterView.progress = p
            if p >= 100 {
                p = 0
            }
        }
    }
}

// MARK: View
extension ViewController {
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .white
        
        waterView.layer.cornerRadius = 100
        waterView.layer.masksToBounds = true
        waterView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add WaveView
        self.view.addSubview(waterView)
        
        // set visual
        let constraintH = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[v(200)]",
            options: [],
            metrics: nil,
            views: ["v": waterView])
        
        let constraintV = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[v(200)]",
            options: [],
            metrics: nil,
            views: ["v": waterView])
        
        let constraintCenterYs = [NSLayoutConstraint(
            item: waterView,
            attribute: .centerY, relatedBy: .equal,
            toItem: view, attribute: .centerY,
            multiplier: 1.0, constant: 0.0)]
        
        let constraintCenterXs = [NSLayoutConstraint(
            item: waterView,
            attribute: .centerX, relatedBy: .equal,
            toItem: view, attribute: .centerX,
            multiplier: 1.0, constant: 0.0)]
        
        self.view.addConstraints(constraintCenterXs)
        self.view.addConstraints(constraintCenterYs)
        self.view.addConstraints(constraintH)
        self.view.addConstraints(constraintV)
    }
}



