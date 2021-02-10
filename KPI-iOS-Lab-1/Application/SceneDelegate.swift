//
//  SceneDelegate.swift
//  KPI-iOS-Lab-1
//
//  Created by Vsevolod Pavlovskyi on 06.02.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let tabBarController = TabBarController()

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        self.window = window
    }
}
