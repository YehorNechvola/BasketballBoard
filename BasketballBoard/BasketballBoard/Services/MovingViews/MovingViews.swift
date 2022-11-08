//
//  MovingViews.swift
//  BasketballBoard
//
//  Created by Егор on 08.11.2022.
//

import UIKit

protocol MovingViewProtocol {
    
    var playersViews: [UIView] { get set }
    var ballView: UIImageView { get set }
    func placeViews(on parentView: Any)
}

class MovingView: MovingViewProtocol {
    
    var playersViews = [UIView]()
    var ballView: UIImageView
    
    init () {
        ballView = UIImageView(frame: .init(x: 200, y: 315, width: 18, height: 18))
        ballView.layer.cornerRadius = ballView.frame.width  / 2
        ballView.image = UIImage(named: "ball")
        ballView.clipsToBounds = true
    }
    
    
    func placeViews(on parentView: Any) {
        guard let parentView = parentView as? UIView else { return }
        parentView.addSubview(ballView)
        
        for _ in 0...4 {
            let view = UIView()
            view.backgroundColor = .blue
            playersViews.append(view)
            parentView.addSubview(view)
        }
        let widthOfScreen = UIScreen.main.bounds.width
        playersViews[0].frame = CGRect(x: 0, y: 280, width: 30, height: 30)
        playersViews[0].center.x = widthOfScreen / 2
        playersViews[1].frame = CGRect(x: (widthOfScreen / 2) - 30, y: 200, width: 30, height: 30)
        playersViews[1].center.x = (widthOfScreen / 2) - 140
        playersViews[2].frame = CGRect(x: (widthOfScreen / 2) + 30, y: 200, width: 30, height: 30)
        playersViews[2].center.x = (widthOfScreen / 2) + 140
        playersViews[3].frame = CGRect(x: (widthOfScreen / 2) - 30, y: 70, width: 30, height: 30)
        playersViews[3].center.x = (widthOfScreen / 2) - 130
        playersViews[4].frame = CGRect(x: (widthOfScreen / 2) + 30, y: 70, width: 30, height: 30)
        playersViews[4].center.x = (widthOfScreen / 2) + 130
        playersViews.forEach { view in
            view.layer.cornerRadius = view.frame.width / 2
            view.dropShadow()
        }
    }
}
