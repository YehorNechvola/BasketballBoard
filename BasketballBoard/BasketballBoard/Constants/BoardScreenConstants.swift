//
//  BoardScreenConstants.swift
//  BasketballBoard
//
//  Created by Егор on 15.11.2022.
//

import UIKit

enum BoardScreenConstants {
    static let boardViewTopAnchor = UIScreen.main.bounds.height * 0.125
    static let boardHeight = (UIScreen.main.bounds.height * 0.875) - (UserDefaults.standard.value(forKey: "tabBarHeight") as! CGFloat)
    static let playerWidth: CGFloat = 25
    
    static let xPointFirstPlayer = UIScreen.main.bounds.width * 0.5
    static let xPointSecondPlayer = UIScreen.main.bounds.width * 0.15
    static let xPointThirdPlayer = UIScreen.main.bounds.width * 0.85
    static let xPointFourthPlayer = UIScreen.main.bounds.width * 0.15
    static let xPointFifthPlayer = UIScreen.main.bounds.width * 0.85
    
    static let yPointFirstPlayer = boardHeight * 0.55
    static let yPointSecondPlayer = boardHeight * 0.4
    static let yPointThirdPlayer = boardHeight * 0.4
    static let yPointFourthPlayer = boardHeight * 0.2
    static let yPointFifthPlayer = boardHeight * 0.2
}
