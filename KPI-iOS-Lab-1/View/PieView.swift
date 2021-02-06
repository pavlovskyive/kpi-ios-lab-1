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
        (value: 10, color: .systemOrange),
        (value: 80, color: .systemBlue)
    ]
    
    override func draw(_ rect: CGRect) {

        let context = UIGraphicsGetCurrentContext()

        let radius = min(frame.size.width, frame.size.height) * 0.5
        let viewCenter = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        let valueCount = segments.reduce(0, {$0 + $1.value})
        var startAngle = -CGFloat.pi * 0.5

        for segment in segments {

            let endAngle = startAngle + 2 * .pi * (segment.value / valueCount)
            
            context?.setFillColor(segment.color.cgColor)
            context?.move(to: viewCenter)
            context?.addArc(
                center: viewCenter,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false)
            context?.fillPath()
            
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
