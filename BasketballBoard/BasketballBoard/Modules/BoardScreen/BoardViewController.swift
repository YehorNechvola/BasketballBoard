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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
        view.frame = UIScreen.main.bounds
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
        var playersViews = [UIView]()
        
        
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
        playersViews.forEach { view in
            view.layer.cornerRadius = view.frame.width / 2
        }
    }
    
    @objc func moveView(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        guard let gestureView = gesture.view else { return }
        gestureView.center = CGPoint(x: gestureView.center.x + translation.x,
                                     y: gestureView.center.y + translation.y)
        gesture.setTranslation(.zero, in: view)
    }
}
