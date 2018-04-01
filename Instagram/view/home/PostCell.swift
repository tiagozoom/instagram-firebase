//
//  PostCell.swift
//  Instagram
//
//  Created by tiago turibio on 19/12/17.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import Foundation
import UIKit
import PINRemoteImage

protocol CommentButtonDelegate {
    func commentsButtonWasHit(post: Post?)
}

class PostCell: UICollectionViewCell{
    static var ID = "postCell"
    
    var delegate: CommentButtonDelegate?
    
    var post: Post?{
        didSet{
            loadPost(post: post)
        }
    }
    
    let headerContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let footerContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .gray
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let commentsContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .gray
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    let userProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 17.5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let moreOptions: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .black
        return button
    }()
    
    let postImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let likePost: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    lazy var postComment: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(postCommentHandler), for: .touchUpInside)
        return button
    }()
    
    let sharePost: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let savePost: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let postCaption: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let postDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override func prepareForReuse() {
        postImage.image = nil
        userProfileImage.image = nil
    }
    
    fileprivate func setupViews(){
        addSubview(headerContainer)
        addSubview(postImage)
        addSubview(footerContainer)
        addSubview(savePost)
        addSubview(commentsContainer)
        
        headerContainer.addSubview(userProfileImage)
        headerContainer.addSubview(userName)
        headerContainer.addSubview(moreOptions)
        headerContainer.anchors(top: topAnchor, right: rightAnchor, bottom: nil, left: leftAnchor, paddingTop: 0, paddingRight: -16, paddingBottom: 0, paddingLeft: 8, width: 0, height: 60)
        
        userProfileImage.anchors(top: nil, right: nil, bottom: nil, left: headerContainer.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 35, height: 35)
        userName.anchors(top: nil, right: moreOptions.leftAnchor, bottom: nil, left: userProfileImage.rightAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 8, width: 0, height: 0)
        moreOptions.anchors(top: headerContainer.topAnchor, right: headerContainer.rightAnchor, bottom: nil, left: nil, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 44, height: 0)
        userName.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor, constant: 0).isActive = true
        userProfileImage.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor, constant: 0).isActive = true
        moreOptions.centerYAnchor.constraint(equalTo: userProfileImage.centerYAnchor, constant: 0).isActive = true
        
        postImage.anchors(top: headerContainer.bottomAnchor, right: rightAnchor, bottom: nil, left: leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        postImage.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        footerContainer.anchors(top: postImage.bottomAnchor, right: nil, bottom: nil, left: leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 120, height: 50)
        footerContainer.insertArrangedSubview(likePost, at: 0)
        footerContainer.insertArrangedSubview(postComment, at: 1)
        footerContainer.insertArrangedSubview(sharePost, at: 2)
        
        savePost.anchors(top: postImage.bottomAnchor, right: rightAnchor, bottom: nil, left: nil, paddingTop: 0, paddingRight: -8, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        savePost.centerYAnchor.constraint(equalTo: footerContainer.centerYAnchor).isActive = true
        
        commentsContainer.anchors(top: footerContainer.bottomAnchor, right: rightAnchor, bottom: nil, left: leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 8, width: 0, height: 0)
        commentsContainer.insertArrangedSubview(postCaption, at: 0)
        commentsContainer.insertArrangedSubview(postDate, at: 1)
    }
    
    func loadPost(post: Post?){
        if let post = post{
            if let user = post.user{
                userName.text = user.name
                self.userProfileImage.pin_setImage(from: user.profilePictureURL)
            }
            
            self.postImage.pin_updateWithProgress = true
            self.postImage.pin_setImage(from: post.url)
            
            postDate.text = post.creationDate.timeAgoSinceDate()
            setupAttributedPostCaption(post: post)
        }
    }
    
    @objc func postCommentHandler(){
       self.delegate?.commentsButtonWasHit(post: post)
    }
    

    fileprivate func setupAttributedPostCaption(post: Post){
        guard let user = post.user else {return}
        let attributedText = NSMutableAttributedString(string: user.name!, attributes: [.font: UIFont.boldSystemFont(ofSize: 15)])
        attributedText.append(NSAttributedString(string: " "+post.caption!, attributes: [.font : UIFont.systemFont(ofSize: 15)]))
        self.postCaption.attributedText = attributedText
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
