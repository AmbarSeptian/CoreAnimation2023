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
        
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale.z")
        scaleAnim.toValue = 1.1
        scaleAnim.duration = 1
        scaleAnim.delegate = self
        
        gradientLayer?.transform = CATransform3DMakeScale(1.1, 1.1, 1.0)
        
        runRotateAnimation()
        gradientLayer?.add(scaleAnim, forKey: "circleScale")
        
    }
    
    func runRotateAnimation() {
        let rotateAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnim.fromValue = 0
        rotateAnim.toValue = CGFloat.pi * 2
        rotateAnim.duration = 2
        rotateAnim.beginTime = CACurrentMediaTime() + 1
        gradientLayer?.add(rotateAnim, forKey: nil)
        self.shapeLayer?.lineDashPattern = [10, 5]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let scaleAnim = CABasicAnimation(keyPath: "transform.scale.z")
            scaleAnim.toValue = 1
            scaleAnim.duration = 1
            
            self.gradientLayer?.add(scaleAnim, forKey: nil)
            self.gradientLayer?.transform = CATransform3DMakeScale(1, 1, 1.0)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let dashAnim = CABasicAnimation(keyPath: "lineDashPhase")
            dashAnim.toValue = 1
            dashAnim.duration = 2
            
            self.shapeLayer?.add(dashAnim, forKey: nil)
        }
    }
}

extension CircleView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
   
        if shapeLayer?.animation(forKey: "circleScale") == anim {
            runRotateAnimation()
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
