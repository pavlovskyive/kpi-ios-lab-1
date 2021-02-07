//
//  TabBarController.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 06.02.2021.
//

import UIKit

class TabBarController: UITabBarController {

    // MARK: - Variables

    typealias Tab = (title: String, image: UIImage?, viewController: UIViewController)

    lazy var tabs: [Tab] = [
        ("Main", UIImage(systemName: "house"), MainViewController()),
        ("Drawing", UIImage(systemName: "pencil.and.outline"), DrawingViewController()),
        ("Books", UIImage(systemName: "book"), BooksViewController())
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Setups

    private func setupTabBar() {
        var tabBarList = [UIViewController]()

        tabs.forEach { tabBarList.append(setupTab(tab: $0)) }

        viewControllers = tabBarList
    }

    func setupTab(tab: Tab) -> UIViewController {

        let tag = viewControllers?.count ?? 0
        let tabBarItem = UITabBarItem(title: tab.title, image: tab.image, tag: tag)
        tab.viewController.tabBarItem = tabBarItem

        return tab.viewController
    }
}
