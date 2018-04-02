//
//  imageSelectorNavigationControler.swift
//  Instagram
//
//  Created by tiago turibio on 13/11/17.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import UIKit
import Photos

class ImageSelectionController: UIViewController,ImageSelectorControllerProtocol,UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate {
    var imageSelectionView: ImageSelectionView?
    let imageSizeForCell = CGSize(width: 200, height: 200)
    let imageSizeForHeader = CGSize(width: 600, height: 600)
    let header = ImageSelectionHeader()
    var selectedImage = UIImage(){
        didSet{
            updateHeaderImage(selectedImage)
            self.imageSelectionView?.pullHeaderDown()
        }
    }
    var images = [(image: UIImage,asset: PHAsset)]()
    var separateNavigationControler: UISeparateNavigationController?
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSelectionView = ImageSelectionView(controller: self, frame: view.frame)
        self.view = imageSelectionView
        self.imageSelectionView?.collectionView(datasource: self)
        self.imageSelectionView?.collectionView(delegate: self)
        self.imageSelectionView?.imageSelectorTopAnchor = separateNavigationControler?.navigationControllerTopAnchor
        setupNavigationItems(navigationItem: self.navigationItem)
        self.imageSelectionView?.addHeaderTapGestureRecognizer(self, action: #selector(tapGestureRecognizerHandler))
        self.imageSelectionView?.addHeaderPanGestureRecognizer(self, target: self, action: #selector(panGestureRecognizerHandler))
        testPhotoLibraryPermission(status: PHPhotoLibrary.authorizationStatus())
    }
    
    fileprivate func testPhotoLibraryPermission(status: PHAuthorizationStatus){
        if status == .authorized{
            fetchUserPhotos(withImageSize: imageSizeForCell,options:getFetchOptions(), completion: loadImages)
        }else if status == .denied{
            Alert.showBasic("Permission denied", message: "Sorry but we need your permission to access the photo library", viewController: self,handler: { (action) in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
            })
        }else if status == .notDetermined{
            requestPhotoLibraryAuthorization(completion: testPhotoLibraryPermission)
        }
    }
    
    fileprivate func requestPhotoLibraryAuthorization(completion: @escaping ((_ status: PHAuthorizationStatus) ->Void)){
        PHPhotoLibrary.requestAuthorization({ (status) in
            completion(status)
        })
    }
    
    fileprivate func getFetchOptions() -> PHFetchOptions{
        let options = PHFetchOptions()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        options.sortDescriptors = [sortDescriptor]
        return options
    }
    
    fileprivate func fetchUserPhotos(withImageSize imageSize: CGSize,options: PHFetchOptions, completion: (((UIImage,PHAsset)) -> Void)?){
        let result = PHAsset.fetchAssets(with: .image, options: options)
        DispatchQueue.global(qos: .background).async {
            result.enumerateObjects { (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    if let image = image{
                        if let completion = completion{
                            completion((image,asset))
                        }
                    }
                })
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func tapGestureRecognizerHandler(){
        self.imageSelectionView?.pullHeaderDown()
    }
    
    @objc func panGestureRecognizerHandler(_ panGestureRecognizer: UIPanGestureRecognizer){
        if let view = panGestureRecognizer.view{
            let currentLocation = panGestureRecognizer.location(in: view)
            let pannedView = view.hitTest(currentLocation, with: nil)
            let translation = panGestureRecognizer.translation(in: view)
            let velocity = panGestureRecognizer.velocity(in: view)
            self.imageSelectionView?.setScrollDirection(by: velocity)
            self.imageSelectionView?.collectionView(setScrollState: true)
            if let pannedView = pannedView{
                switch(panGestureRecognizer.state){
                case .began:
                    self.imageSelectionView?.setScrollState(view: pannedView)
                case .changed:
                    self.imageSelectionView?.scrollHeader(from: currentLocation, translation: translation)
                case .ended:
                    self.imageSelectionView?.attractHeader(using: self.view.frame.maxY)
                default:
                    return
                }
            }
            panGestureRecognizer.setTranslation(CGPoint.zero, in: view.superview)
        }
    }
    
    func loadImages(imageAsset: (image: UIImage,asset: PHAsset)){
        self.images.append(imageAsset)
        DispatchQueue.main.sync { [weak self] in
            if images.count == 1 {
                let image = imageAsset.image
                selectedImage = image
            }
            self?.imageSelectionView?.collectionView(insertImage: imageAsset.image, index: self!.images.endIndex - 1)
        }
    }
    
    fileprivate func setupNavigationItems(navigationItem: UINavigationItem){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextHandler))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancelHandler))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    @objc func cancelHandler(){
        separateNavigationControler?.dismiss(animated: true, completion: nil)
    }
    
    @objc func nextHandler(){
        let imageCaptionController = ImageCaptionController()
        imageCaptionController.selectedImage = self.selectedImage
        imageCaptionController.separateNavigationControler = self.separateNavigationControler
        navigationController?.pushViewController(imageCaptionController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSelectionCell.ID, for: indexPath)
        if let imageSelectorCell = cell as? ImageSelectionCell{
            imageSelectorCell.photo = self.images[indexPath.row].image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.width - 3) / 4
        return CGSize(width: size, height: size)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = self.images[indexPath.row].asset
        let imageManager = PHImageManager.default()
        imageManager.requestImage(for: asset, targetSize: imageSizeForHeader, contentMode: .aspectFit, options: nil) { [weak self] (image, info) in
            if let image = image{
                self?.selectedImage = image
            }
        }
    }
    
    fileprivate func updateHeaderImage(_ image: UIImage){
        self.imageSelectionView?.updateHeaderImage(image: image)
    }
}
