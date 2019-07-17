//
//  User.swift
//  Instagram
//
//  Created by tiago henrique on 07/11/2017.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import Foundation

struct User: Encodable{
    var name: String?
    var profilePicture: String?
    var uid: String?
    var posts: [Post]?
    var profilePictureURL: URL?{
        get{
            return URL(string: profilePicture!)
        }
    }
    
    init?(dictionary: Dictionary<String,Any>) {
        guard let uid = dictionary["uid"] as? String else{return nil}
        guard let username = dictionary["name"] as? String else{return nil}
        guard let userProfilePicture = dictionary["profilePicture"] as? String else{return nil}
        
        self.name = username
        self.profilePicture = userProfilePicture
        self.uid = uid
    }
    
    init(name: String, profilePicture: String, uid: String){
        self.name = name
        self.profilePicture = profilePicture
        self.uid = uid
    }
}
