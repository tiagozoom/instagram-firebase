//
//  Response.swift
//  Instagram
//
//  Created by tiago turibio on 30/03/18.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import Foundation

class Response: ResponseDelegate{
    
    var value: Any?
    
    func setValue(value: Any?) {
        self.value = value
    }
    
    func getValue() -> Any? {
        return self.value
    }
}
