//
//  UserProfileController.swift
//  Instagram
//
//  Created by tiago turibio on 06/11/17.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var posts = [Post]()
    var imageCache = [String:UIImage]()
    var userProfilePictureURL: String?
    var user: User?{
        didSet{
            navigationItem.title = user?.name
        }
    }
    
    enum FetchUserError: Error{
        case notLoggedIn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: UserProfileHeader.ID)
        collectionView?.register(PostCellCollectionViewCell.self, forCellWithReuseIdentifier: PostCellCollectionViewCell.ID)
        setupNavigationItem(navigationItem)
        do {
           try fetchUser()
           observePostsAddition()
           observePostsDeletion()
        }catch FetchUserError.notLoggedIn{
            Alert.showBasic("User Error", message: "Sorry but you have to log in", viewController: self, handler: nil)
        }catch{
            Alert.showBasic("User Info Error", message: error.localizedDescription, viewController: self, handler: nil)
        }
    }
    
    fileprivate func observePostsAddition(){
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("posts").child(userUID).queryOrdered(byChild: "creationDate").observe(.childAdded) { [weak self] (snapShot) in
            if let post = Post(snapshot: snapShot){
                self?.loadImage(post: post)
            }
        }
    }
    
    fileprivate func observePostsDeletion(){
        guard let userUID = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("posts").child(userUID).observe(.childRemoved) { [weak self] (snapShot) in
            if let post = Post(snapshot: snapShot){
                if let index = self?.posts.index(where: {$0.uid == post.uid}) {
                    self?.remoteFromImage(from: index)
                }
            }
        }
    }
    
    fileprivate func fetchUser() throws{
        guard let userUID = Auth.auth().currentUser?.uid else { throw FetchUserError.notLoggedIn }
        Database.fetchUser(with: userUID,completion: { (user) in
            DispatchQueue.main.async { [weak self] in
                self?.user = user
                self?.collectionView?.reloadSections(IndexSet(integer: 0))
            }
        })
    }
    
    fileprivate func loadImage(post:Post){
        self.collectionView?.numberOfItems(inSection: 0)
        self.posts.insert(post, at: 0)
        self.collectionView?.insertItems(at: [IndexPath(row: 0, section: 0)])
    }
    fileprivate func remoteFromImage(from index:Int){
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
                try Auth.auth().signOut()
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
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCellCollectionViewCell.ID, for: indexPath)
        if let postCell = cell as? PostCellCollectionViewCell{
            let post = self.posts[indexPath.row]
            let urlString = post.url?.absoluteString

            if let image = imageCache[urlString!]{
                postCell.imageView.image = image
                return cell
            }
            
            self.fetchImages(with: post, completion: { [weak self] (data,post) in
                DispatchQueue.main.async {
                    let image = UIImage(data: data)
                    if urlString! == post.url!.absoluteString, postCell.imageView.image == nil{
                        postCell.imageView.image = image
                    }
                    self?.imageCache[post.url!.absoluteString] = image
                }
            })
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
}
