//
//  PostRepository.swift
//  Instagram
//
//  Created by tiago henrique on 29/03/2018.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import Foundation
import Firebase

class PostRepository: RepositoryDelegate{

    struct PostInfo: Codable{
        let URL: String
        let caption: String
        let creationDate: Date
        let imageHeight: CGFloat
        let imageWidth: CGFloat
    }

    static func databaseRef() -> DatabaseReference {
        return Database.database().reference().child("posts")
    }
    
    static func storageRef() -> StorageReference {
        return Storage.storage().reference().child("posts")
    }
    
    static func fetchPostsOrdered(byChild child: String, with userId: String, completion: ((Post) -> Void)?){
        self.databaseRef().child(userId).queryOrdered(byChild: child).observe(.childAdded) { (snapshot) in
            if let post = Post(snapshot: snapshot){
                if let completion = completion{
                    completion(post)
                }
            }
        }
    }
    
    static func fetchPostsByValue(with user: User, completion: (([Post]) -> Void)?){
        self.databaseRef().child(user.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            var posts = [Post]()
            
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
    
    static func fetchPosts(with userId: String, completion: ((Post) -> Void)?){
        self.databaseRef().child(userId).observe(.childAdded) { (snapShot) in
            if let post = Post(snapshot: snapShot){
                if let completion = completion{
                    completion(post)
                }
            }
        }
    }
    
    static func observePostDeletion(with userId: String, posts: [Post], completion: ((Int) -> Void)?){
        self.databaseRef().child(userId).observe(.childRemoved) { (snapShot) in
            if let post = Post(snapshot: snapShot) {
                if let index = posts.index(where: {$0.uid == post.uid}) {
                    if let completion = completion{
                        completion(index)
                    }
                }
            }
        }
    }
    
    static func uploadPostImage(filename: String, uploadData: Data, success: @escaping ((String?) -> Void), error: @escaping ((Error) -> Void)){
        self.storageRef().child(filename).putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err{
               error(err)
               return
            }
            
            success(metadata?.downloadURL()?.absoluteString)
        }
    }
    
    static func save(post: Post,userId: String, success: (() -> Void)?, error: @escaping ((Error) -> Void)){
        self.databaseRef().child(userId).childByAutoId().updateChildValues(post.dictionary!) { (err, dataReference) in
            if let err = err{
                error(err)
                return
            }
            if let success = success{
                success()
            }
        }
    }
}
