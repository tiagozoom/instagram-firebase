//
//  UserRepository.swift
//  Instagram
//
//  Created by tiago henrique on 29/03/2018.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import Foundation
import Firebase

class UserRepository: RepositoryDelegate{
    static func databaseRef() -> DatabaseReference {
        return Database.database().reference().child("users")
    }
    
    static func storageRef() -> StorageReference {
        return Storage.storage().reference().child("users")
    }

    static func fetchUser(with userId: String, completion: ((User) -> Void)?){
        self.databaseRef().child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = User(snapshot: snapshot){
                if let completion = completion{
                    completion(user)
                }
            }
        })
    }
}
