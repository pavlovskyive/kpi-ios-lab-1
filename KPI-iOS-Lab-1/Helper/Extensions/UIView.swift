//
//  UIView.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 11.02.2021.
//

import UIKit

extension UIView {
    public func appearWithAnimation(delay: Double = 0) {
        transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        alpha = 0

        UIView.animate(withDuration: 0.5,
                       delay: delay,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 2,
                       options: .curveEaseInOut) {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.alpha = 1
        }
    }
}
