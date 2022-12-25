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
    func addBallView()
    func makeCollisionOnPlayersViews()
    func shootBall()
    func setPlayersToOriginPoints()
}

class BasketBoardInstaller: BasketBoardInstallerProtocol {
    var view: UIView
    var tabBarController: UITabBarController
    var boardImageView: UIImageView!
    var animator: UIDynamicAnimator!
    var playersViews = [UIView]()
    var ballImageView: UIImageView!
    var isIntersect = false
    var rotationAngle: Double = 180
    
    init(view: UIView, tabBarController: UITabBarController) {
        self.view = view
        self.tabBarController = tabBarController
    }
    
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
            playersViews.append(playerView)
            view.addSubview(playerView)
            playerView.dropShadow()
            
            let gesture = UIPanGestureRecognizer(target: self, action: #selector(moveView(gesture:)))
            gesture.minimumNumberOfTouches = 1
            gesture.maximumNumberOfTouches = 2
            playerView.addGestureRecognizer(gesture)
        }
        
        let width = BoardScreenConstants.playerWidth
        playersViews[0].frame = CGRect(x: 0, y: 0, width: width, height: width)
        playersViews[0].center = CGPoint(x: BoardScreenConstants.xPointFirstPlayer,
                                              y: BoardScreenConstants.yPointFirstPlayer)
        
        playersViews[1].frame = CGRect(x: 0, y: 0, width: width, height: width)
        playersViews[1].center = CGPoint(x: BoardScreenConstants.xPointSecondPlayer,
                                              y: BoardScreenConstants.yPointSecondPlayer)
        
        playersViews[2].frame = CGRect(x: 0, y: 0, width: width, height: width)
        playersViews[2].center = CGPoint(x: BoardScreenConstants.xPointThirdPlayer,
                                              y: BoardScreenConstants.yPointThirdPlayer)
        
        playersViews[3].frame = CGRect(x: 0, y: 0, width: width, height: width)
        playersViews[3].center = CGPoint(x: BoardScreenConstants.xPointFourthPlayer,
                                              y: BoardScreenConstants.yPointFourthPlayer)
        
        playersViews[4].frame = CGRect(x: 0, y: 0, width: width, height: width)
        playersViews[4].center = CGPoint(x: BoardScreenConstants.xPointFifthPlayer,
                                              y: BoardScreenConstants.yPointFifthPlayer)
        
        playersViews.forEach { view in
            view.layer.cornerRadius = view.frame.width / 2
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
        
        let collision = UICollisionBehavior(items: playersViews)
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
            isIntersect = true
        }
        
        if isIntersect {
            ballImageView.center.x = gestureView.center.x + 13
            ballImageView.center.y = gestureView.center.y - 15
        }
        switch gesture.state {
        case .cancelled, .ended, .failed:
            isIntersect = false
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
        let yPoint = UIScreen.main.bounds.height * 0.194
        let radians = CGFloat(rotationAngle / 180 * Double.pi)
        rotationAngle == 360 ? (rotationAngle = 180) : (rotationAngle += 180)
        
        UIView.animate(withDuration: 1) { [weak self] in
            self?.ballImageView.center = CGPoint(x: xPoint , y: yPoint)
            self?.ballImageView.transform = CGAffineTransform(rotationAngle: radians)
        }
    }
    
    func setPlayersToOriginPoints() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.playersViews[0].center = CGPoint(x: BoardScreenConstants.xPointFirstPlayer,
                                                  y: BoardScreenConstants.yPointFirstPlayer)

            self?.playersViews[1].center = CGPoint(x: BoardScreenConstants.xPointSecondPlayer,
                                                  y: BoardScreenConstants.yPointSecondPlayer)

            self?.playersViews[2].center = CGPoint(x: BoardScreenConstants.xPointThirdPlayer,
                                                  y: BoardScreenConstants.yPointThirdPlayer)

            self?.playersViews[3].center = CGPoint(x: BoardScreenConstants.xPointFourthPlayer,
                                                  y: BoardScreenConstants.yPointFourthPlayer)

            self?.playersViews[4].center = CGPoint(x: BoardScreenConstants.xPointFifthPlayer,
                                                  y: BoardScreenConstants.yPointFifthPlayer)

            self?.ballImageView.center = CGPoint(x: BoardScreenConstants.xPointFirstPlayer + 13,
                                                 y: BoardScreenConstants.yPointFirstPlayer - 15)
            
        } completion: { [weak self] _ in
            self?.playersViews.forEach({ playerView in
                playerView.removeFromSuperview()
            })
            self?.playersViews = []
            self?.addMovingPlayers()
            self?.makeCollisionOnPlayersViews()
        }
    }
}
