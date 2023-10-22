//
//  PhotoViewCell.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 16/10/2023.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {
    
    static let id = "PhotoCell"
    
    var image = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        image.frame = contentView.bounds
        addSubview(image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
    }
}
