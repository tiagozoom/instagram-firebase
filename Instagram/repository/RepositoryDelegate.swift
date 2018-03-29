//
//  RepositoryDelegate.swift
//  Instagram
//
//  Created by tiago henrique on 29/03/2018.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import Foundation
import Firebase

protocol RepositoryDelegate{
    static func ref() -> DatabaseReference
}
