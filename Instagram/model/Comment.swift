//
//  Comment.swift
//  Instagram
//
//  Created by tiago turibio on 21/03/18.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import Foundation

struct Comment: Encodable{
    var comment: String?
    var userID: String?
    var user: User?
    var uid: String?
    var creationDate: Date?
    
    init?(dictionary: Dictionary<String,Any>) {
        guard let uid = dictionary["key"] as? String else{return nil}
        guard let userID = dictionary["userID"] as? String else{return nil}
        guard let comment = dictionary["comment"] as? String else{return nil}
        guard let creationDate = dictionary["creationDate"] as? Double else{return nil}
        
        self.userID = userID
        self.comment = comment
        self.creationDate = Date(timeIntervalSince1970: creationDate)
        self.uid = uid
    }
}
