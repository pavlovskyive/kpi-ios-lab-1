//
//  UIColor.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 11.02.2021.
//

import UIKit

extension UIColor {
    static func randomGradient() -> (UIColor, UIColor) {
        guard let gradientName = Constants.gradientNames.randomElement() else {
            return (.white, .white)
        }

        guard let startColor = UIColor(named: "\(gradientName)Start"),
              let endColor = UIColor(named: "\(gradientName)End") else {
            return (.white, .white)
        }

        return (startColor, endColor)
    }
}
