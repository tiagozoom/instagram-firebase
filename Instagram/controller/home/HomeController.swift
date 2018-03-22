//
//  HomeControllerViewController.swift
//  Instagram
//
//  Created by tiago turibio on 19/12/17.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import UIKit
import Photos
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CommentButtonDelegate{

    var posts = [Post]()
    
    let titleView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "Instagram_logo_white").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate func fetchPosts(completion: ((_ posts: [Post]) -> Void)?){
        guard let userID = Auth.auth().currentUser?.uid else {return}
        Database.database().reference().child("following").child(userID).observe(.value, with: { (snapshot) in
            var posts = [Post]()
            snapshot.children.forEach({ (value) in
                if let usersnapshot = value as? DataSnapshot {
                    let uid = usersnapshot.key
                    Database.fetchUser(with: uid) { (user) in
                        if let user = user{
                            Database.database().reference().child("posts").child(uid).queryOrdered(byChild: "creationDate").observe(.value, with: { (snapshot) in
                                snapshot.children.forEach({ (value) in
                                    if let postsSnapshot = value as? DataSnapshot{
                                        if let post = Post(snapshot: postsSnapshot){
                                            post.user = user
                                            posts.append(post)
                                        }
                                    }
                                })
                                if let completion = completion{
                                    completion(posts)
                                }
                            })
                        }
                    }
                }
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = .white
        self.collectionView?.numberOfItems(inSection: 0)
        collectionView?.register(PostCell.self, forCellWithReuseIdentifier: PostCell.ID)
        fetchPosts(completion: loadPosts)
        setupNavigationItems()
    }
    
    fileprivate func loadPosts(posts: [Post]){
        DispatchQueue.main.async { [weak self] in
            self?.posts = posts
            self?.posts.sort(by: { (post1, post2) -> Bool in
                return post1.creationDate.compare(post2.creationDate) == .orderedDescending
            })
            self?.collectionView?.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCell.ID, for: indexPath)
        if let postCell = cell as? PostCell{
            postCell.delegate = self
            postCell.post = posts[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = view.frame.width + 60 + 50 + 80
        return CGSize(width: view.frame.width, height: height)
    }
    
    fileprivate func setupNavigationItems(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), style: .done, target: self, action: nil)
        navigationItem.titleView = titleView
    }
    
    func commentsButtonWasHit(post: Post?) {
        let commentsController = CommentsViewController(collectionViewLayout: UICollectionViewFlowLayout())
        commentsController.post = post
        self.navigationController?.pushViewController(commentsController, animated: true)
    }
}
