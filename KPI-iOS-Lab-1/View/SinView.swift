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
        
        path.move(to: CGPoint(x: width / 2, y: 0))
        path.addLine(to: CGPoint(x: width / 2, y: height))
        
        path.move(to: CGPoint(x: 0, y: height / 2))
        path.addLine(to: CGPoint(x: width, y: height / 2))
        
        UIColor.systemBlue.withAlphaComponent(0.5).setStroke()
        path.stroke()
    }
    
    private func drawSin(rect: CGRect) {
        let width = rect.width
        let height = rect.height

        let origin = CGPoint(x: width * 0.2 / 2, y: height / 2)

        let path = UIBezierPath()
        path.move(to: origin)

        for angle in stride(from: 10.0, through: 360, by: 10.0) {
            let x = origin.x + CGFloat(angle / 360) * width * 0.8
            let y = origin.y - CGFloat(sin(angle / 180 * .pi)) * height * 0.2
            path.addLine(to: CGPoint(x: x, y: y))
        }

        UIColor.black.setStroke()
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
