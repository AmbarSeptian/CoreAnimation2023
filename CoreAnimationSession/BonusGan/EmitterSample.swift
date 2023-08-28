//
//  EmitterSample.swift
//  CoreAnimationSession
//
//  Created by ambar.septian on 28/08/23.
//

import Foundation
import UIKit

internal class EmitterViewController: UIViewController {
    private let emitterLayer = CAEmitterLayer()

    override internal func viewDidLoad() {
        super.viewDidLoad()

        let cell = CAEmitterCell()
        cell.birthRate = 2
        cell.lifetime = 5.0
        cell.velocity = 100
        cell.velocityRange = 50
        cell.emissionLongitude = CGFloat.pi
        cell.spinRange = 5
        cell.scale = 0.5
        cell.scaleRange = 0.25 
        cell.color = UIColor.red.cgColor
        cell.alphaSpeed = -0.025
        
        let icon: UIImage? = UIImage.heartFilled
        cell.contents = icon?.cgImage

        emitterLayer.emitterCells = [cell]
        view.layer.addSublayer(emitterLayer)

        view.backgroundColor = .white
    }

    override internal func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        emitterLayer.emitterPosition = CGPoint(x: view.frame.width / 2.0, y: -50)
        emitterLayer.emitterShape = .line
        emitterLayer.emitterSize = CGSize(width: view.frame.width, height: 1)
        emitterLayer.renderMode = .additive
    }
}


@available(iOS 17, *)
#Preview {
    EmitterViewController()
    
}
