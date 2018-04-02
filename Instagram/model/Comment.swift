//
//  Comment.swift
//  Instagram
//
//  Created by tiago turibio on 21/03/18.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import Foundation
import Firebase

class Comment: Encodable{
    var comment: String?
    var userID: String?
    var user: User?
    var uid: String?
    var creationDate: Date?
    
    init?(snapshot: DataSnapshot) {
        guard !snapshot.key.isEmpty else{return nil}
        let uid = snapshot.key
        guard let snapshot = snapshot.value as? [String: Any] else{return nil}
        guard let userID = snapshot["userID"] as? String else{return nil}
        guard let comment = snapshot["comment"] as? String else{return nil}
        guard let creationDate = snapshot["creationDate"] as? Double else{return nil}
        
        self.userID = userID
        self.comment = comment
        self.creationDate = Date(timeIntervalSince1970: creationDate)
        self.uid = uid
    }
}
