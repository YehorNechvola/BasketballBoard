//
//  Router.swift
//  BasketballBoard
//
//  Created by Егор on 06.11.2022.
//

import UIKit

// MARK: - Protocols

protocol RouterMainProtocol {
    var mainNavigationController: UINavigationController { get set }
    var boardNavigationController: UINavigationController { get set }
    var combinationsNavigationController: UINavigationController { get set }
    var assemblyBuilder: AssemblyBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMainProtocol {
    func initializeBoardViewController()
    func initializeCombinationViewController()
}

class Router: RouterProtocol {
    
    //MARK: - Properties
    
    var mainNavigationController: UINavigationController
    var boardNavigationController: UINavigationController
    var combinationsNavigationController: UINavigationController
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    //MARK: - Initializer
    
    init(mainNavigationController: UINavigationController,
         navigationControllers: [UINavigationController],
         assemblyBuilder: AssemblyBuilderProtocol) {
        self.mainNavigationController = mainNavigationController
        
        self.boardNavigationController = navigationControllers[0]
        self.combinationsNavigationController = navigationControllers[1]
        self.assemblyBuilder = assemblyBuilder
        
        let boardTabBarItem = UITabBarItem(title: "Board", image: UIImage(named: "board"), tag: 0)
        let combinationsTabBarItem = UITabBarItem(title: "Combinations", image: UIImage(named: "whistle"), tag: 1)
        boardNavigationController.tabBarItem = boardTabBarItem
        combinationsNavigationController.tabBarItem = combinationsTabBarItem
        self.mainNavigationController.isNavigationBarHidden = true
    }
    
    //MARK: - Methods
    
    func initializeBoardViewController() {
        if let boardViewController = assemblyBuilder?.createBoardModule() {
            boardNavigationController.viewControllers = [boardViewController]
        }
    }
    
    func initializeCombinationViewController() {
        if let combinationsViewController = assemblyBuilder?.createCombinationsModule(router: self) {
            combinationsNavigationController.viewControllers = [combinationsViewController]
        }
    }
}
