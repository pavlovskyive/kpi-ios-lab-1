//
//  GradientView.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 11.02.2021.
//

import UIKit

class GradientView: UIView {

    public var colors = (UIColor.systemBlue, UIColor.systemPurple) {
        didSet {
            setup()
        }
    }

    public var startPoint: CGPoint? {
        didSet {

            guard let startPoint = startPoint else {
                return
            }

            gradientLayer.startPoint = startPoint
        }
    }

    public var endPoint: CGPoint? {
        didSet {
            guard let endPoint = endPoint else {
                return
            }

            gradientLayer.endPoint = endPoint
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let gradientLayer = CAGradientLayer()

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = bounds
    }

    private func setup() {

        gradientLayer.colors = [colors.0.cgColor, colors.1.cgColor]

        gradientLayer.locations = [0.0, 1.0]
        layer.addSublayer(gradientLayer)

        let randomX = Int.random(in: 0...1)
        let randomY = Int.random(in: 0...1)

        gradientLayer.startPoint = CGPoint(x: randomX, y: randomY)
        gradientLayer.endPoint = CGPoint(x: 1 - randomX, y: 1 - randomY)
    }
}
