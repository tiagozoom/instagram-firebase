//
//  CommentRepository.swift
//  Instagram
//
//  Created by tiago turibio on 01/04/18.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import Foundation
import Firebase

class CommentRepository: RepositoryDelegate{
    static func databaseRef() -> DatabaseReference {
        return Database.database().reference().child("comments")
    }
    
    static func storageRef() -> StorageReference {
        return Storage.storage().reference().child("comments")
    }

    static func fetchAll(with postId: String, completion: ((Comment) -> Void)?){
        self.databaseRef().child(postId).observe(.childAdded) { (snapshot) in
            if let commentDictionary = snapshot.toDictionary(){
                if let comment = Comment(dictionary: commentDictionary), let completion = completion{
                    completion(comment)
                }
            }
        }
    }
}
