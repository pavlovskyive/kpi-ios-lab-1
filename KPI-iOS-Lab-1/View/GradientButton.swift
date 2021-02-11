//
//  GradientButton.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 11.02.2021.
//

import UIKit
import SnapKit

class GradientButton: UIButton {

    public var colors = (UIColor.systemBlue, UIColor.systemPurple) {
        didSet {
            setupBackground()
        }
    }

    lazy var gradientView = GradientView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientView.frame = bounds

        snp.makeConstraints { (make) -> Void in

            guard let titleLabel = titleLabel else { return }

            make.width.equalTo(titleLabel).offset(80)
            make.height.equalTo(titleLabel).offset(40)
        }
    }

    private func setup() {

        let touch = UILongPressGestureRecognizer(target: self, action: #selector(handleTouch))
        touch.minimumPressDuration = 0

        addGestureRecognizer(touch)

        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)

        insertSubview(gradientView, at: 0)

        gradientView.layer.cornerRadius = 8
        gradientView.layer.masksToBounds = true

        setupBackground()
    }

    private func setupBackground() {
        gradientView.colors = colors
        gradientView.startPoint = CGPoint(x: 0, y: 0)
        gradientView.endPoint = CGPoint(x: 0, y: 1)
    }
}

extension GradientButton {

    @objc private func handleTouch(gesture: UILongPressGestureRecognizer) {

        if gesture.state == .began {
            UIView.animate(
                withDuration: 0.2,
                delay: 0,
                options: .curveEaseInOut,
                animations: {
                    self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                    self.alpha = 0.8
                })
        } else if gesture.state == .ended {
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 15,
                options: .curveEaseInOut,
                animations: {
                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                    self.alpha = 1
                })
        }
    }
}
