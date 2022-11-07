//
//  BoardViewController.swift
//  BasketballBoard
//
//  Created by Егор on 06.11.2022.
//

import UIKit

final class BoardViewController: UIViewController {
    
    var viewModel: BoardViewModelProtocol!
    private var boardImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        setupBoard()

    }
    
    private func setupBoard() {
        boardImageView = UIImageView()
        boardImageView.backgroundColor = .orange
        boardImageView.image = UIImage(named: "basketBoard")
        view.addSubview(boardImageView)
        boardImageView.translatesAutoresizingMaskIntoConstraints = false
        boardImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        boardImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(tabBarController?.tabBar.bounds.height)!).isActive = true
        boardImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        boardImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
