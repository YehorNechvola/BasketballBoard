//
//  BasketBoardInstaller.swift
//  BasketballBoard
//
//  Created by Егор on 22.11.2022.
//

import UIKit

enum StateOfDefenders {
    case isHidden
    case isShowed
    case isHiding
}

enum TypeOfPlayer {
    case attacking
    case defending
}

//MARK: - BasketBoardInstallerProtocol

protocol BasketBoardInstallerProtocol {
    func setupBoard()
    func addPlayer(type: TypeOfPlayer, backgroundColor: UIColor)
    func showOrHideDefenders()
    func addBallView()
    func makeCollisionOnPlayersViews()
    func shootBall()
    func setPlayersToOriginPoints()
}

 class BasketBoardInstaller: BasketBoardInstallerProtocol {
    
    //MARK: - Properties
    
    private var view: UIView
    private var tabBarController: UITabBarController
    private var boardImageView: UIImageView!
    private var attackingPlayers = [UIImageView]()
    private var defendingPlayers = [UIImageView]()
    private var animator: UIDynamicAnimator!
    private var collisionBehavior: UICollisionBehavior!
    private var ballImageView: UIImageView!
    private var isIntersectBallWithPlayer = false
    private var isBallShooted = false
    private var stateOfDefenders: StateOfDefenders = .isHidden
    private var rotationAngle: Double = 180
    
    // MARK: - Init
    
    init(view: UIView, tabBarController: UITabBarController) {
        self.view = view
        self.tabBarController = tabBarController
    }
    
    //MARK: - Methods
    
    func setupBoard() {
        let bottomAnchorConstant = -(tabBarController.tabBar.bounds.height)
        boardImageView = UIImageView()
        boardImageView.backgroundColor = .orange
        boardImageView.image = BoardScreenImages.boardImage
        view.addSubview(boardImageView)
        boardImageView.translatesAutoresizingMaskIntoConstraints = false
        boardImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: BoardScreenConstants.boardViewTopAnchor).isActive = true
        boardImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomAnchorConstant).isActive = true
        boardImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        boardImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    func addPlayer(type: TypeOfPlayer, backgroundColor: UIColor) {
        var index = 0
        for _ in 0...4 {
            let playerView = UIImageView()
            playerView.contentMode = .scaleAspectFill
            playerView.backgroundColor = backgroundColor
            playerView.dropShadow()
            playerView.frame = CGRect(x: 0, y: 0, width: BoardScreenConstants.playerWidth, height: BoardScreenConstants.playerWidth)
            playerView.layer.cornerRadius = BoardScreenConstants.playerWidth / 2
            
            playerView.isUserInteractionEnabled = true
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(moveView(gesture:)))
            gesture.minimumNumberOfTouches = 1
            gesture.maximumNumberOfTouches = 2
            playerView.addGestureRecognizer(gesture)
            
            switch type {
            case .attacking:
                playerView.image = BoardScreenImages.attackingPlayersImages[index]
                playerView.image = playerView.image?.withTintColor(.blue)
                playerView.center = BoardScreenConstants.attackingPlayersCoordinates[index]
                attackingPlayers.append(playerView)
            case .defending:
                playerView.alpha = 0
                playerView.center = BoardScreenConstants.defendingPlayersCoordinates[index]
                defendingPlayers.append(playerView)
            }
            view.addSubview(playerView)
        
            index += 1
        }
    }
     
     func showDefendingPlayers() {
         defendingPlayers.forEach { view in
             UIView.animate(withDuration: 0.5) {
                 view.alpha = 1
             }
         }
     }
    
    func hideDefendingPlayers() {
        stateOfDefenders = .isHiding
        defendingPlayers.forEach { view in
            UIView.animate(withDuration: 0.5) {
                view.backgroundColor = .black
                view.alpha = 0
            } completion: { _ in
                view.removeFromSuperview()
            }
        }
        defendingPlayers = []
    }
    
    func showOrHideDefenders() {
        switch stateOfDefenders {
        case .isHidden:
            addPlayer(type: .defending, backgroundColor: .red)
            showDefendingPlayers()
            makeCollisionOnPlayersViews()
            stateOfDefenders = .isShowed
        case .isShowed:
            hideDefendingPlayers()
            stateOfDefenders = .isHidden
        case .isHiding:
            return
        }
    }
    
    func addBallView() {
        ballImageView = UIImageView(frame: .init(x: 0, y: 0, width: BoardScreenConstants.ballWidth, height: BoardScreenConstants.ballWidth))
        ballImageView.center = BoardScreenConstants.pointBallImageView
        ballImageView.layer.cornerRadius = ballImageView.frame.width / 2
        ballImageView.image = BoardScreenImages.ballImage
        ballImageView.isUserInteractionEnabled = true
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(moveBall(gesture:)))
        ballImageView.addGestureRecognizer(gesture)
        ballImageView.dropShadow()
        view.addSubview(ballImageView)
    }
    
    func makeCollisionOnPlayersViews() {
        animator = UIDynamicAnimator(referenceView: view)
        
        collisionBehavior = UICollisionBehavior(items: attackingPlayers + defendingPlayers)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.addBoundary(withIdentifier: "bottomBoundary" as NSCopying, from: .init(x: 0,
                                                                                         y: UIScreen.main.bounds.height - (tabBarController.tabBar.bounds.height)),
                              to: .init(x: UIScreen.main.bounds.width,
                                        y: UIScreen.main.bounds.height - (tabBarController.tabBar.bounds.height)))
        
        collisionBehavior.addBoundary(withIdentifier: "topBoundary" as NSCopying, from: .init(x: 0, y: BoardScreenConstants.boardViewTopAnchor),
                              to: .init(x: UIScreen.main.bounds.width, y: BoardScreenConstants.boardViewTopAnchor))
        collisionBehavior.action = {
            self.attackingPlayers.forEach { $0.transform = CGAffineTransform.identity }
        }
    
        animator.addBehavior(collisionBehavior)
    }
    
    @objc private func moveView(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        guard let gestureView = gesture.view else { return }
        
        if gestureView.frame.intersects(ballImageView.frame) {
            isIntersectBallWithPlayer = true
            isBallShooted = false
        }
        
        
        if isIntersectBallWithPlayer {
            ballImageView.center.x = gestureView.center.x + 13
            ballImageView.center.y = gestureView.center.y - 15
        }
        switch gesture.state {
        case .cancelled, .ended, .failed:
            isIntersectBallWithPlayer = false
        default: break
        }
        
        gestureView.center = CGPoint(x: gestureView.center.x + translation.x,
                                     y: gestureView.center.y + translation.y)
        gesture.setTranslation(.zero, in: view)
        bringBackIfOutOfBounds(view: gestureView)
        animator.updateItem(usingCurrentState: gestureView)
    }
    
    @objc private func moveBall(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        guard let gestureView = gesture.view else { return }
        gestureView.center = CGPoint(x: gestureView.center.x + translation.x,
                                     y: gestureView.center.y + translation.y)
        gesture.setTranslation(.zero, in: view)
        bringBackIfOutOfBounds(view: gestureView)
    }
    
    private func bringBackIfOutOfBounds(view: UIView) {
        if view.center.x < 12.5 {
            view.center.x = 12.5
        } else if view.center.x > UIScreen.main.bounds.width - 12.5 {
            view.center.x = UIScreen.main.bounds.width - 12.5
        }
        
        if view.center.y < BoardScreenConstants.boardViewTopAnchor + 12.5 {
            view.center.y = BoardScreenConstants.boardViewTopAnchor + 12.5
        } else if view.center.y > UIScreen.main.bounds.height - (tabBarController.tabBar.bounds.height) - 12.5 {
            view.center.y = UIScreen.main.bounds.height - (tabBarController.tabBar.bounds.height) - 12.5
        }
    }
    
    func shootBall() {
        guard !isBallShooted else { return }
        isBallShooted = true
        
        let radians = CGFloat(rotationAngle / 180 * Double.pi)
        rotationAngle == 360 ? (rotationAngle = 180) : (rotationAngle += 180)
        
        UIView.animate(withDuration: 1) {
            self.ballImageView.center = BoardScreenConstants.pointOfBasket
            self.ballImageView.transform = CGAffineTransform(rotationAngle: radians)
        }
    }
    
    func setPlayersToOriginPoints() {
        
    }
}
