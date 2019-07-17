//
//  UserPhotoCell.swift
//  Instagram
//
//  Created by tiago henrique on 14/11/2017.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import UIKit

class ImageSelectionCell: UICollectionViewCell {
    
    var photo: UIImage?{
        didSet{
            updateUI()
        }
    }
    
    static var ID = "userPhotoCellId"
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
        }()
    
    func updateUI(){
        userImageView.image = photo
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(userImageView)
        userImageView.anchors(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
