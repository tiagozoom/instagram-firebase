//
//  UserSearchCellCollectionViewCell.swift
//  Instagram
//
//  Created by tiago henrique on 05/03/2018.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import UIKit
import PINRemoteImage

class UserSearchCellCollectionViewCell: UICollectionViewCell {

    var user: User?{
        didSet{
            loadUser()
        }
    }
    
    static let ID = "UserSearchCellCollectionViewCell"
    
    let userSearchStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 6
        return stackView
    }()
    
    let userProfilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 17.5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }()
    
    let numberOfPosts: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = UIColor(white: 0, alpha: 0.3)
        return label
    }()
    
    fileprivate func setupViews(){
        
        addSubview(userSearchStackView)
        addSubview(userProfilePicture)

        userProfilePicture.anchors(top: nil, right: nil, bottom: nil, left: leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 8, width: 35, height: 35)
        userProfilePicture.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        userSearchStackView.anchors(top: nil, right: rightAnchor, bottom: nil, left: userProfilePicture.rightAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 8, width: 0, height: 0)
        
        userSearchStackView.centerYAnchor.constraint(equalTo: userProfilePicture.centerYAnchor).isActive = true
        
        userSearchStackView.insertArrangedSubview(userName, at: 0)
        userSearchStackView.insertArrangedSubview(numberOfPosts, at: 1)

        insertDivider(with: UIColor(white: 0, alpha: 0.3), top: bottomAnchor, right: rightAnchor, bottom: nil, left: userSearchStackView.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 1)
 
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadUser(){
        if let user = user{
            userName.text = user.name
            self.numberOfPosts.text = "\(user.posts?.count ?? 0)"
            self.userProfilePicture.pin_updateWithProgress = true
            self.userProfilePicture.pin_setImage(from: user.profilePictureURL)
        }
    }
}
