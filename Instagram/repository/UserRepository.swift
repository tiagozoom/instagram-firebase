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
    
    static func ref() -> DatabaseReference {
        return Database.database().reference().child("users")
    }
    
    static func fetchUser(with userId: String, completion: ((User) -> Void)?){
        self.ref().child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = User(snapshot: snapshot){
                if let completion = completion{
                    completion(user)
                }
            }
        })
    }
}
