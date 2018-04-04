//
//  ProfileImagesRepository.swift
//  Instagram
//
//  Created by tiago turibio on 03/04/18.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import Foundation
import Firebase

class ProfileImagesRepository: RepositoryDelegate{
    static func databaseRef() -> DatabaseReference {
       return Database.database().reference().child("profile_images")
    }
    
    static func storageRef() -> StorageReference {
       return Storage.storage().reference().child("profile_images")
    }
    
    static func uploadImage(with filename: String, uploadData: Data, success: ((String?) -> Void)?, error: @escaping ((Error) -> Void)){
        self.storageRef().child(filename).putData(uploadData, metadata: nil, completion: { (storageMetadata, err) in
            if let err = err{
                error(err)
                return
            }
            
            if let success = success{
                return success(storageMetadata?.downloadURL()?.absoluteString)
            }
        })
    }
}
