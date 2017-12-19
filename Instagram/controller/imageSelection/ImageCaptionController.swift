//
//  ImageCaptionController.swift
//  Instagram
//
//  Created by tiago turibio on 07/12/17.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import UIKit
import Firebase

class ImageCaptionController: UIViewController {
    
    enum ImageUpoadException: Error{
        case userNotLoggedIn
        case imageNotFound
        case captionNotFound
    }
    
    var user: User?
    var selectedImage = UIImage(){
        didSet{
            selectedImageView.image = selectedImage
        }
    }
    
    let loadingIcon: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let captionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        setupViews()
        setupNavigationItems(navigationItem: self.navigationItem)
    }
    
    fileprivate func setupViews(){
        view.addSubview(containerView)
        view.addSubview(loadingIcon)
        containerView.addSubview(selectedImageView)
        containerView.addSubview(captionTextView)
        
        containerView.anchors(top: view.topAnchor, right: view.rightAnchor, bottom: nil, left: view.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 100)
        
        selectedImageView.anchors(top: containerView.topAnchor, right: nil, bottom: nil, left: containerView.leftAnchor, paddingTop: 8, paddingRight: 0, paddingBottom: 0, paddingLeft: 8, width: 84, height: 84)
        
        captionTextView.anchors(top: containerView.topAnchor, right: containerView.rightAnchor, bottom: containerView.bottomAnchor, left: selectedImageView.rightAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 8, width: 0, height: 0)
        
        loadingIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupNavigationItems(navigationItem: UINavigationItem){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(shareHandler))
    }
    
    @objc fileprivate func shareHandler(){
        do {
            try uploadImage(selectedImage,imageCaption: self.captionTextView.text, completion: dismissScreen)
            startLoadingAnimation()
        } catch ImageUpoadException.captionNotFound {
            Alert.showBasic("Upload Error", message: "Sorry, but you need to feel in the image caption", viewController: self, handler: nil)
        }catch ImageUpoadException.imageNotFound {
            Alert.showBasic("Upload Error", message: "Sorry, an error occurred. We could not find an image to upload", viewController: self, handler: nil)
        }catch ImageUpoadException.userNotLoggedIn {
            Alert.showBasic("Upload Error", message: "Sorry, but you need to be logged in to upload an image", viewController: self, handler: nil)
        }catch{
            Alert.showBasic("Upload Error", message: "Sorry, an error occurred", viewController: self, handler: nil)
        }
    }
    
    fileprivate func startLoadingAnimation(){
        navigationController?.navigationBar.disable()
        loadingIcon.startAnimating()
    }
    
    fileprivate func uploadImage(_ image: UIImage, imageCaption: String? , completion: (() -> Void)?) throws{
        guard let uploadData = UIImageJPEGRepresentation(selectedImage, 0.5) else{throw ImageUpoadException.imageNotFound}
        guard let userUID = Auth.auth().currentUser?.uid else { throw ImageUpoadException.userNotLoggedIn }
        guard let imageCaption = imageCaption else {throw ImageUpoadException.captionNotFound}
        
        if imageCaption.count <= 0{
            throw ImageUpoadException.captionNotFound
        }
        
        let filename = NSUUID().uuidString
        
        Storage.storage().reference().child("posts").child(filename).putData(uploadData, metadata: nil) { [weak self] (metadata, error) in
            if let error = error{
                print(error)
                return
            }
            if let imageURL = metadata?.downloadURL()?.absoluteString {
                self?.saveToDatabase(imageURL: imageURL, imageCaption: imageCaption, userUID: userUID, completion: completion)
            }
        }
    }
    
    fileprivate func saveToDatabase(imageURL: String, imageCaption: String, userUID: String, completion: (() -> Void)?){
        let postsInfoDictionary = ["imageURL":imageURL,"imageCaption": imageCaption]
        Database.database().reference().child("posts").child(userUID).childByAutoId().updateChildValues(postsInfoDictionary) { (error, dataReference) in
            if let error = error{
                print(error)
                return
            }
            
            if let completion = completion{
                completion()
            }
        }
    }
    
    func dismissScreen(){
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}
