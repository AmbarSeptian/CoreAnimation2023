//
//  ViewController.swift
//  CoreAnimationSession
//
//  Created by ambar.septian on 17/08/23.
//

import UIKit


internal class CircleView: UIView {
    private var gradientLayer: CAGradientLayer?
    private var shapeLayer: CAShapeLayer?
    
    init() {
        super.init(frame: .zero)

        frame = .init(x: 0, y: 0, width: 200, height: 200)
        setupLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayer() {
        layer.masksToBounds = false
        let rect = frame
        
        // Step 1: Create Gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.blue.withAlphaComponent(0.5), UIColor.green.withAlphaComponent(0.5)].map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = rect
        gradientLayer.masksToBounds = false
        
        // Step 3: Create CAShape Layer
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.midX - 10, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false).cgPath
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 5
        shapeLayer.frame = rect
        shapeLayer.masksToBounds = false

        
        // Step 2: Add Gradient Layer
        layer.addSublayer(gradientLayer)
        
        // Step 4: Masking the layer
        gradientLayer.mask = shapeLayer
        
        self.gradientLayer = gradientLayer
        self.shapeLayer = shapeLayer
        
    }
    
    internal func runAnimation() {
        
        let scaleKeyFrameAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleKeyFrameAnim.values = [1, 1.3, 1]
        scaleKeyFrameAnim.duration = 3
        scaleKeyFrameAnim.keyTimes = [0, 0.5, 1]
        scaleKeyFrameAnim.delegate = self
        scaleKeyFrameAnim.setValue("scaleAnim", forKey: "animationKeys")
        

        let rotateAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnim.fromValue = 0
        rotateAnim.toValue = CGFloat.pi * 2
        rotateAnim.duration = 1
        rotateAnim.beginTime = CACurrentMediaTime() + 1
        rotateAnim.delegate = self
        rotateAnim.setValue("rotateAnim", forKey: "animationKeys")
        
        self.gradientLayer?.add(scaleKeyFrameAnim, forKey: nil)
        self.gradientLayer?.add(rotateAnim, forKey: nil)
    }
    
}

extension CircleView: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        guard let key = anim.value(forKey: "animationKeys") as? String else {
            return
        }
        
        switch key {
        case "scaleAnim":
            break
        case "rotateAnim":
            shapeLayer?.lineDashPattern = [30, 10]
        default:
            break
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        guard let key = anim.value(forKey: "animationKeys") as? String else {
            return
        }
        
        switch key {
        case "scaleAnim":
            break
        case "rotateAnim":
            shapeLayer?.lineDashPattern = nil
        default:
            break
        }
    }
}

@available(iOS 17, *)
#Preview {
    let containerView = UIView()
    let circleView = CircleView()
    containerView.addSubview(circleView)
    
    circleView.frame.origin = CGPoint(x: 100, y: 300)
    // For animation demo purpose
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        circleView.runAnimation()
    }
    
    
    
    return containerView
}
