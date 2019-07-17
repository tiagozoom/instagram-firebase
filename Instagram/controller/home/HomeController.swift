//
//  HomeControllerViewController.swift
//  Instagram
//
//  Created by tiago turibio on 19/12/17.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import UIKit
import Photos

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CommentButtonDelegate{

    var posts = [Post]()
    
    var refresh: UIRefreshControl!
    
    let instagramLogoView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "Instagram_logo_white").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate func fetchPosts(completion: ((_ posts: [Post]) -> Void)?){
        guard let userID = UserRepository.getLoggedUser()?.uid else {return}
        var userPosts = [Post]()
        let dispatchGroup = DispatchGroup()
        FollowRepository.fetchAll(with: userID) { (uids) in
            UserRepository.fetchAllWith(with: uids, completion: { (users) in
                users.forEach({ (user) in
                    dispatchGroup.enter()
                    PostRepository.fetchAllByValue(with: user, completion: { (posts) in
                        userPosts.append(contentsOf: posts)
                        dispatchGroup.leave()
                    })
                })
                dispatchGroup.notify(queue: DispatchQueue.main) {
                    if let completion = completion {
                        completion(userPosts)
                    }
                }
            })
        }
    }
    
    @objc fileprivate func refreshPosts(){
       self.posts.removeAll()
       self.fetchPosts(completion: loadPosts)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refresh = UIRefreshControl()
        self.refresh.addTarget(self, action: #selector(self.refreshPosts), for: .valueChanged)
        self.collectionView?.refreshControl = self.refresh
        
        self.collectionView?.backgroundColor = .white
        self.collectionView?.numberOfItems(inSection: 0)
        self.collectionView?.register(PostCell.self, forCellWithReuseIdentifier: PostCell.ID)
        
        fetchPosts(completion: loadPosts)
        setupNavigationItems()
    }
    
    fileprivate func loadPosts(posts: [Post]){
        DispatchQueue.main.async { [weak self] in
            self?.posts.append(contentsOf: posts)
            self?.posts.sort(by: { (post1, post2) -> Bool in
                return post1.createdAt.compare(post2.createdAt) == .orderedDescending
            })
            self?.collectionView?.reloadData()
            self?.refresh.endRefreshing()
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
        if let postCell = cell as? PostCell, posts.count > 0{
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
        navigationItem.titleView = instagramLogoView
    }
    
    func commentsButtonWasHit(post: Post?) {
        let commentsController = CommentsTableViewController(style: .plain)
        commentsController.post = post
        commentsController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentsController, animated: true)
    }
}
