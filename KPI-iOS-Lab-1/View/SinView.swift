//
//  SinView.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 06.02.2021.
//

import UIKit

class SinView: UIView {

    override func draw(_ rect: CGRect) {
        drawCoordinates(rect: rect)
        drawSin(rect: rect)
    }
    
    private func drawCoordinates(rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let path = UIBezierPath()
        
        // Arrow Y
        path.move(to: CGPoint(x: width / 2, y: 0))
        path.addLine(to: CGPoint(x: width / 2 - 5, y: 10))
        path.move(to: CGPoint(x: width / 2, y: 0))
        path.addLine(to: CGPoint(x: width / 2 + 5, y: 10))
        
        // Line Y
        path.move(to: CGPoint(x: width / 2, y: 0))
        path.addLine(to: CGPoint(x: width / 2, y: height))
        
        // Line X
        path.move(to: CGPoint(x: 0, y: height / 2))
        path.addLine(to: CGPoint(x: width, y: height / 2))
        
        // Arrow X
        path.addLine(to: CGPoint(x: width - 10, y: height / 2 - 5))
        path.move(to: CGPoint(x: width, y: height / 2))
        path.addLine(to: CGPoint(x: width - 10, y: height / 2 + 5))
        
        // Mark Y: 1
        path.move(to: CGPoint(x: width / 2 - 5, y: height / 2 - height / 12))
        path.addLine(to: CGPoint(x: width / 2 + 5, y: height / 2 - height / 12))
        
        // Mark X: 1
        path.move(to: CGPoint(x: width / 2 + width / 12, y: height / 2 - 5))
        path.addLine(to: CGPoint(x: width / 2 + width / 12, y: height / 2 + 5))
        
        UIColor.secondaryLabel.setStroke()
        path.stroke()
    }
    
    private func drawSin(rect: CGRect) {
        let width = rect.width
        let height = rect.height

        let origin = CGPoint(x: 0, y: height / 2)

        let path = UIBezierPath()
        path.move(to: origin)

        for angle in stride(from: 10.0, through: 720, by: 10.0) {
            let x = origin.x + CGFloat(angle / 720) * width
            let y = origin.y - CGFloat(sin(angle / 180 * .pi)) * height / 12
            path.addLine(to: CGPoint(x: x, y: y))
        }

        UIColor.systemBlue.setStroke()
        path.stroke()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
