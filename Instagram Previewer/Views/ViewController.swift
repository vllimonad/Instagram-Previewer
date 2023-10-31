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
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionHeadersPinToVisibleBounds = true
        return layout
    }()
    
    var collectionView: UICollectionView!
    var viewModel: ViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons()
        setupCollectionView()
        viewModel = ViewModel()
        viewModel.delegate = self
        viewModel.getDataFromFile()
    }
    
    func addBarButtons() {
        let plusImage = UIImage(systemName: "plus.app", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        let settingsImage = UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        let addImageBarButtonItem = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(addImage))
        addImageBarButtonItem.tintColor = UIColor(named: "text")
        let openSettingsBarButtonItem = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(openSettings))
        openSettingsBarButtonItem.tintColor = UIColor(named: "text")
        
        navigationItem.rightBarButtonItems = [openSettingsBarButtonItem, addImageBarButtonItem]
        navigationItem.leftBarButtonItem = accountSwitchBarButtonItem
    }
    @objc func openSettings() {}
    @objc func addImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    @objc func showAccounts() {}

    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        layout.itemSize = CGSize(width: view.frame.width/3, height: view.frame.width/3)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: PhotoViewCell.id)
        collectionView.register(IconsHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: IconsHeaderCollectionReusableView.id)
        collectionView.register(InfoHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InfoHeaderCollectionReusableView.id)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame = view.bounds
        view.addSubview(collectionView)
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture1(_:)))
        gesture.minimumPressDuration = 0.4
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPressGesture1(_ gesture: UILongPressGestureRecognizer) {
        guard let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { return }
        switch gesture.state {
        case .began:
            collectionView.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return viewModel.getNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewCell.id, for: indexPath) as! PhotoViewCell
        cell.image.image = viewModel.getItemAt(indexPath.row)
        cell.layer.borderWidth = 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let infoHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InfoHeaderCollectionReusableView.id, for: indexPath) as! InfoHeaderCollectionReusableView
            //infoHeader.userAvatarButton.setImage(logInViewModel.getUserPicture(), for: .normal)
            return infoHeader
        }
        let iconsHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: IconsHeaderCollectionReusableView.id, for: indexPath) as! IconsHeaderCollectionReusableView
        iconsHeader.configure()
        return iconsHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: view.frame.width, height: view.frame.height/3)
        } else {
            return CGSize(width: view.frame.width, height: view.frame.height/16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = viewModel.removeItemAt(sourceIndexPath.row)
        viewModel.insertItemAt(item, destinationIndexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let contextMenu = UIContextMenuConfiguration(actionProvider: { suggestedActions in
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                let indexPath = indexPaths.first!
                self.viewModel.removeItemAt(indexPath.row)
                self.collectionView.deleteItems(at: [indexPaths.first!])
            }
            return UIMenu(children: [deleteAction])
        })
        return contextMenu
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        viewModel.insertItemAt(image.pngData()!, 0)
    }
}

extension ViewController: ViewModelDelegate {
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}
