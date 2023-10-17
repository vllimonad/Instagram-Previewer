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
    
    var collectionView: UICollectionView!
    var scrollView: UIScrollView!
    var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons()
        setupCollectionView()
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
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: (48+6)*view.frame.width/9)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)
        
        
        contentView.addSubview(userAvatarButton)
        contentView.addSubview(stack)
        stack.addArrangedSubview(getLabelsWith(name: "Posts", number: 1))
        stack.addArrangedSubview(getLabelsWith(name: "Followers", number: 245))
        stack.addArrangedSubview(getLabelsWith(name: "Folllowing", number: 643))
        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            userAvatarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            userAvatarButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            userAvatarButton.widthAnchor.constraint(equalToConstant: 90),
            userAvatarButton.heightAnchor.constraint(equalToConstant: 90),

            stack.leadingAnchor.constraint(equalTo: userAvatarButton.trailingAnchor, constant: 60),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -23),
            stack.centerYAnchor.constraint(equalTo: userAvatarButton.centerYAnchor, constant: 5),
            
            collectionView.topAnchor.constraint(equalTo: userAvatarButton.bottomAnchor, constant: 200),
            collectionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48*view.frame.width/9),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
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

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: view.frame.width/3, height: view.frame.width/3)
        layout.sectionHeadersPinToVisibleBounds = true
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: PhotoViewCell.id)
        collectionView.register(IconsHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: IconsHeaderCollectionReusableView.id)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 48
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewCell.id, for: indexPath) as! PhotoViewCell
        cell.backgroundColor = .blue
        cell.layer.borderWidth = 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: IconsHeaderCollectionReusableView.id, for: indexPath) as! IconsHeaderCollectionReusableView
        header.configure()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: contentView.frame.width, height: contentView.frame.height/16)
    }
}
