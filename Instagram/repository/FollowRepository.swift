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

    static func fetchFollows(with userId: String, completion: ((String) ->Void)?){
        self.databaseRef().child(userId).observe(.value, with: { (snapshot) in
            snapshot.children.forEach({ (value) in
                if let usersnapshot = value as? DataSnapshot, let completion = completion{
                    completion(usersnapshot.key)
                }
            })
        })
    }
}
