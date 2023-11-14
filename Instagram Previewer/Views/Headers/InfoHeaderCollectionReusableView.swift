//
//  InfoHeaderCollectionReusableView.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 17/10/2023.
//

import UIKit

final class InfoHeaderCollectionReusableView: UICollectionReusableView {
    
    static let id = "info"
    
    var userAvatarButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 45
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        addSubview(userAvatarButton)
        addSubview(stack)
        let posts = getLabelsWith(name: "Posts", number: 1)
        let followers = getLabelsWith(name: "Followers", number: 245)
        let following = getLabelsWith(name: "Folllowing", number: 643)
        stack.addArrangedSubview(posts)
        stack.addArrangedSubview(followers)
        stack.addArrangedSubview(following)

        NSLayoutConstraint.activate([
            userAvatarButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userAvatarButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            userAvatarButton.widthAnchor.constraint(equalToConstant: 90),
            userAvatarButton.heightAnchor.constraint(equalToConstant: 90),

            stack.leadingAnchor.constraint(equalTo: userAvatarButton.trailingAnchor, constant: 60),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23),
            stack.centerYAnchor.constraint(equalTo: userAvatarButton.centerYAnchor, constant: 5),
        ])
    }
    
    func getLabelsWith(name: String, number: Int) -> UIStackView {
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = UIColor(named: "text")
        
        let numberLabel = UILabel()
        numberLabel.text = String(number)
        numberLabel.font = UIFont.boldSystemFont(ofSize: 16)
        numberLabel.textColor = UIColor(named: "text")
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.addArrangedSubview(numberLabel)
        stack.addArrangedSubview(nameLabel)
        return stack
    }
}
