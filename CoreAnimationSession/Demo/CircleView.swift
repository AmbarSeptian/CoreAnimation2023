//
//  ViewController.swift
//  CoreAnimationSession
//
//  Created by ambar.septian on 17/08/23.
//

import AsyncDisplayKit
import UIKit

internal class CircleDemoViewController: ASViewController<ASDisplayNode> {
    let box: CircleNode = {
        let node = CircleNode()
        node.style.preferredSize = CGSize(width: 200, height: 200)
        return node
    }()

    init() {
        super.init(node: ASDisplayNode())
        node.automaticallyManagesSubnodes = true

        node.layoutSpecBlock = { [weak self] _, _ in
            guard let self = self else { return ASLayoutSpec() }

            return ASCenterLayoutSpec(centeringOptions: .XY, child: self.box)
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(self.onTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func onTap() {
        box.runAnimation()
    }
}


internal class CircleNode: ASDisplayNode {
    private let gradientLayer = CAGradientLayer()
    private let shapeLayer = CAShapeLayer()
    private let animationKeys = "AnimationKeys"
    private let lineWidth: CGFloat = 5
    
    enum AnimationKey: String {
        case rotate = "rotateAnimation"
        case scale = "scaleAnimation"
    }
    
    override func didLoad() {
        super.didLoad()
        setupLayer()
    }
    
    override func layout() {
        super.layout()
        
        // Update frame here
        gradientLayer.frame = bounds
        shapeLayer.path = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                       radius: bounds.midX - lineWidth,
                                       startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: false).cgPath
        shapeLayer.frame = bounds
    }

    private func setupLayer() {
        // Step 1: Setup Gradient
        gradientLayer.colors = [UIColor.customBlue, UIColor.customGreen].map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        
        // Step 2: Setup CAShape Layer
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 5
        
        // Step 3: Add Gradient Layer
        layer.addSublayer(gradientLayer)
        
        // Step 4: Masking the layer
        gradientLayer.mask = shapeLayer
    }
    
    internal func runAnimation() {
        
        let scaleKeyFrameAnim = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleKeyFrameAnim.values = [1, 0.95, 1.1, 1]
        scaleKeyFrameAnim.duration = 3
        scaleKeyFrameAnim.keyTimes = [0, 0.2, 0.5, 1]
        scaleKeyFrameAnim.delegate = self
        scaleKeyFrameAnim.setValue(AnimationKey.scale.rawValue, forKey: animationKeys)
        
        let rotateAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnim.fromValue = 0
        rotateAnim.toValue = CGFloat.pi * 2
        rotateAnim.duration = 1
        rotateAnim.beginTime = CACurrentMediaTime() + 1
        rotateAnim.delegate = self
        rotateAnim.setValue(AnimationKey.rotate.rawValue, forKey: animationKeys)
        
        self.gradientLayer.add(scaleKeyFrameAnim, forKey: nil)
        self.gradientLayer.add(rotateAnim, forKey: nil)
    }
    
}

extension CircleNode: CAAnimationDelegate {
    func animationDidStart(_ anim: CAAnimation) {
        guard let key = anim.value(forKey: animationKeys) as? String else {
            return
        }
        
        switch key {
        case AnimationKey.scale.rawValue:
            break
        case AnimationKey.rotate.rawValue:
            shapeLayer.lineDashPattern = [50,10,20,10]
            
        default:
            break
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        guard let key = anim.value(forKey: animationKeys) as? String else {
            return
        }
        
        switch key {
        case AnimationKey.scale.rawValue:
            break
        case AnimationKey.rotate.rawValue:
            shapeLayer.lineDashPattern = nil
        default:
            break
        }
    }
}

@available(iOS 17, *)
#Preview {
    CircleDemoViewController()
}
