//
//  DotLoadingView.swift
//  ChatGPT
//
//  Created by nirvana on 3/14/23.
//

import UIKit

class DotLoadingView: UIView {
    
    private let dotSize: CGFloat = 10
    private let dotSpacing: CGFloat = 30
    private let dotCount = Int((ChatDefinedFrame.screenWidth - 80) / 40)
    private let animationDuration: TimeInterval = 0.7
    
    private var dotLayers = [CALayer]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDotLayers()
    }
    
    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = UIColor.clear.cgColor
        animation.toValue = UIColor.white.cgColor
        animation.duration = animationDuration
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        for (index, dotLayer) in dotLayers.enumerated() {
            animation.beginTime = CACurrentMediaTime() + Double(index) * (animationDuration / Double(dotCount))
            dotLayer.add(animation, forKey: nil)
        }
    }
    
    func stopAnimating() {
        dotLayers.forEach { $0.removeAllAnimations() }
    }
    
    private func setupDotLayers() {
        for i in 0..<dotCount {
            let dotLayer = CALayer()
            dotLayer.frame = CGRect(x: CGFloat(i) * (dotSize + dotSpacing), y: 0, width: dotSize, height: dotSize)
            dotLayer.cornerRadius = dotSize / 3
            dotLayer.backgroundColor = UIColor.gray.cgColor
            layer.addSublayer(dotLayer)
            dotLayers.append(dotLayer)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDotLayers()
    }
}
