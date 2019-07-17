//
//  ViewController.swift
//  Instagram
//
//  Created by tiago turibio on 26/10/17.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import UIKit
import Firebase

class SignupController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SignUpControllerProtocol{
    var signUpView: SignUpView?
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
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.2)])
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
        textField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.2)])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.addTarget(self, action: #selector(validateSignUpForm), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor(white: 0, alpha: 0.2)])
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
        return button
    }()
    
    @objc func handleSignIn(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addPhoto(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        var profileImage: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            profileImage = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            profileImage = originalImage
        }
        
        profileImage = profileImage?.withRenderingMode(.alwaysOriginal)
        setProfileImage(profileImage!, button: self.signUpView!.addPhotoImageView)
        dismiss(animated: true, completion: nil)
    }
    
    private func setProfileImage(_ image: UIImage, button: UIButton){
        button.setRoundImage(image, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 3
    }
    
    @objc func signUpAction(){
        do{
            let email = self.signUpView!.emailTextField.text!
            let username = self.signUpView!.userNameTextField.text!
            let password = self.signUpView!.passwordTextField.text!
            self.signUpView!.signUpButton.setAsEnabled(false)
            try signUp(email, username: username, password: password)
        }catch SignUpError.emptyUsername{
            self.signUpView!.userNameTextField.shake()
            self.signUpView!.userNameTextField.becomeFirstResponder()
        }catch SignUpError.invalidEmail{
            self.signUpView!.emailTextField.shake()
            self.signUpView!.emailTextField.becomeFirstResponder()
        }catch SignUpError.invalidPassword{
            self.signUpView!.passwordTextField.shake()
            self.signUpView!.passwordTextField.becomeFirstResponder()
        }catch{
            Alert.showBasic("Login Error", message: "Sorry, there was an error processing your signup proccess", viewController: self, handler: nil)
        }
    }
    
    @objc func validateSignUpForm(){
        let anyEmpty = anyEmptyTextField(signUpView!.userNameTextField,signUpView!.passwordTextField,signUpView!.emailTextField)
        let validEmail = signUpView!.emailTextField.text?.isValidEmail() ?? false
        self.signUpView?.signUpButton.setAsEnabled(!anyEmpty && validEmail)
    }
    
    private func anyEmptyTextField(_ uiTextFields: UITextField...) -> Bool{
        for uiTextField in uiTextFields {
            if uiTextField.text!.count <= 0{
                return true
            }
        }
        return false
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

        UserRepository.createUser(withEmail: email, password: password, success: { (uid) in
            
            guard let image = self.getProfileImage() else{ return }
            guard let uploadData = image.pngData() else { return }
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
        signUpView = SignUpView(controller: self)
        view = signUpView
        validateSignUpForm()
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
