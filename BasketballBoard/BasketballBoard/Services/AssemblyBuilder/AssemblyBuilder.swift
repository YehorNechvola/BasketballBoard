//
//  Router.swift
//  BasketballBoard
//
//  Created by Егор on 06.11.2022.
//

import Foundation

//MARK: - AssemblyBuilderProtocol

protocol AssemblyBuilderProtocol {
    func createBoardModule() -> BoardViewController
    func createCombinationsModule(router: RouterProtocol) -> CombinationsViewController
}

class AssemblyBuilder: AssemblyBuilderProtocol {
    
    //MARK: - Methods
    
    func createBoardModule() -> BoardViewController {
        let viewModel = BoardViewModel()
        let viewController = BoardViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    func createCombinationsModule(router: RouterProtocol) -> CombinationsViewController {
        let viewModel = CombinationsViewModel(router: router)
        let viewController = CombinationsViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
