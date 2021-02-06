//
//  PieView.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 06.02.2021.
//

import UIKit

class PieView: UIView {

    typealias Segment = (value: CGFloat, color: UIColor)

    lazy var segments: [Segment] = [
        (value: 5, color: .brown),
        (value: 5, color: .systemTeal),
        (value: 10, color: .orange),
        (value: 80, color: .blue)
    ]

    override func draw(_ rect: CGRect) {

        let center = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
        let radius = min(bounds.size.width, bounds.size.height) / 2.0
        let total: CGFloat = segments.reduce(0) { $0 + $1.value } / (2 * .pi)
        var startAngle = CGFloat(0)

        for segment in segments {
            let endAngle = startAngle + segment.value / total

            let slice = UIBezierPath()
            slice.addArc(withCenter: center,
                         radius: radius,
                         startAngle: startAngle,
                         endAngle: endAngle,
                         clockwise: true)

            slice.addArc(withCenter: center,
                         radius: radius / 2,
                         startAngle: endAngle,
                         endAngle: startAngle,
                         clockwise: false)

            slice.close()

            segment.color.setFill()
            slice.fill()

            startAngle = endAngle
         }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
