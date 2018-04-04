//
//  ViewController.swift
//  Instagram
//
//  Created by tiago turibio on 26/10/17.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import UIKit
import Firebase

class SignupController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    enum SignUpError: Error{
        case emptyUsername
        case invalidEmail
        case invalidPassword
    }
    
    let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor : UIColor(white: 0, alpha: 0.2)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.addTarget(self, action: #selector(validateSignUpForm), for: .editingChanged)
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedStringKey.foregroundColor : UIColor(white: 0, alpha: 0.2)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.addTarget(self, action: #selector(validateSignUpForm), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor : UIColor(white: 0, alpha: 0.2)])
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.addTarget(self, action: #selector(validateSignUpForm), for: .editingChanged)
        return textField
    }()
    
    let inputFieldsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
        return button
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        
        let normalText = "Already have an account? "
        let buttonText = NSMutableAttributedString(string:normalText, attributes: [.foregroundColor: UIColor.lightGray])
        
        let boldText = "Login"
        let attributedString = NSMutableAttributedString(string: boldText, attributes: [.font : UIFont.boldSystemFont(ofSize: 15), .foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)])
        
        buttonText.append(attributedString)
        button.setAttributedTitle(buttonText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLogin(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addPhoto(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var profileImage: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            profileImage = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            profileImage = originalImage
        }
        
        profileImage = profileImage?.withRenderingMode(.alwaysOriginal)
        setProfileImage(profileImage!, button: addPhotoButton)
        dismiss(animated: true, completion: nil)
    }
    
    private func setProfileImage(_ image: UIImage, button: UIButton){
        button.setRoundImage(image, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 3
    }
    
    @objc func signUpAction(){
        do{
            let email = emailTextField.text!
            let username = usernameTextField.text!
            let password = passwordTextField.text!
            signUpButton.setAsEnabled(false)
            try signUp(email, username: username, password: password)
        }catch SignUpError.emptyUsername{
            usernameTextField.shake()
            usernameTextField.becomeFirstResponder()
        }catch SignUpError.invalidEmail{
            emailTextField.shake()
            emailTextField.becomeFirstResponder()
        }catch SignUpError.invalidPassword{
            passwordTextField.shake()
            passwordTextField.becomeFirstResponder()
        }catch{
            Alert.showBasic("Login Error", message: "Sorry, there was an error processing your signup proccess", viewController: self, handler: nil)
        }
    }
    
    @objc func validateSignUpForm(){
        let anyEmpty = anyEmptyTextField(usernameTextField,passwordTextField,emailTextField)
        signUpButton.setAsEnabled(!anyEmpty)
    }
    
    private func anyEmptyTextField(_ uiTextFields: UITextField...) -> Bool{
        var isEmpty = false
        for uiTextField in uiTextFields {
            if uiTextField.text!.count <= 0{
                isEmpty = true
            }
        }
        return isEmpty
    }
    
    private func signUp(_ email: String, username: String, password: String) throws{
        
        if !email.isValidEmail(){
            throw SignUpError.invalidEmail
        }
        
        if username.count <= 0{
            throw SignUpError.emptyUsername
        }
        
        if password.count < 6{
            throw SignUpError.invalidPassword
        }
        
        if let email = emailTextField.text, let password = passwordTextField.text{
            
            UserRepository.createUser(withEmail: email, password: password, success: { (uid) in
                
                guard let image = self.getProfileImage() else{ return }
                guard let uploadData = UIImagePNGRepresentation(image) else { return }
                let filename = NSUUID().uuidString
                
                ProfileImagesRepository.uploadImage(with: filename, uploadData: uploadData, success: { (absoluteString) in
                    
                    guard let uid = uid else {return}
                    let user = User(name: username, profilePicture: absoluteString!, uid: uid)
                    
                    UserRepository.update(user: user, success: {
                        
                        FollowRepository.update(with: user.uid!, userToBeFollowed: user.uid!,success: self.signupSuccess, error: self.signupError)
                        
                    }, error: self.signupError)
                    
                }, error: self.signupError)
                
            }, error: self.signupError)
        }
    }
    
    fileprivate func signupSuccess(){
        self.present(MainTabController(), animated: true, completion: nil)
    }
    
    fileprivate func signupError(error: Error){
        Alert.showBasic("Login Error", message: error.localizedDescription, viewController: self, handler: nil)
        self.signUpButton.setAsEnabled(true)
    }

    private func getProfileImage() -> UIImage?{
        return addPhotoButton.currentImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        inputFieldsStackView.insertArrangedSubview(emailTextField, at: 0)
        inputFieldsStackView.insertArrangedSubview(usernameTextField, at: 1)
        inputFieldsStackView.insertArrangedSubview(passwordTextField, at: 2)
        inputFieldsStackView.insertArrangedSubview(signUpButton, at: 3)
        
        view.addSubview(addPhotoButton)
        view.addSubview(inputFieldsStackView)
        view.addSubview(loginButton)
        
        addPhotoButton.anchors(top: view.topAnchor, right: nil, bottom: nil, left: nil, paddingTop: 40, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 140, height: 140)
        
        addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        inputFieldsStackView.anchors(top: addPhotoButton.bottomAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, paddingTop: 20, paddingRight: -40, paddingBottom: 0, paddingLeft: 40, width: nil, height: 200)
        
        loginButton.anchors(top: nil, right: nil, bottom: self.view.bottomAnchor, left: nil, paddingTop: 0, paddingRight: 0, paddingBottom: -20, paddingLeft: 0, width: 0, height: 0)
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        validateSignUpForm()
    }
}

