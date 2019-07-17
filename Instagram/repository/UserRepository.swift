//
//  UserRepository.swift
//  Instagram
//
//  Created by tiago henrique on 29/03/2018.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import Foundation
import Firebase

class UserRepository: RepositoryDelegate{
    static let dispatchGroup = DispatchGroup()
    
    static func authRef() -> Auth{
        return Auth.auth()
    }
   
    static func databaseRef() -> DatabaseReference {
        return Database.database().reference().child("users")
    }
    
    static func storageRef() -> StorageReference {
        return Storage.storage().reference().child("users")
    }
    
    static func fetchAll(completion: (([User]) -> Void)?){
        self.databaseRef().observeSingleEvent(of: .value, with: { (snapshot) in
            var users = [User]()
            snapshot.children.forEach({ (value) in
                if let userSnapshot = value as? DataSnapshot, let userDictionary = userSnapshot.toDictionary(){
                    if var user = User(dictionary: userDictionary),user.uid != Auth.auth().currentUser?.uid{
                        UserRepository.dispatchGroup.enter()
                        PostRepository.fetchAllByValue(with: user, completion: { (posts) in
                            user.posts = posts
                            users.append(user)
                            UserRepository.dispatchGroup.leave()
                        })
                    }
                }
            })
            UserRepository.dispatchGroup.notify(queue: DispatchQueue.main) {
                if let completion = completion{
                    completion(users)
                }
            }
        })
    }
    
    static func fetchAllWith(with userIds: [String], completion: (([User]) -> Void)?){
        self.databaseRef().observeSingleEvent(of: .value, with: { (snapshot) in
            var users = [User]()
            snapshot.children.forEach({ (value) in
                if let userSnapshot = value as? DataSnapshot, let userDictionary = userSnapshot.toDictionary(){
                    if var user = User(dictionary: userDictionary),user.uid != Auth.auth().currentUser?.uid, (userIds.firstIndex(of: user.uid!) != nil){
                        UserRepository.dispatchGroup.enter()
                        PostRepository.fetchAllByValue(with: user, completion: { (posts) in
                            user.posts = posts
                            users.append(user)
                            UserRepository.dispatchGroup.leave()
                        })
                    }
                }
            })
            UserRepository.dispatchGroup.notify(queue: DispatchQueue.main) {
                if let completion = completion{
                    completion(users)
                }
            }
        })
    }
    
    static func fetch(with userId: String, completion: ((User) -> Void)?){
        self.databaseRef().child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userDictionary = snapshot.toDictionary(){
                if let user = User(dictionary: userDictionary){
                    if let completion = completion{
                        completion(user)
                    }
                }
            }
        })
    }
    
    static func login(with email: String, password: String, success: (() -> Void)?, error: @escaping ((Error) -> Void)){
        self.authRef().signIn(withEmail: email, password: password) { (user, err) in
            if let err = err{
                error(err)
                return
            }
            
            if let success = success{
                success()
            }
        }
    }
    
    static func getLoggedUser() -> FirebaseAuth.User?{
        return self.authRef().currentUser
    }
    
    static func createUser(withEmail email: String, password: String, success: ((String?) -> Void)?, error: @escaping ((Error) -> Void)){
        self.authRef().createUser(withEmail: email , password: password) { (user, err) in
            if let err = err{
                error(err)
                return
            }
            
            if let success = success{
                success(user?.uid)
            }
        }
    }
    
    static func update(user: User, success: (() -> Void)?, error: @escaping ((Error) -> Void)){
        let userDictionary = [user.uid!:user.dictionary!]
        self.databaseRef().updateChildValues(userDictionary, withCompletionBlock: { (err, databaseReference) in
            if let err = err{
                error(err)
                return
            }
            
            if let success = success{
                success()
            }
        })
    }
}
