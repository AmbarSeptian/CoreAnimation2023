//
//  DemoSimpleView.swift
//  CoreAnimationSession
//
//  Created by ambar.septian on 28/08/23.
//

import AsyncDisplayKit
import Foundation

internal class DemoSimpleViewController: ASViewController<ASDisplayNode> {
    let box: BoxNode = {
        let node = BoxNode()
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

class BoxNode: ASDisplayNode {
    let subLayer = CALayer()
    
    override init() {
        super.init()
        backgroundColor = .orange
    }
    
    override func didLoad() {
        super.didLoad()
        
        // Create SubLayer
        subLayer.frame = .init(x: 20, y: 20, width: 100, height: 100)
        subLayer.cornerRadius = 8
        subLayer.shadowRadius = 4
        subLayer.backgroundColor = UIColor.green.cgColor
        
        // Add SubLayer
        layer.addSublayer(subLayer)
    }
    
    func runAnimation() {
        // Simple Animation
        let animation = CABasicAnimation()
        animation.toValue = 0
        animation.duration = 3
        animation.keyPath = "opacity"
        
        // DON'T DO THIS
//         animation.fillMode = .forwards
//         animation.isRemovedOnCompletion = false

         // Do this instead
//          subLayer.opacity = 0
        
        subLayer.add(animation, forKey: nil)
    }
}


@available(iOS 17, *)
#Preview {
    DemoSimpleViewController()
}
