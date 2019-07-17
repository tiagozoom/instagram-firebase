//
//  MainTabController.swift
//  Instagram
//
//  Created by tiago turibio on 06/11/17.
//  Copyright © 2017 tiago turibio. All rights reserved.
//

import UIKit
import Firebase

class MainTabController: UITabBarController,UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let mainMenuNavigationController = viewController as? MainMenuNavigationController{
            return mainMenuNavigationController.executeBeforeShowing()
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        tabBar.tintColor = UIColor.black
        self.view.backgroundColor = UIColor.white
        
        if !isAuthenticated(Auth.auth().currentUser){
            DispatchQueue.main.async { [weak self] in
                self?.present(LoginNavigationController(), animated: true, completion: nil)
            }
            return
        }
        
        let controllersList = getControllersList()
        addViewControllers(controllersList)
        if let items = tabBar.items{
            adjustsTabBarIcons(items)
        }
    }
    
    func getControllersList() -> [MainMenuNavigationController]{
        let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.hideFollowButton = true
        let homeController = HomeController(collectionViewLayout: UICollectionViewFlowLayout())
        return [
            HomeNavigationController(rootViewController: homeController),
            SearchNavigationController(rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout())),
            AddPhotosNavigationController(rootViewController: UIViewController()),
            FavouritesNavigationController(rootViewController: UIViewController()),
            UserProfileNavigationController(rootViewController: userProfileController),
        ]
    }
    
    func addViewControllers(_ controllers: [MainMenuNavigationController]){
        self.viewControllers = controllers
    }
    
    func adjustsTabBarIcons(_ items: [UITabBarItem]){
        for item in items{
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    func isAuthenticated(_ currentUser: Firebase.User?) -> Bool{
        return currentUser != nil
    }
}
