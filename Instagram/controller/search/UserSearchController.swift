//
//  UserSearchController.swift
//  Instagram
//
//  Created by tiago henrique on 05/03/2018.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import UIKit

class UserSearchController: UICollectionViewController,UICollectionViewDelegateFlowLayout,UISearchBarDelegate {
    
    var users = [User]()
    var filteredUsers = [User]()
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.placeholder = NSLocalizedString("search_placeholder", comment: "")
        search.searchBarStyle = .minimal
        search.barTintColor = .gray
        search.delegate = self
        return search
    }()

    private func setupViews(){
        navigationItem.titleView = searchBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundColor = .white
        self.collectionView?.register(UserSearchCellCollectionViewCell.self, forCellWithReuseIdentifier:UserSearchCellCollectionViewCell.ID)
        setupViews()
        fetchUsers()
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserSearchCellCollectionViewCell.ID, for: indexPath)
        if let searchCell = cell as? UserSearchCellCollectionViewCell{
            let user = self.filteredUsers[indexPath.row]
            searchCell.user = user
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    fileprivate func fetchUsers(){
        UserRepository.fetchAll(completion: self.loadUsers)
    }
    
    fileprivate func loadUsers(_ users: [User]){
        DispatchQueue.main.async {
            self.users = users
            self.filteredUsers = self.sortUsers(users: self.users)
            self.collectionView?.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredUsers = filterUsers(users: users, searchText: searchText)
        collectionView?.reloadData()
    }
    
    private func filterUsers(users: [User], searchText: String) -> [User]{
        var filteredUsers: [User]
        if searchText.isEmpty{
            filteredUsers = users
        }else{
            filteredUsers = users.filter { (user) -> Bool in
                return user.name!.lowercased().contains(searchText.lowercased())
            }
        }
        filteredUsers = self.sortUsers(users: users)
        return filteredUsers
    }
    
    private func sortUsers(users: [User]) -> [User]{
        var users = users
        users.sort { (prev, next) -> Bool in
            prev.name!.compare(next.name!) == .orderedAscending
        }
        return users
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = filteredUsers[indexPath.item]
        searchBar.resignFirstResponder()
        openUserProfile(user: user)
    }
    
    fileprivate func openUserProfile(user: User){
       let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfileController.user = user
        userProfileController.hideFollowButton = false
        navigationController?.pushViewController(userProfileController, animated: true)
    }
}
