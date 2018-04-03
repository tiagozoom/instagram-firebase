//
//  CommentsTableViewController.swift
//  Instagram
//
//  Created by tiago turibio on 22/03/18.
//  Copyright © 2018 tiago turibio. All rights reserved.
//

import UIKit
import Firebase

class CommentsTableViewController: UITableViewController {
   
    var comments = [Comment]()
    
    var post: Post?{
        didSet{
            fetchComments(post:post!,completion:loadComment)
        }
    }
    
    fileprivate func loadComment(comment: Comment){
        DispatchQueue.main.async { [weak self] in
            self?.comments.append(comment)
            self?.tableView?.reloadData()
        }
    }
    
    fileprivate func fetchComments(post: Post, completion: ((_ comment:Comment) -> Void)?){
        if let postID = post.uid{
            CommentRepository.fetchComments(with: postID, completion: { (comment) in
                UserRepository.fetchUser(with: comment.userID!, completion: { (user) in
                    var fetchedComment = comment
                    fetchedComment.user = user
                    if let completion = completion{
                       completion(fetchedComment)
                    }
                })
            })
        }
    }
    

    fileprivate func setupViews(){
        self.title = NSLocalizedString("comments", comment: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = self.tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .white
        self.tableView.register(CommentsViewCell.self, forCellReuseIdentifier: CommentsViewCell.ID)
        setupViews()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.comments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentsViewCell.ID, for: indexPath)
        
        if let commentCell = cell as? CommentsViewCell{
            commentCell.comment = self.comments[indexPath.row]
        }

        return cell
    }
    
    override var inputAccessoryView: UIView?{
        get{
            let container = UIView()
            container.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
            
            let commentaryInputText = UITextField()

            container.backgroundColor = .red
            container.addSubview(commentaryInputText)
            
            commentaryInputText.anchors(top: container.topAnchor, right: container.rightAnchor, bottom: container.bottomAnchor, left: container.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 0)
            commentaryInputText.placeholder = "Enter some text"

            return container
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
}
