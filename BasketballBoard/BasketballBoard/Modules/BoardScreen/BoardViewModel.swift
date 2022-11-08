//
//  BoardViewModel.swift
//  BasketballBoard
//
//  Created by Егор on 06.11.2022.
//

import Foundation

protocol BoardViewModelProtocol {
    func placePlayersOnBoard(parentView: Any)
    func saveCoordinatesOfPlayer()
}

class BoardViewModel: BoardViewModelProtocol {
    var movingViewManager: MovingViewProtocol?
    
    func placePlayersOnBoard(parentView: Any) {
        movingViewManager = MovingView()
        movingViewManager?.placeViews(on: parentView)
    }
    
    func saveCoordinatesOfPlayer() {
    
    }
}
