//
//  SignUpProtocol.swift
//  Instagram
//
//  Created by tiago turibio on 10/07/19.
//  Copyright © 2019 tiago turibio. All rights reserved.
//

import Foundation

protocol SignUpViewProtocol{
    init(controller: SignUpControllerProtocol)
}

protocol SignUpControllerProtocol{
    func handleSignIn()
    func signUpAction()
    func validateSignUpForm()
    func addPhoto()
    var signUpView: SignUpView? { get  set}
}
