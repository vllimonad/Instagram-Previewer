//
//  ViewController.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 16/10/2023.
//

import UIKit

class ViewController: UIViewController {
    
    let accountSwitchBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        //button.setImage(UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 10, weight: .medium)), for: .normal)
        button.tintColor = UIColor(named: "text")
        //button.semanticContentAttribute = .forceRightToLeft
        return button
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
    var picker: UIImagePickerController!
    var viewModel: ViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons()
        addImagePicker()
        setupCollectionView()
        viewModel = ViewModel()
        viewModel.delegate = self
        viewModel.getDataFromFile()
    }
    
    func addBarButtons() {
        navigationItem.rightBarButtonItems = [getOpenSettingsBarButtonItem(), getAddImageBarButtonItem()]
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: accountSwitchBarButton)
    }
    
    func getOpenSettingsBarButtonItem() -> UIBarButtonItem {
        let settingsImage = UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        let openSettingsBarButtonItem = UIBarButtonItem(image: settingsImage, menu: getSettingsMenu())
        openSettingsBarButtonItem.tintColor = UIColor(named: "text")
        return openSettingsBarButtonItem
    }
    
    func getAddImageBarButtonItem() -> UIBarButtonItem {
        let plusImage = UIImage(systemName: "plus.app", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .medium))
        let addImageBarButtonItem = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(addImage))
        addImageBarButtonItem.tintColor = UIColor(named: "text")
        return addImageBarButtonItem
    }
    
    func getSettingsMenu() -> UIMenu {
        let logoutAction = UIAction(title: "Log out", image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), attributes: .destructive){ _ in }
        let resetAction = UIAction(title: "Reset", image: UIImage(systemName: "arrow.triangle.2.circlepath"), handler: reset(_:))
        return UIMenu(children: [resetAction, logoutAction])
    }
    
    func addImagePicker() {
        DispatchQueue.main.async {
            self.picker = UIImagePickerController()
            self.picker.delegate = self
            self.picker.allowsEditing = true
        }
    }
    
    func reset(_ action: UIAction) {
        viewModel.getDataFromServer()
        
    }
    
    @objc func addImage() {
        present(picker, animated: true)
    }
    
    @objc func showAccounts() {

    }

    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        layout.itemSize = CGSize(width: view.frame.width/3, height: view.frame.width/3)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: PhotoViewCell.id)
        collectionView.register(IconsHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: IconsHeaderCollectionReusableView.id)
        collectionView.register(InfoHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InfoHeaderCollectionReusableView.id)
        collectionView.frame = view.bounds
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
        view.addSubview(collectionView)
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
        cell.imageView.image = viewModel.getItemAt(indexPath.item)
        cell.layer.borderWidth = 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let infoHeader = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InfoHeaderCollectionReusableView.id, for: indexPath) as! InfoHeaderCollectionReusableView
            infoHeader.userAvatarButton.setImage(viewModel.getUserPicture(), for: .normal)
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let contextMenu = UIContextMenuConfiguration(
            identifier: String(indexPath.item) as NSString,
            previewProvider: { self.getPreviewProvider(indexPath) },
            actionProvider: { _ in
                let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
                    self.viewModel.removeItemAt(indexPath.item)
                    self.collectionView.deleteItems(at: [indexPaths.first!])
            }
            return UIMenu(children: [deleteAction])
        })
        return contextMenu
    }
    
    fileprivate func getPreviewProvider(_ indexPath: IndexPath) -> UIViewController {
        let viewController = UIViewController()
        let imageView = UIImageView(image: self.viewModel.getItemAt(indexPath.item))
        viewController.view = imageView
        viewController.preferredContentSize = CGSize(width: self.view.frame.width/1.3, height: self.view.frame.width/1.3)
        return viewController
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        viewModel.insertItemAt(image.pngData()!, 0)
    }
}

extension ViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = viewModel.getItemAt(indexPath.item)
        let itemProvider = NSItemProvider(object: item)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            destinationIndexPath = IndexPath(item: 0, section: 1)
        }
        if coordinator.proposal.operation == .move {
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        if let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath {
            collectionView.performBatchUpdates {
                let item = viewModel.removeItemAt(sourceIndexPath.item)
                viewModel.insertItemAt(item, destinationIndexPath.item)
                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            }
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
    
    
}

extension ViewController: ViewModelDelegate {
    
    func setUsername(_ username: String) {
        accountSwitchBarButton.setTitle(username, for: .normal)
        accountSwitchBarButton.sizeToFit()
    }
    
    func reloadCollectionView() {
        collectionView.reloadData()
    }
}
