//
//  DrawingViewController.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 06.02.2021.
//

import UIKit
import SnapKit

class DrawingViewController: UIViewController {

    lazy var segmentedControl: UISegmentedControl = {
        let items = ["Function", "Pie Chart"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.addTarget(
            self,
            action: #selector(segmentedControlValueChanged(sender:)),
            for: .valueChanged)

        return control
    }()

    lazy var views = [
        SinView(),
        PieView()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(segmentedControl)

        views.reversed().forEach { view.addSubview($0) }

        setupConstraints()
    }

    private func setupConstraints() {
        segmentedControl.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(view.snp.topMargin).inset(50)
            make.centerX.equalToSuperview()
        }

        views.forEach { view in
            view.snp.makeConstraints { (make) -> Void in
                make.center.equalToSuperview()
                make.width.equalTo(view.snp.height)
                make.top.greaterThanOrEqualTo(self.segmentedControl.snp.bottom).offset(20)
                make.bottom.lessThanOrEqualTo(self.view.snp.bottomMargin).inset(20)
                make.height.equalToSuperview().priority(.low)
                make.width.lessThanOrEqualToSuperview().inset(20)
            }
        }
    }

    @objc
    private func segmentedControlValueChanged(sender: UISegmentedControl) {
        view.bringSubviewToFront(views[sender.selectedSegmentIndex])
    }
}
