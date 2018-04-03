//
//  Post.swift
//  Instagram
//
//  Created by tiago henrique on 14/12/2017.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import Foundation
import UIKit

struct Post: Encodable{
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
    
    init(caption: String, url: String, creationDate: Double, imageHeight: CGFloat, imageWidth: CGFloat, user: User? = nil){
        self.caption = caption
        self.url = URL(string: url)
        self.creationDate = creationDate
        self.imageHeight = imageHeight
        self.imageWidth = imageWidth
    }
    
    init?(dictionary: Dictionary<String,Any>) {
        guard let uid = dictionary["key"] as? String else{return nil}
        guard let caption = dictionary["caption"] as? String else{return nil}
        guard let url = dictionary["url"] as? String else{return nil}
        guard let creationDate = dictionary["creationDate"] as? Double else{return nil}
        guard let imageHeight = dictionary["imageHeight"] as? CGFloat else{return nil}
        guard let imageWidth = dictionary["imageWidth"] as? CGFloat else{return nil}
        
        self.uid = uid
        self.caption = caption
        self.url = URL(string: url)
        self.creationDate = creationDate
        self.imageHeight = imageHeight
        self.imageWidth = imageWidth
    }
}
