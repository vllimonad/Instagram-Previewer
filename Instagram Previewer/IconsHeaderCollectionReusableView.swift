//
//  HeaderCollectionReusableView.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 17/10/2023.
//

import UIKit

class IconsHeaderCollectionReusableView: UICollectionReusableView {
    
    static let id = "Header"
    
    let photosButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "squareshape.split.3x3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)), for: .normal)
        button.tintColor = UIColor(named: "text")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let reelsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)), for: .normal)
        button.tintColor = UIColor(named: "text")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func configure() {
        backgroundColor = .systemBackground
        let stack = UIStackView(arrangedSubviews: [photosButton, reelsButton])
        stack.distribution = .fillEqually
        stack.frame = bounds
        addSubview(stack)
    }
}
