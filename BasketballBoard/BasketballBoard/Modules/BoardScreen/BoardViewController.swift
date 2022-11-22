//
//  BoardViewController.swift
//  BasketballBoard
//
//  Created by Егор on 06.11.2022.
//

import UIKit

 class BoardViewController: UIViewController {
    
     var viewModel: BoardViewModelProtocol!
     var boardImageView: UIImageView!
     var animator: UIDynamicAnimator!
     var collision: UICollisionBehavior!
     var playersViews = [UIView]()
     var ballImageView: UIImageView!
     var isIntersect = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
        setupBoard()
        addMovingPlayers()
        
    }
    
    private func setupBoard() {
        
        let bottomAnchorConstant = -(tabBarController?.tabBar.bounds.height ?? 40)
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
        playersViews[0].frame = CGRect(x: 0, y: BoardScreenConstants.yPointFirstPlayer, width: width, height: width)
        playersViews[0].center.x = BoardScreenConstants.xPointFirstPlayer
        playersViews[1].frame = CGRect(x: 0, y: BoardScreenConstants.yPointSecondPlayer, width: width, height: width)
        playersViews[1].center.x = BoardScreenConstants.xPointSecondPlayer
        playersViews[2].frame = CGRect(x: 0, y: BoardScreenConstants.yPointThirdPlayer, width: width, height: width)
        playersViews[2].center.x = BoardScreenConstants.xPointThirdPlayer
        playersViews[3].frame = CGRect(x: 0, y: BoardScreenConstants.yPointFourthPlayer, width: width, height: width)
        playersViews[3].center.x = BoardScreenConstants.xPointFourthPlayer
        playersViews[4].frame = CGRect(x: 0, y: BoardScreenConstants.yPointFifthPlayer, width: width, height: width)
        playersViews[4].center.x = BoardScreenConstants.xPointFifthPlayer
        
        animator = UIDynamicAnimator(referenceView: self.view)
        
        collision = UICollisionBehavior(items: playersViews)
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.addBoundary(withIdentifier: "bottomBoundary" as NSCopying, from: .init(x: 0,
                                                                                         y: UIScreen.main.bounds.height - (tabBarController?.tabBar.bounds.height ?? 40)),
                              to: .init(x: UIScreen.main.bounds.width,
                                        y: UIScreen.main.bounds.height - (tabBarController?.tabBar.bounds.height ?? 40)))
        collision.addBoundary(withIdentifier: "topBoundary" as NSCopying, from: .init(x: 0, y: BoardScreenConstants.boardViewTopAnchor),
                              to: .init(x: UIScreen.main.bounds.width, y: BoardScreenConstants.boardViewTopAnchor))
        
        animator.addBehavior(collision)
        
        playersViews.forEach { view in
            view.layer.cornerRadius = view.frame.width / 2
        }
        
        ballImageView = UIImageView(frame: .init(x: 0, y: 0, width: 20, height: 20))
        let point = CGPoint(x: playersViews[0].frame.midX + 13, y: playersViews[0].frame.midY - 15)
        ballImageView.center = point
        ballImageView.layer.cornerRadius = ballImageView.frame.width / 2
        ballImageView.image = UIImage(named: "ball")
        ballImageView.isUserInteractionEnabled = true
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(moveBall(gesture:)))
        ballImageView.addGestureRecognizer(gesture)
        ballImageView.dropShadow()
        view.addSubview(ballImageView)
    }
    
    @objc func moveView(gesture: UIPanGestureRecognizer) {
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
        
        if gestureView.center.x < 12.5 {
            gestureView.center.x = 12.5
        } else if gestureView.center.x > UIScreen.main.bounds.width - 12.5 {
            gestureView.center.x = UIScreen.main.bounds.width - 12.5
        }
        
        if gestureView.center.y < BoardScreenConstants.boardViewTopAnchor + 12.5 {
            gestureView.center.y = BoardScreenConstants.boardViewTopAnchor + 12.5
        } else if gestureView.center.y > UIScreen.main.bounds.height - (tabBarController?.tabBar.bounds.height)! - 12.5 {
            gestureView.center.y = UIScreen.main.bounds.height - (tabBarController?.tabBar.bounds.height)! - 12.5
        }
        animator.updateItem(usingCurrentState: gestureView)
    }
     
     @objc func moveBall(gesture: UIPanGestureRecognizer) {
         isIntersect = false
         
         let translation = gesture.translation(in: view)
         guard let gestureView = gesture.view else { return }
         gestureView.center = CGPoint(x: gestureView.center.x + translation.x,
                                      y: gestureView.center.y + translation.y)
         gesture.setTranslation(.zero, in: view)
         
         if gestureView.center.x < 12.5 {
             gestureView.center.x = 12.5
         } else if gestureView.center.x > UIScreen.main.bounds.width - 12.5 {
             gestureView.center.x = UIScreen.main.bounds.width - 12.5
         }
         
         if gestureView.center.y < BoardScreenConstants.boardViewTopAnchor + 12.5 {
             gestureView.center.y = BoardScreenConstants.boardViewTopAnchor + 12.5
         } else if gestureView.center.y > UIScreen.main.bounds.height - (tabBarController?.tabBar.bounds.height)! - 12.5 {
             gestureView.center.y = UIScreen.main.bounds.height - (tabBarController?.tabBar.bounds.height)! - 12.5
         }
     }
 }

