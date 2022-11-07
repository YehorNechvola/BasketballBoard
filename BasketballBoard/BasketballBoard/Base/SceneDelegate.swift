//
//  SceneDelegate.swift
//  BasketballBoard
//
//  Created by Егор on 06.11.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        makeEntryPoint(windowScene: windowScene)
    }
}

