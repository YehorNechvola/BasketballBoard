//
//  CombinationsViewModel.swift
//  BasketballBoard
//
//  Created by Егор on 07.11.2022.
//

import Foundation

protocol CombinationsViewModelProtocol {
    func getCombinations()
}

class CombinationsViewModel: CombinationsViewModelProtocol {
    
    var router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
    
    func getCombinations() {
        
    }
}
