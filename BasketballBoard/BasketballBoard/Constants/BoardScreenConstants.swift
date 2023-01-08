//
//  BoardScreenConstants.swift
//  BasketballBoard
//
//  Created by Егор on 15.11.2022.
//

import UIKit

enum BoardScreenConstants {
    static let boardViewTopAnchor = UIScreen.main.bounds.height * 0.11
    static let boardHeight = (UIScreen.main.bounds.height * 0.875) - (UserDefaults.standard.value(forKey: "tabBarHeight") as! CGFloat)
    static let boardWidth = UIScreen.main.bounds.width
    static let playerWidth: CGFloat = 28
    
    static let pointFirstPlayer = CGPoint(x: boardWidth * 0.5, y: boardHeight * 0.55)
    static let pointSecondPlayer = CGPoint(x: boardWidth * 0.85, y: boardHeight * 0.4)
    static let pointThirdPlayer = CGPoint(x: boardWidth * 0.15, y: boardHeight * 0.4)
    static let pointFourthPlayer = CGPoint(x: boardWidth * 0.85, y: boardHeight * 0.2)
    static let pointFifthPlayer = CGPoint(x: boardWidth * 0.15, y: boardHeight * 0.2)
    
    static let pointFirstDefender = CGPoint(x: boardWidth * 0.5, y: boardHeight * 0.55 - 45)
    static let pointSecondDefender = CGPoint(x: boardWidth * 0.85 - 35, y: boardHeight * 0.4 - 20)
    static let pointThirdDefender = CGPoint(x: boardWidth * 0.15 + 35, y: boardHeight * 0.4 - 20)
    static let pointFourthDefender = CGPoint(x: boardWidth * 0.85 - 35, y: boardHeight * 0.2)
    static let pointFifthDefender = CGPoint(x: boardWidth * 0.15 + 35, y: boardHeight * 0.2)
    
    static let pointBallImageView = CGPoint(x: pointFirstPlayer.x + 13, y: pointFirstPlayer.y - 15)
    static let pointOfBasket = CGPoint(x:  boardWidth * 0.5, y: UIScreen.main.bounds.height * 0.18)
}

enum BoardScreenImages {
    static let boardImage = UIImage(named: "basketBoard")
    static let ballImage = UIImage(named: "ball")
    static let pointGuardImage = UIImage(named: "numberOne")
    static let shootingGuardImage = UIImage(named: "numberTwo")
    static let smallForwardImage = UIImage(named: "numberThree")
    static let powerForwardImage = UIImage(named: "numberFour")
    static let centerImage = UIImage(named: "numberFive")
}
