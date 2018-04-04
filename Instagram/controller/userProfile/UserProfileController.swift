//
//  UserProfileController.swift
//  Instagram
//
//  Created by tiago turibio on 06/11/17.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import UIKit

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout,UserProfileEditButtonDelegate {

    var hideFollowButton: Bool = true
    var posts = [Post]()
    var imageCache = [String:UIImage]()

    var user: User?{
        didSet{
            navigationItem.title = user?.name
            observePostsAddition()
            observePostsDeletion()
        }
    }
    
    var userUID: String?
    
    enum FetchUserError: Error{
        case notLoggedIn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UserProfileHeader.ID)
        collectionView?.register(PostCellCollectionViewCell.self, forCellWithReuseIdentifier: PostCellCollectionViewCell.ID)
        setupNavigationItem(navigationItem)
        
        if user == nil{
            do {
                try fetchUser()
            }catch FetchUserError.notLoggedIn{
                Alert.showBasic("User Error", message: "Sorry but you have to log in", viewController: self, handler: nil)
            }catch{
                Alert.showBasic("User Info Error", message: error.localizedDescription, viewController: self, handler: nil)
            }
        }
    }
    
    fileprivate func observePostsAddition(){
        guard let userUID = user?.uid else{ return}
        PostRepository.fetchAllOrdered(byChild: "creationDate", with: userUID , completion: self.loadImage)
    }
    
    fileprivate func observePostsDeletion(){
        guard let userUID = user?.uid else{ return}
        PostRepository.observeDeletion(with: userUID, posts: self.posts, completion: self.removeImage)
    }
    
    fileprivate func fetchUser() throws{
        guard let userUID = self.userUID ?? UserRepository.authRef().currentUser?.uid else{throw FetchUserError.notLoggedIn}
        UserRepository.fetch(with: userUID, completion: self.loadUser)
    }
    
    fileprivate func loadUser(user: User){
        DispatchQueue.main.async { [weak self] in
            self?.user = user
            self?.collectionView?.reloadSections(IndexSet(integer: 0))
        }
    }
    
    fileprivate func loadImage(post:Post){
        self.collectionView?.numberOfItems(inSection: 0)
        self.posts.insert(post, at: 0)
        self.collectionView?.insertItems(at: [IndexPath(row: 0, section: 0)])
    }
    fileprivate func removeImage(from index:Int){
        DispatchQueue.main.async {
            self.collectionView?.numberOfItems(inSection: 0)
            self.posts.remove(at: index)
            self.collectionView?.deleteItems(at: [IndexPath(row: index, section: 0)])
        }
    }
    
    fileprivate func fetchImages(with post: Post, completion: (((Data,Post)) -> Void)?){
        if let url = post.url{
            let session = URLSession(configuration: .default)
            session.dataTask(with: url, completionHandler: { (data, response, error) in
                if let data = data, let completion = completion{
                    completion((data, post))
                }
            }).resume()
        }
    }
    
    fileprivate func setupNavigationItem(_ navigationItem: UINavigationItem){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc func handleLogout(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("logout", comment: ""), style: .destructive, handler: { [weak self] (_) in
            do{
                try UserRepository.authRef().signOut()
                self?.present(LoginNavigationController(), animated: true, completion: nil)
            }catch let signOutError as NSError{
                Alert.showBasic("Sign Out error", message: signOutError.localizedDescription, viewController: self!, handler: nil)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    func setTitle(_ title: String){
        navigationItem.title = title
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UserProfileHeader.ID, for: indexPath)
        if let userProfileHeader = header as? UserProfileHeader{
            userProfileHeader.user = self.user
            userProfileHeader.delegate = self
            
            if (hideFollowButton){
                userProfileHeader.setupEditButton()
            }else{
                userIsFollowing(completion: { (isFollowing) in
                    (isFollowing) ? userProfileHeader.setupUnfollowButton() : userProfileHeader.setupFollowButton()
                })
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCellCollectionViewCell.ID, for: indexPath)
        if let postCell = cell as? PostCellCollectionViewCell{
            postCell.post = self.posts[indexPath.row]
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //Horizontal and vertical spacing between cells is 1 pixel each
        let size = (self.view.frame.width - 2) / 3
        return CGSize(width: size , height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func editWasHit() {
        print("edit was hit")
    }
    
    func followWasHit() {
        guard let userToBeFollowed = user?.uid else{return}
        guard let currentUserId = UserRepository.authRef().currentUser?.uid else {return}
        FollowRepository.update(with: currentUserId, userToBeFollowed: userToBeFollowed, success: self.successUpdatingFollows, error: self.errorUpdatingFollows)
    }
    
    func unfollowWashit() {
        guard let userToBeUnfollowed = user?.uid else{return}
        guard let currentUserId = UserRepository.authRef().currentUser?.uid else {return}
        FollowRepository.remove(with: currentUserId, userToBeUnfollowed: userToBeUnfollowed, success: self.successUpdatingFollows, error: self.errorUpdatingFollows)
    }
    
    fileprivate func successUpdatingFollows(){
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    fileprivate func errorUpdatingFollows(error: Error){
       print(error.localizedDescription)
    }
    
    func userIsFollowing(completion: @escaping ((_ isFollowing: Bool) -> Void)){
        guard let userToBeTested = user?.uid else{return}
        guard let currentUserId = UserRepository.getLoggedUser()?.uid else {return}
        FollowRepository.fetch(with: currentUserId, userToBeTested: userToBeTested, completion: completion)
    }
}
