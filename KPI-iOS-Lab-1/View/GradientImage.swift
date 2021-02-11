//
//  GradientImage.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 11.02.2021.
//

import UIKit

class GradientImage: UIView {

    public var colors = (UIColor.systemBlue, UIColor.systemPurple) {
        didSet {
            setupBackground()
        }
    }

    lazy var imageMaskView: UIImageView = {

        let image = UIImage(systemName: "books.vertical")

        let imageView = UIImageView(frame: bounds)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    lazy var gradientView = GradientView(frame: bounds)

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
        imageMaskView.frame = bounds
    }

    private func setup() {
        gradientView.mask = imageMaskView

        addSubview(gradientView)

        setupBackground()
    }

    func setupBackground() {
        gradientView.colors = colors
    }
}
