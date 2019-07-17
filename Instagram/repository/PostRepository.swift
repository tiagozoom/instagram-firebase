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
    
    static func fetchAllOrdered(byChild child: String, with userId: String, completion: ((Post) -> Void)?){
        self.databaseRef().child(userId).queryOrdered(byChild: child).observe(.childAdded) { (snapshot) in
            if let postDictionary = snapshot.toDictionary(){
                if let post = Post(dictionary: postDictionary){
                    if let completion = completion{
                        completion(post)
                    }
                }
            }
        }
    }
    
    static func fetchAllByValue(with user: User, completion: (([Post]) -> Void)?){
        self.databaseRef().child(user.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            var posts = [Post]()
            snapshot.children.forEach({ (value) in
                if let postsnapshot = value as? DataSnapshot, let postDictionary = postsnapshot.toDictionary(){
                    if var post = Post(dictionary: postDictionary ){
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
    
    static func fetchAll(with userId: String, completion: ((Post) -> Void)?){
        self.databaseRef().child(userId).observe(.childAdded) { (snapshot) in
            if let postDictionary = snapshot.toDictionary(){
                if let post = Post(dictionary: postDictionary){
                    if let completion = completion{
                        completion(post)
                    }
                }
            }
        }
    }
    
    static func observeDeletion(with userId: String, posts: [Post], completion: ((Int) -> Void)?){
        self.databaseRef().child(userId).observe(.childRemoved) { (snapshot) in
            if let postDictionary = snapshot.toDictionary(){
                if let post = Post(dictionary: postDictionary){
                    if let index = posts.firstIndex(where: {$0.uid == post.uid}) {
                        if let completion = completion{
                            completion(index)
                        }
                    }
                }
            }
        }
    }
    
    static func uploadImage(filename: String, uploadData: Data, success: @escaping ((String?) -> Void), error: @escaping ((Error) -> Void)){
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
