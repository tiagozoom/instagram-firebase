//
//  Post.swift
//  Instagram
//
//  Created by tiago henrique on 14/12/2017.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import Foundation
import Firebase

class Post: NSObject,Encodable{
    var caption: String?
    var url: URL?
    var creationDate: TimeInterval
    var createdAt: Date{
        get{
            return Date(timeIntervalSince1970: creationDate)
        }
    }
    var uid: String?
    var imageHeight: CGFloat
    var imageWidth: CGFloat
    var user: User?
    
    init?(snapshot: DataSnapshot) {
        guard !snapshot.key.isEmpty else{return nil}
        self.uid = snapshot.key
        guard let snapshot = snapshot.value as? [String: Any] else{return nil}
        guard let caption = snapshot["caption"] as? String else{return nil}
        guard let url = snapshot["URL"] as? String else{return nil}
        guard let creationDate = snapshot["creationDate"] as? Double else{return nil}
        guard let imageHeight = snapshot["imageHeight"] as? CGFloat else{return nil}
        guard let imageWidth = snapshot["imageWidth"] as? CGFloat else{return nil}
        
        self.caption = caption
        self.url = URL(string: url)
        self.creationDate = creationDate
        self.imageHeight = imageHeight
        self.imageWidth = imageWidth
    }
    
    init(caption: String, url: String, creationDate: Double, imageHeight: CGFloat, imageWidth: CGFloat) {
        self.caption = caption
        self.url = URL(string: url)
        self.creationDate = creationDate
        self.imageHeight = imageHeight
        self.imageWidth = imageWidth
    }
}
