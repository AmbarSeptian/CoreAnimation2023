//
//  DemoSimpleView.swift
//  CoreAnimationSession
//
//  Created by ambar.septian on 28/08/23.
//

import AsyncDisplayKit
import Foundation

internal class DemoSimpleViewController: ASViewController<ASDisplayNode> {
    private let box: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = .orange
        node.style.preferredSize = CGSize(width: 200, height: 200)
        return node
    }()

    init() {
        super.init(node: ASDisplayNode())
        node.automaticallyManagesSubnodes = true

        node.layoutSpecBlock = { [weak self] _, _ in
            guard let self = self else { return ASLayoutSpec() }

            
            let stack = ASStackLayoutSpec(direction: .vertical, spacing: 16, justifyContent: .center, alignItems: .center, children: [self.box])

            return ASCenterLayoutSpec(horizontalPosition: .center, verticalPosition: .center, sizingOption: [], child: stack)
        }
    }

    internal required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override internal func viewDidLoad() {
        super.viewDidLoad()
        title = "Basic Animation"

        // Layer Configuration
        box.layer.cornerRadius = 8
        box.layer.shadowRadius = 4

        // Add SubLayer
        let subLayer = CALayer()
        subLayer.frame = .init(x: 20, y: 20, width: 100, height: 100)
        subLayer.backgroundColor = UIColor.green.cgColor
        box.layer.addSublayer(subLayer)
    }

    private func runAnimation() {
        // DEMO THIS CODE
        let animation = CABasicAnimation()
        animation.fromValue = box.layer.opacity
        animation.toValue = 0.3
        animation.duration = 2
        animation.keyPath = "opacity"

        // DON'T DO THIS
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false

//        box.layer.opacity = 0.3
        print(box.layer.animationKeys())
        box.layer.add(animation, forKey: "anim\(UUID().uuidString)")
    }
}


@available(iOS 17, *)
#Preview {
    let vc = DemoSimpleViewController()
    return vc
    
}
