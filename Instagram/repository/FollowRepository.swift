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
    static func ref() -> DatabaseReference {
        return Database.database().reference().child("following")
    }
    
    static func fetchFollows(with userId: String, completion: ((DataSnapshot) ->Void)?){
        self.ref().child(userId).observe(.value, with: { (snapshot) in
            if let completion = completion{
                completion(snapshot)
            }
        })
    }
}
