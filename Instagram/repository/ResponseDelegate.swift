//
//  ResponseDelegate.swift
//  Instagram
//
//  Created by tiago turibio on 30/03/18.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import Foundation

protocol ResponseDelegate{
    func setValue(value: Any?)
    func getValue() -> Any?
}
