//
//  PhotoViewCell.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 16/10/2023.
//

import UIKit

final class PhotoViewCell: UICollectionViewCell {
    
    static let id = "PhotoCell"
    
    var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = contentView.bounds
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
    }
}
