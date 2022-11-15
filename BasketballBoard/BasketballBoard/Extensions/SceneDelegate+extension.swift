//
//  SceneDelegate+extension.swift
//  BasketballBoard
//
//  Created by Егор on 06.11.2022.
//

import UIKit

//MARK: - Entry point helper

extension SceneDelegate {
    
    func makeEntryPoint(windowScene: UIWindowScene) {
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let mainNavigationController = UINavigationController()
        let boardNavigationController = UINavigationController()
        let combinationsNavigationController = UINavigationController()
        let navigationControllers = [boardNavigationController, combinationsNavigationController]
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .brown
        tabBarController.viewControllers = navigationControllers
        tabBarController.tabBar.tintColor = .black
        UserDefaults.standard.set(tabBarController.tabBar.bounds.height, forKey: "tabBarHeight")
        
        mainNavigationController.viewControllers = [tabBarController]
        
        let assemblyBuilder = AssemblyBuilder()
        let router = Router(mainNavigationController: mainNavigationController,
                            navigationControllers: navigationControllers ,
                            assemblyBuilder: assemblyBuilder)
        router.initializeBoardViewController()
        router.initializeCombinationViewController()
        
        window?.rootViewController = mainNavigationController
        window?.makeKeyAndVisible()
    }
}
