//
//  LoginView.swift
//  Instagram
//
//  Created by tiago turibio on 11/11/17.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import Foundation
import UIKit

class LoginView: UIView, LoginViewProtocol{
    
    var controller: LoginControllerProtocol?
    
    required init(controller: LoginControllerProtocol) {
        super.init(frame: CGRect())
        
        self.controller = controller
        
        self.backgroundColor = UIColor.white
        self.addSubview(loginStackView)
        self.addSubview(signUpButton)
        self.addSubview(instagramLogoBackground)
        
        instagramLogoBackground.addSubview(instagramLogo)
        
        instagramLogoBackground.anchors(top: self.topAnchor, right: self.rightAnchor, bottom: nil, left: self.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 200)
        instagramLogo.centerXAnchor.constraint(equalTo: instagramLogoBackground.centerXAnchor).isActive = true
        instagramLogo.centerYAnchor.constraint(equalTo: instagramLogoBackground.centerYAnchor).isActive = true
        
        loginStackView.insertArrangedSubview(emailTextField, at: 0)
        loginStackView.insertArrangedSubview(passwordTextField, at: 1)
        loginStackView.insertArrangedSubview(loginButton, at: 2)
        loginStackView.anchors(top: instagramLogoBackground.bottomAnchor, right: self.rightAnchor, bottom: nil, left: self.leftAnchor, paddingTop: 40, paddingRight: -20, paddingBottom: 0, paddingLeft: 20, width: 0, height: 150)
        
        signUpButton.anchors(top: nil, right: nil, bottom: self.bottomAnchor, left: nil, paddingTop: 0, paddingRight: 0, paddingBottom: -20, paddingLeft: 0, width: 0, height: 0)
        signUpButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()
    
    let instagramLogoBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let instagramLogo: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.2)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(validateLogin), for: .editingChanged)
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.2)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(validateLogin), for: .editingChanged)
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        let normalText = "Don't have an account? "
        let buttonText = NSMutableAttributedString(string:normalText, attributes: [.foregroundColor: UIColor.lightGray])
        let boldText = "Sign Up"
        let attributedString = NSMutableAttributedString(string: boldText, attributes: [.font : UIFont.boldSystemFont(ofSize: 15), .foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)])
        buttonText.append(attributedString)
        button.setAttributedTitle(buttonText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLogin(){
        self.controller?.handleLogin(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @objc func validateLogin(){
        self.controller?.validateLogin(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @objc func handleSignUp(){
        self.controller?.handleSignUp()
    }
    
    func setLoginButtonState(as enabled: Bool){
        loginButton.setAsEnabled(enabled)
    }
    
    func shakeEmailButton(){
        emailTextField.shake()
        emailTextField.becomeFirstResponder()
    }
    
    func shakePasswordButton(){
        passwordTextField.shake()
        passwordTextField.becomeFirstResponder()
    }
    
}
