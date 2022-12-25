//
//  BoardViewController.swift
//  BasketballBoard
//
//  Created by Егор on 06.11.2022.
//

import UIKit

 class BoardViewController: UIViewController {
    
     var viewModel: BoardViewModelProtocol!
     var basketBoardInstaller: BasketBoardInstallerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBaskletballBoard()
        setButtons()
    }
     
     private func setBaskletballBoard() {
         view.backgroundColor = .brown
         basketBoardInstaller = BasketBoardInstaller(view: view, tabBarController: tabBarController!)
         basketBoardInstaller.setupBoard()
         basketBoardInstaller.addBallView()
         basketBoardInstaller.addMovingPlayers()
         basketBoardInstaller.makeCollisionOnPlayersViews()
     }
     
     private func setButtons() {
         let button = UIButton(frame: .init(x: 30, y: 400, width: 70, height: 40))
         button.backgroundColor = .red
         button.setTitle("Shoot", for: .normal)
         button.addTarget(self, action: #selector(shootButtonPressed), for: .touchUpInside)
         view.addSubview(button)
         
         let pointButton = UIButton(frame: .init(x: 80, y: 300, width: 70, height: 40))
         pointButton.backgroundColor = .red
         pointButton.setTitle("Point", for: .normal)
         pointButton.addTarget(self, action: #selector(setPointButtonPressed), for: .touchUpInside)
         view.addSubview(pointButton)
     }
     
     @objc private func shootButtonPressed() {
         basketBoardInstaller.shootBall()
     }
     
     @objc private func setPointButtonPressed() {
         basketBoardInstaller.setPlayersToOriginPoints()
     }
 }

