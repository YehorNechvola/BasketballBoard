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
        let view = BoardViewController()
        view.viewModel = viewModel
        return view
    }
    
    func createCombinationsModule(router: RouterProtocol) -> CombinationsViewController {
        let viewModel = CombinationsViewModel(router: router)
        let view = CombinationsViewController()
        view.viewModel = viewModel
        return view
    }
}
