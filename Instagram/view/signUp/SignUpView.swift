//
//  SignUpView.swift
//  Instagram
//
//  Created by tiago turibio on 10/07/19.
//  Copyright © 2019 tiago turibio. All rights reserved.
//

import Foundation
import UIKit

class SignUpView: UIView, SignUpViewProtocol{
    var controller: SignUpControllerProtocol?
    
    let signUpStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = UIStackView.Alignment.center
        stackView.distribution = .fillProportionally
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let formStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let addPhotoImageView: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.2)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(validateSignUpForm), for: .editingChanged)
        return textField
    }()
    
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.2)])
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.addTarget(self, action: #selector(validateSignUpForm), for: .editingChanged)
        return textField
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.2)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.addTarget(self, action: #selector(validateSignUpForm), for: .editingChanged)
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
        return button
    }()
    
    let signInButton: UIButton = {
        let button = UIButton()
        let haveAnAccountText = NSMutableAttributedString(string: "Already have an account? ", attributes: [.foregroundColor: UIColor.lightGray])
        let signInText = NSMutableAttributedString(string: "Sign In", attributes: [.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237), .font: UIFont.boldSystemFont(ofSize: 15)])
        haveAnAccountText.append(signInText)
        button.setAttributedTitle(haveAnAccountText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSignIn), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func handleSignIn(){
        self.controller?.handleSignIn()
    }
    
    @objc func signUpAction(){
        self.controller?.signUpAction()
    }
    
    @objc func validateSignUpForm(){
        self.controller?.validateSignUpForm()
    }
    
    @objc func addPhoto(){
        self.controller?.addPhoto()
    }
    
    required init(controller: SignUpControllerProtocol) {
        super.init(frame: CGRect())
        self.controller = controller
        self.backgroundColor = UIColor.white
        formStackView.insertArrangedSubview(emailTextField, at: 0)
        formStackView.insertArrangedSubview(userNameTextField, at: 1)
        formStackView.insertArrangedSubview(passwordTextField, at: 2)
        formStackView.insertArrangedSubview(signUpButton, at: 3)
        signUpStackView.insertArrangedSubview(addPhotoImageView, at: 0)
        signUpStackView.insertArrangedSubview(formStackView, at: 1)
        self.addSubview(signUpStackView)
        self.addSubview(signInButton)
        signUpStackView.anchors(top: topAnchor, right: rightAnchor, bottom: nil, left: leftAnchor, paddingTop: 60, paddingRight: -40, paddingBottom: 0, paddingLeft: 40, width: 0, height: 360)
        addPhotoImageView.anchors(top: signUpStackView.topAnchor, right: nil, bottom: nil, left: nil, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 140, height: 140)
        formStackView.anchors(top: addPhotoImageView.bottomAnchor, right: signUpStackView.rightAnchor, bottom: nil, left: signUpStackView.leftAnchor, paddingTop: nil, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
        signInButton.anchors(top: nil, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: -20, paddingLeft: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
