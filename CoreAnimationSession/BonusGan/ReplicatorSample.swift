//
//  ReplicatorSample.swift
//  CoreAnimationSession
//
//  Created by ambar.septian on 28/08/23.
//


import Foundation
import UIKit

internal class ReplicatorSampleViewController: UIViewController {
    private let replicatorLayer = CAReplicatorLayer()
    private let instanceLayer = CALayer()

    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        replicatorLayer.instanceCount = 20
        replicatorLayer.frame = CGRect(x: 50, y: 200, width: 300, height: 300)
        replicatorLayer.instanceDelay = 1.0 / TimeInterval(20)

        let angle = -CGFloat.pi * 2 / CGFloat(replicatorLayer.instanceCount)
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1)

        // Change color per instance
        let offsetColor = -(1 / Float(replicatorLayer.instanceCount))

        /*
         Uncomment to coloring the instance
         replicatorLayer.instanceGreenOffset = offsetColor
         replicatorLayer.instanceRedOffset = offsetColor
         */

        replicatorLayer.instanceAlphaOffset = offsetColor

        // Configure Instance Layer
        instanceLayer.frame = CGRect(x: 0, y: 0, width: 30, height: 8)
        instanceLayer.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).cgColor

        let yCenterOfReplicator = replicatorLayer.frame.height / 2
        let spacePerInstance: CGFloat = 20
        instanceLayer.position = CGPoint(x: spacePerInstance, y: yCenterOfReplicator)

        replicatorLayer.addSublayer(instanceLayer)
        view.layer.addSublayer(replicatorLayer)

        setupGesture()
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func onTap() {
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 1
        anim.toValue = 0
        anim.duration = 1.0
        anim.repeatCount = .infinity

        instanceLayer.add(anim, forKey: nil)
    }
}

@available(iOS 17, *)
#Preview {
    ReplicatorSampleViewController()
    
}
