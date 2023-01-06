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
    case isShowing
    case isHiding
}

//MARK: - BasketBoardInstallerProtocol

protocol BasketBoardInstallerProtocol {
    func setupBoard()
    func addMovingPlayers()
    func showOrHideDefenders()
    func setDefendersToOriginPoint()
    func addBallView()
    func makeCollisionOnPlayersViews()
    func shootBall()
    func setPlayersToOriginPoints()
}

final class BasketBoardInstaller: BasketBoardInstallerProtocol {
    
    //MARK: - Properties
    
    private var view: UIView
    private var tabBarController: UITabBarController
    private var boardImageView: UIImageView!
    private var attackingPlayers = [UIView]()
    private var defendingPlayers = [UIView]()
    private var animator: UIDynamicAnimator!
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
        boardImageView.image = UIImage(named: "basketBoard")
        view.addSubview(boardImageView)
        boardImageView.translatesAutoresizingMaskIntoConstraints = false
        boardImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: BoardScreenConstants.boardViewTopAnchor).isActive = true
        boardImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomAnchorConstant).isActive = true
        boardImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        boardImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func addMovingPlayers() {
        var index = 0
        for _ in 0...4 {
            let playerView = UIImageView()
            
            playerView.contentMode = .scaleAspectFill
            playerView.backgroundColor = .white
            
            playerView.dropShadow()
            
            switch index {
            case 0: playerView.image = BoardScreenImages.pointGuardImage
            case 1: playerView.image = BoardScreenImages.shootingGuardImage
            case 2: playerView.image = BoardScreenImages.smallForwardImage
            case 3: playerView.image = BoardScreenImages.powerForwardImage
            case 4: playerView.image = BoardScreenImages.centerImage
            default: break
            }
            
            playerView.image = playerView.image?.withTintColor(.blue)
            index += 1
            
            attackingPlayers.append(playerView)
            view.addSubview(playerView)
            
            playerView.isUserInteractionEnabled = true
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(moveView(gesture:)))
            gesture.minimumNumberOfTouches = 1
            gesture.maximumNumberOfTouches = 2
            playerView.addGestureRecognizer(gesture)
        }
        
        let width = BoardScreenConstants.playerWidth
        attackingPlayers[0].frame = CGRect(x: 0, y: 0, width: width, height: width)
        attackingPlayers[0].center = BoardScreenConstants.pointFirstPlayer
        
        attackingPlayers[1].frame = CGRect(x: 0, y: 0, width: width, height: width)
        attackingPlayers[1].center = BoardScreenConstants.pointSecondPlayer
        
        attackingPlayers[2].frame = CGRect(x: 0, y: 0, width: width, height: width)
        attackingPlayers[2].center = BoardScreenConstants.pointThirdPlayer
        
        attackingPlayers[3].frame = CGRect(x: 0, y: 0, width: width, height: width)
        attackingPlayers[3].center = BoardScreenConstants.pointFourthPlayer
        
        attackingPlayers[4].frame = CGRect(x: 0, y: 0, width: width, height: width)
        attackingPlayers[4].center = BoardScreenConstants.pointFifthPlayer
        
        attackingPlayers.forEach { $0.layer.cornerRadius = $0.frame.width / 2 }
    }
    
    private func addDefendingPlayers() {
        stateOfDefenders = .isShowing
        
        for _ in 0...4 {
            let playerView = UIView()
            playerView.backgroundColor = .red
            defendingPlayers.append(playerView)
            view.addSubview(playerView)
            playerView.dropShadow()
            
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(moveView(gesture:)))
            gesture.minimumNumberOfTouches = 1
            gesture.maximumNumberOfTouches = 2
            playerView.addGestureRecognizer(gesture)
        }
        
        defendingPlayers[0].frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        defendingPlayers[0].center = CGPoint(x: -32, y: UIScreen.main.bounds.midY)
        
        defendingPlayers[1].frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        defendingPlayers[1].center = CGPoint(x: -32, y: UIScreen.main.bounds.midY)
        
        defendingPlayers[2].frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        defendingPlayers[2].center = CGPoint(x: -32, y: UIScreen.main.bounds.midY)
        
        defendingPlayers[3].frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        defendingPlayers[3].center = CGPoint(x: -32, y: UIScreen.main.bounds.midY)
        
        defendingPlayers[4].frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        defendingPlayers[4].center = CGPoint(x: -32, y: UIScreen.main.bounds.midY)
        
        defendingPlayers.forEach { $0.layer.cornerRadius = $0.frame.width / 2 }
        
    }
    
    private func dropDefendingPlayers() {
        
        UIView.animate(withDuration: 0.7) {
            self.defendingPlayers.forEach { $0.center = BoardScreenConstants.pointFirstDefender }
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.defendingPlayers[1].center = BoardScreenConstants.pointSecondDefender
                self.defendingPlayers[2].center = BoardScreenConstants.pointThirdDefender
                self.defendingPlayers[3].center = BoardScreenConstants.pointFourthDefender
                self.defendingPlayers[4].center = BoardScreenConstants.pointFifthDefender
            }
            self.stateOfDefenders = .isShowed
        }
    }
    
    private func hideDefendingPlayers() {
        stateOfDefenders = .isHiding
        
        UIView.animate(withDuration: 0.8) {
            self.defendingPlayers.forEach {
                $0.backgroundColor = .black
                $0.alpha = 0
            }
        } completion: { _ in
            self.defendingPlayers.forEach { $0.removeFromSuperview() }
            self.defendingPlayers = []
            self.stateOfDefenders = .isHidden
        }
    }
    
    func showOrHideDefenders() {
        switch stateOfDefenders {
        case .isHidden:
            addDefendingPlayers()
            dropDefendingPlayers()
        case .isShowed:
            hideDefendingPlayers()
        case .isShowing, .isHiding:
            return
        }
    }
    
    func addBallView() {
        ballImageView = UIImageView(frame: .init(x: 0, y: 0, width: 20, height: 20))
        ballImageView.center = BoardScreenConstants.pointBallImageView
        ballImageView.layer.cornerRadius = ballImageView.frame.width / 2
        ballImageView.image = UIImage(named: "ball")
        ballImageView.isUserInteractionEnabled = true
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(moveBall(gesture:)))
        ballImageView.addGestureRecognizer(gesture)
        ballImageView.dropShadow()
        view.addSubview(ballImageView)
    }
    
    func makeCollisionOnPlayersViews() {
        animator = UIDynamicAnimator(referenceView: view)
        
        let collision = UICollisionBehavior(items: attackingPlayers)
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.addBoundary(withIdentifier: "bottomBoundary" as NSCopying, from: .init(x: 0,
                                                                                         y: UIScreen.main.bounds.height - (tabBarController.tabBar.bounds.height)),
                              to: .init(x: UIScreen.main.bounds.width,
                                        y: UIScreen.main.bounds.height - (tabBarController.tabBar.bounds.height)))
        collision.addBoundary(withIdentifier: "topBoundary" as NSCopying, from: .init(x: 0, y: BoardScreenConstants.boardViewTopAnchor),
                              to: .init(x: UIScreen.main.bounds.width, y: BoardScreenConstants.boardViewTopAnchor))
        collision.action = {
            self.attackingPlayers.forEach { $0.transform = CGAffineTransform.identity }
        }
    
        animator.addBehavior(collision)
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
        UIView.animate(withDuration: 0.5) {
            
            self.attackingPlayers[0].center = BoardScreenConstants.pointFirstPlayer
            self.attackingPlayers[1].center = BoardScreenConstants.pointSecondPlayer
            self.attackingPlayers[2].center = BoardScreenConstants.pointThirdPlayer
            self.attackingPlayers[3].center = BoardScreenConstants.pointFourthPlayer
            self.attackingPlayers[4].center = BoardScreenConstants.pointFifthPlayer
            self.ballImageView.center = BoardScreenConstants.pointBallImageView
            
        } completion: { _ in
            self.isBallShooted = false
            self.attackingPlayers.forEach{ $0.removeFromSuperview() }
            self.attackingPlayers = []
            self.addMovingPlayers()
            self.makeCollisionOnPlayersViews()
        }
    }
    
    func setDefendersToOriginPoint() {
        guard stateOfDefenders == .isShowed else { return }
        
        UIView.animate(withDuration: 0.5) {
            self.defendingPlayers[0].center = BoardScreenConstants.pointFirstDefender
            self.defendingPlayers[1].center = BoardScreenConstants.pointSecondDefender
            self.defendingPlayers[2].center = BoardScreenConstants.pointThirdDefender
            self.defendingPlayers[3].center = BoardScreenConstants.pointFourthDefender
            self.defendingPlayers[4].center = BoardScreenConstants.pointFifthDefender
        }
    }
}
