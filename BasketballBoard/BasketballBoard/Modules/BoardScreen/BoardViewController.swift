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
        setBarButtonItems()
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
     
     private func setBarButtonItems() {
         let shootButton = UIBarButtonItem(title: "Shoot", style: .done, target: self, action: #selector(shootButtonPressed))
         let startOverButton = UIBarButtonItem(title: "StartOver", style: .done, target: self, action: #selector(setPointButtonPressed))
         let defendersButton = UIBarButtonItem(title: "Defend", style: .done, target: self, action: #selector(defendButtonPressed))
         let changeSideButton = UIBarButtonItem(title: "ChangeSide", style: .done, target: self, action: #selector(changeSideButtonPressed))
         let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: nil)
         
         navigationItem.leftBarButtonItems = [shootButton, startOverButton, defendersButton, changeSideButton, saveButton]
         navigationItem.leftBarButtonItems?.forEach{ $0.tintColor = .orange }
         saveButton.tintColor = .label
     }
     
     @objc private func shootButtonPressed() {
         basketBoardInstaller.shootBall()
     }
     
     @objc private func setPointButtonPressed() {
         basketBoardInstaller.setPlayersToOriginPoints()
         basketBoardInstaller.setDefendersToOriginPoint()
     }
     
     @objc private func defendButtonPressed() {
         basketBoardInstaller.showOrHideDefenders()
     }
     
     @objc private func changeSideButtonPressed() {
         print("needs Code")
     }
 }

