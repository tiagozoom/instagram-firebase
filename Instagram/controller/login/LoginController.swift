//
//  LoginController.swift
//  Instagram
//
//  Created by tiago henrique on 09/11/2017.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import UIKit

class LoginController: UIViewController, LoginControllerProtocol {
    
    var loginView: LoginView?
    
    enum LoginError: Error{
        case invalidEmail
        case invalidPassword
    }
    
    func setLoginButtonState(as enabled: Bool) {
        loginView?.setLoginButtonState(as: enabled)
    }
    
    func handleLogin(email: String, password: String) {
        do {
            setLoginButtonState(as: false)

            try login(withEmail: email, password: password, completion: { [weak self] in
                self?.setLoginButtonState(as: true)
                self?.navigationController?.pushViewController(MainTabController(), animated: true)
            })
        }catch LoginError.invalidEmail{
            self.loginView?.shakeEmailButton()
        }catch LoginError.invalidPassword{
            self.loginView?.shakePasswordButton()
        }catch{
            Alert.showBasic("Login Error", message: "Sorry, there was while trying to log you in. Please try again later.", viewController: self, handler: nil)
        }
    }
    
    func validateLogin(email: String, password: String) {
        let anyEmptyText = anyEmptyTextField(email,password)
        setLoginButtonState(as: !anyEmptyText)
    }
    
    func handleSignUp(){
        navigationController?.pushViewController(SignupController(), animated: true)
    }
    
    func login(withEmail email: String, password: String, completion: (() -> Void)?) throws{
        
        if !email.isValidEmail(){
            throw LoginError.invalidEmail
        }
        
        if password.count < 6 {
            throw LoginError.invalidPassword
        }
    
        UserRepository.login(with: email, password: password, success: completion, error: errorLogin)
    }

    fileprivate func errorLogin(error: Error){
        self.setLoginButtonState(as: true)
        Alert.showBasic("Login Error", message: error.localizedDescription, viewController: self, handler: nil)
    }
    
    private func anyEmptyTextField(_ texts: String...) -> Bool{
        var isEmpty = false
        for text in texts {
            if text.count <= 0{
                isEmpty = true
            }
        }
        return isEmpty
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loginView = LoginView(controller: self)
        view = loginView
        setLoginButtonState(as: false)
        navigationController?.isNavigationBarHidden = true
    }
}
