//
//  HeaderCollectionReusableView.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 17/10/2023.
//

import UIKit

final class IconsHeaderCollectionReusableView: UICollectionReusableView {
    
    static let id = "icons"
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let photosButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "squareshape.split.3x3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)), for: .normal)
        button.tintColor = UIColor(named: "text")
        button.addTarget(self, action: #selector(photosButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let reelsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "play.square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(reelsButtonTapped), for: .touchUpInside)
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
    
    @objc func photosButtonTapped() {
        photosButton.tintColor = UIColor(named: "text")
        reelsButton.tintColor = .darkGray
    }
    
    @objc func reelsButtonTapped() {
        reelsButton.tintColor = UIColor(named: "text")
        photosButton.tintColor = .darkGray
    }
}
