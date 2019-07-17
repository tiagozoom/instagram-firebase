//
//  CommentsViewCell.swift
//  Instagram
//
//  Created by tiago turibio on 21/03/18.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import UIKit

class CommentsViewCell: UITableViewCell {
    var comment: Comment?{
        didSet{
            loadComment()
        }
    }
    
    static let ID = "CommentsViewCell"
    
    let commentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .top
        stackView.spacing = 22
        return stackView
    }()
    
    let userCommentaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 6
        return stackView
    }()
    
    let userProfilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 22.5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let commentary: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    fileprivate func setupViews(){
        
        addSubview(commentStackView)
        
        commentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        commentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        commentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        commentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        commentStackView.insertArrangedSubview(userProfilePicture, at: 0)
        commentStackView.insertArrangedSubview(userCommentaryStackView, at: 1)
        
        userProfilePicture.heightAnchor.constraint(equalToConstant: 45).isActive = true
        userProfilePicture.widthAnchor.constraint(equalToConstant: 45).isActive = true

        userCommentaryStackView.insertArrangedSubview(userName, at: 0)
        userCommentaryStackView.insertArrangedSubview(commentary, at: 1)
        
        insertDivider(with: UIColor(white: 0, alpha: 0.3), top: bottomAnchor, right: commentStackView.rightAnchor, bottom: nil, left: userCommentaryStackView.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 1)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func loadComment(){
        if let comment = comment, let user = comment.user{
            userName.text = user.name
            self.userProfilePicture.pin_updateWithProgress = true
            self.userProfilePicture.pin_setImage(from: user.profilePictureURL)
            self.commentary.text = comment.comment
        }
    }
}
