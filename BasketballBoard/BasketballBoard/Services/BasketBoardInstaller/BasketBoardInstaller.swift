//
//  BasketBoardInstaller.swift
//  BasketballBoard
//
//  Created by Егор on 22.11.2022.
//

import UIKit

//MARK: - BasketBoardInstallerProtocol

protocol BasketBoardInstallerProtocol {
    var view: UIView { get set }
    var tabBarController: UITabBarController { get set }
    func setupBoard()
    func addMovingPlayers()
    func addDefendingPlayers()
    func hideDefendingPlayers()
    func addBallView()
    func makeCollisionOnPlayersViews()
    func shootBall()
    func setPlayersToOriginPoints()
}

class BasketBoardInstaller: BasketBoardInstallerProtocol {
    
    //MARK: - Properties
    
    var view: UIView
    var tabBarController: UITabBarController
    var boardImageView: UIImageView!
    var attackingPlayers = [UIView]()
    var defendingPlayers = [UIView]()
    private var animator: UIDynamicAnimator!
    private var ballImageView: UIImageView!
    private var isIntersectBallWithPlayer = false
    private var isHiddenDefenders = true
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
        for _ in 0...4 {
            let playerView = UIView()
            playerView.backgroundColor = .blue
            attackingPlayers.append(playerView)
            view.addSubview(playerView)
            playerView.dropShadow()
            
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(moveView(gesture:)))
            gesture.minimumNumberOfTouches = 1
            gesture.maximumNumberOfTouches = 2
            playerView.addGestureRecognizer(gesture)
        }
        
        let width = BoardScreenConstants.playerWidth
        attackingPlayers[0].frame = CGRect(x: 0, y: 0, width: width, height: width)
        attackingPlayers[0].center = CGPoint(x: BoardScreenConstants.xPointFirstPlayer,
                                              y: BoardScreenConstants.yPointFirstPlayer)
        
        attackingPlayers[1].frame = CGRect(x: 0, y: 0, width: width, height: width)
        attackingPlayers[1].center = CGPoint(x: BoardScreenConstants.xPointSecondPlayer,
                                              y: BoardScreenConstants.yPointSecondPlayer)
        
        attackingPlayers[2].frame = CGRect(x: 0, y: 0, width: width, height: width)
        attackingPlayers[2].center = CGPoint(x: BoardScreenConstants.xPointThirdPlayer,
                                              y: BoardScreenConstants.yPointThirdPlayer)
        
        attackingPlayers[3].frame = CGRect(x: 0, y: 0, width: width, height: width)
        attackingPlayers[3].center = CGPoint(x: BoardScreenConstants.xPointFourthPlayer,
                                              y: BoardScreenConstants.yPointFourthPlayer)
        
        attackingPlayers[4].frame = CGRect(x: 0, y: 0, width: width, height: width)
        attackingPlayers[4].center = CGPoint(x: BoardScreenConstants.xPointFifthPlayer,
                                              y: BoardScreenConstants.yPointFifthPlayer)
        
        attackingPlayers.forEach { $0.layer.cornerRadius = $0.frame.width / 2 }
    }
    
    func addDefendingPlayers() {
        guard isHiddenDefenders else {
            hideDefendingPlayers()
            return
        }
        
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
        defendingPlayers[0].center = CGPoint(x: -32,
                                             y: UIScreen.main.bounds.midY)
        
        defendingPlayers[1].frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        defendingPlayers[1].center = CGPoint(x: -32,
                                             y: UIScreen.main.bounds.midY)
        
        defendingPlayers[2].frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        defendingPlayers[2].center = CGPoint(x: -32,
                                             y: UIScreen.main.bounds.midY)
        
        defendingPlayers[3].frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        defendingPlayers[3].center = CGPoint(x: -32,
                                             y: UIScreen.main.bounds.midY)
        
        defendingPlayers[4].frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        defendingPlayers[4].center = CGPoint(x: -32,
                                             y: UIScreen.main.bounds.midY)
        
        defendingPlayers.forEach { $0.layer.cornerRadius = $0.frame.width / 2 }
        
        dropDefendingPlayers()
    }
    
    func dropDefendingPlayers() {
        isHiddenDefenders = false
        
        UIView.animate(withDuration: 1) {
            self.defendingPlayers.forEach { $0.center = CGPoint(x: BoardScreenConstants.xPointFirstPlayer,
                                                                y: BoardScreenConstants.yPointFirstPlayer - 45) }
        } completion: { _ in
            UIView.animate(withDuration: 0.75) {
                self.defendingPlayers[1].center = CGPoint(x: BoardScreenConstants.xPointSecondPlayer + 35,
                                                          y: BoardScreenConstants.yPointSecondPlayer - 20)
                
                self.defendingPlayers[2].center = CGPoint(x: BoardScreenConstants.xPointThirdPlayer - 35,
                                                          y: BoardScreenConstants.yPointThirdPlayer - 20)
                
                self.defendingPlayers[3].center = CGPoint(x: BoardScreenConstants.xPointFourthPlayer + 35,
                                                          y: BoardScreenConstants.yPointFourthPlayer)
                
                self.defendingPlayers[4].center = CGPoint(x: BoardScreenConstants.xPointFifthPlayer - 35,
                                                          y: BoardScreenConstants.yPointFifthPlayer)
            }
        }
    }
    
    func hideDefendingPlayers() {
        isHiddenDefenders = true
        
        UIView.animate(withDuration: 0.8) {
            self.defendingPlayers.forEach {
                $0.backgroundColor = .black
                $0.alpha = 0
            }
        } completion: { _ in
            self.defendingPlayers.forEach { $0.removeFromSuperview() }
            self.defendingPlayers = []
        }
    }
    
    func addBallView() {
        ballImageView = UIImageView(frame: .init(x: 0, y: 0, width: 20, height: 20))
        let point = CGPoint(x: BoardScreenConstants.xPointFirstPlayer + 13, y: BoardScreenConstants.yPointFirstPlayer - 15)
        ballImageView.center = point
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
        
        animator.addBehavior(collision)
    }
    
    @objc private func moveView(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        guard let gestureView = gesture.view else { return }
        
        if gestureView.frame.intersects(ballImageView.frame) {
            isIntersectBallWithPlayer = true
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
        let xPoint = UIScreen.main.bounds.width * 0.5
        let yPoint = UIScreen.main.bounds.height * 0.18
        let radians = CGFloat(rotationAngle / 180 * Double.pi)
        rotationAngle == 360 ? (rotationAngle = 180) : (rotationAngle += 180)
        
        UIView.animate(withDuration: 1) { [weak self] in
            self?.ballImageView.center = CGPoint(x: xPoint , y: yPoint)
            self?.ballImageView.transform = CGAffineTransform(rotationAngle: radians)
        }
    }
    
    func setPlayersToOriginPoints() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.attackingPlayers[0].center = CGPoint(x: BoardScreenConstants.xPointFirstPlayer,
                                                  y: BoardScreenConstants.yPointFirstPlayer)

            self?.attackingPlayers[1].center = CGPoint(x: BoardScreenConstants.xPointSecondPlayer,
                                                  y: BoardScreenConstants.yPointSecondPlayer)

            self?.attackingPlayers[2].center = CGPoint(x: BoardScreenConstants.xPointThirdPlayer,
                                                  y: BoardScreenConstants.yPointThirdPlayer)

            self?.attackingPlayers[3].center = CGPoint(x: BoardScreenConstants.xPointFourthPlayer,
                                                  y: BoardScreenConstants.yPointFourthPlayer)

            self?.attackingPlayers[4].center = CGPoint(x: BoardScreenConstants.xPointFifthPlayer,
                                                  y: BoardScreenConstants.yPointFifthPlayer)

            self?.ballImageView.center = CGPoint(x: BoardScreenConstants.xPointFirstPlayer + 13,
                                                 y: BoardScreenConstants.yPointFirstPlayer - 15)
            
        } completion: { [weak self] _ in
            self?.attackingPlayers.forEach{ $0.removeFromSuperview() }
            self?.attackingPlayers = []
            self?.addMovingPlayers()
            self?.makeCollisionOnPlayersViews()
        }
    }
}
