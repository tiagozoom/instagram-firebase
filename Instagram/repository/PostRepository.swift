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
    static func ref() -> DatabaseReference {
        return Database.database().reference().child("posts")
    }
    
    static func fetchPostsOrdered(byChild child: String, with userId: String, completion: ((Post) -> Void)?){
        self.ref().child(userId).queryOrdered(byChild: child).observe(.value) { (snapShot) in
            if let post = Post(snapshot: snapShot){
                if let completion = completion{
                    completion(post)
                }
            }
        }
    }
    
    static func fetchPosts(byChild child: String, with userId: String, completion: ((Post) -> Void)?){
        self.ref().child(userId).queryOrdered(byChild: child).observe(.childAdded) { (snapShot) in
            if let post = Post(snapshot: snapShot){
                if let completion = completion{
                    completion(post)
                }
            }
        }
    }
    
    static func observePostDeletion(with userId: String, posts: [Post], completion: ((Int) -> Void)?){
        self.ref().child("posts").child(userId).observe(.childRemoved) { (snapShot) in
            if let post = Post(snapshot: snapShot) {
                if let index = posts.index(where: {$0.uid == post.uid}) {
                    if let completion = completion{
                        completion(index)
                    }
                }
            }
        }
    }
}
