//
//  FollowRepository.swift
//  Instagram
//
//  Created by tiago henrique on 29/03/2018.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import Foundation
import Firebase

class FollowRepository: RepositoryDelegate{
    static func databaseRef() -> DatabaseReference {
        return Database.database().reference().child("following")
    }
    
    static func storageRef() -> StorageReference {
        return Storage.storage().reference().child("following")
    }
    
    static func fetch(with currentUserId: String, userToBeTested: String, completion: @escaping ((Bool) ->Void)){
        self.databaseRef().child(currentUserId).child(userToBeTested).observeSingleEvent(of: .value) { (snapshot) in
            if let followId = snapshot.value as? Int, followId == 1{
                completion(true)
            }else{
                completion(false)
            }
        }
    }

    static func fetchAll(with userId: String, completion: ((String) ->Void)?){
        self.databaseRef().child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            snapshot.children.forEach({ (value) in
                if let usersnapshot = value as? DataSnapshot, let completion = completion{
                    completion(usersnapshot.key)
                }
            })
        })
    }
    
    static func update(with userId: String,userToBeFollowed: String, success: (() ->Void)?, error: @escaping ((Error) -> Void)){
        let values = [userToBeFollowed:1]
        self.databaseRef().child(userId).updateChildValues(values) { (err, reference) in
            if let err = err{
                error(err)
                return
            }
            
            if let success = success{
               success()
            }
        }
    }
    
    static func remove(with userId: String,userToBeUnfollowed: String, success: (() ->Void)?, error: @escaping ((Error) -> Void)){
        self.databaseRef().child(userId).child(userToBeUnfollowed).removeValue(completionBlock: { (err, reference) in
            if let err = err{
                error(err)
                return
            }
            
            if let success = success{
                success()
            }
        })
    }
}
