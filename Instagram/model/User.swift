//
//  User.swift
//  Instagram
//
//  Created by tiago henrique on 07/11/2017.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import Foundation
import Firebase

class User: Encodable{
    var name: String?
    var profilePictureURL: URL?
    var uid: String?
    
    init?(snapshot: DataSnapshot) {
        guard !snapshot.key.isEmpty else{return nil}
        let uid = snapshot.key
        guard let snapshot = snapshot.value as? [String: Any] else{return nil}
        guard let username = snapshot["username"] as? String else{return nil}
        guard let userProfilePicture = snapshot["userProfilePicture"] as? String else{return nil}
        
        self.name = username
        self.profilePictureURL = URL(string: userProfilePicture)
        self.uid = uid
    }
}
