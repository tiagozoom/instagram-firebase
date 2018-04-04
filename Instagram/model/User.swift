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
    var profilePictureURL: URL?
    var profilePicture: String?{
        get{
            return profilePictureURL?.absoluteString
        }
    }
    var uid: String?
    
    init?(dictionary: Dictionary<String,Any>) {
        guard let uid = dictionary["key"] as? String else{return nil}
        guard let username = dictionary["username"] as? String else{return nil}
        guard let userProfilePicture = dictionary["userProfilePicture"] as? String else{return nil}
        
        self.name = username
        self.profilePictureURL = URL(string: userProfilePicture)
        self.uid = uid
    }
    
    init(name: String, profilePictureURL: URL, uid: String){
        self.name = name
        self.profilePictureURL = profilePictureURL
        self.uid = uid
    }
}
