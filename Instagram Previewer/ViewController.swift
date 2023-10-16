//
//  ViewController.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 16/10/2023.
//

import UIKit

class ViewController: UIViewController {
    
    let accountSwitchBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setTitle("vllimonad", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        button.setImage(UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .medium)), for: .normal)
        button.tintColor = UIColor(named: "text")
        button.semanticContentAttribute = .forceRightToLeft
        return UIBarButtonItem(customView: button)
    }()
    
    let addImageBarButtonItem: UIBarButtonItem = {
        let image = UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(addImage))
        button.tintColor = UIColor(named: "text")
        return button
    }()
    
    let openSettingsBarButtonItem: UIBarButtonItem = {
        let image = UIImage(systemName: "plus.app", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(openSettings))
        button.tintColor = UIColor(named: "text")
        return button
    }()
    
    var userAvatarButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
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

    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons()
        setupLayout()
    }
    
    func addBarButtons() {
        navigationItem.rightBarButtonItems = [addImageBarButtonItem, openSettingsBarButtonItem]
        navigationItem.leftBarButtonItem = accountSwitchBarButtonItem
    }
    @objc func openSettings() {}
    @objc func addImage() {}
    @objc func showAccounts() {}

    func setupLayout() {
        view.addSubview(userAvatarButton)
        view.addSubview(stack)
        stack.addArrangedSubview(getLabelsWith(name: "Posts", number: 1))
        stack.addArrangedSubview(getLabelsWith(name: "Followers", number: 245))
        stack.addArrangedSubview(getLabelsWith(name: "Folllowing", number: 643))

        NSLayoutConstraint.activate([
            userAvatarButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userAvatarButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            userAvatarButton.widthAnchor.constraint(equalToConstant: 90),
            userAvatarButton.heightAnchor.constraint(equalToConstant: 90),

            stack.leadingAnchor.constraint(equalTo: userAvatarButton.trailingAnchor, constant: 60),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),
            stack.centerYAnchor.constraint(equalTo: userAvatarButton.centerYAnchor, constant: 5)
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

