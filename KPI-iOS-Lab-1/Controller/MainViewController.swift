//
//  MainViewController.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 06.02.2021.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Variables

    lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .body)

        label.numberOfLines = 3

        let topText = "Павловський Всеволод"
        let middleText = "Група ІП-84"
        let bottomText = "ЗК ІП-8417"

        label.text = "\(topText)\n\(middleText)\n\(bottomText)"

        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
    }

    // MARK: - Setups

    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
