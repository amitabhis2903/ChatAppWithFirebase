//
//  MessageController.swift
//  ChatAppWithFirebase
//
//  Created by Ammy Pandey on 01/12/17.
//  Copyright © 2017 Ammy Pandey. All rights reserved.
//

import UIKit
import Firebase

class MessageController: UITableViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Mark: navigation bar items set
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "newMessage")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        checkIfUserIsLoggedIn()
    }
    
    func checkIfUserIsLoggedIn()
    {
        //Mark: User not logged in
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        }else
        {
            fetchUserAndSetupNavBar()
        }

    }
    
    func fetchUserAndSetupNavBar()
    {
        //Mark: If user logged in show his name on navigation bar title
        guard let uid = Auth.auth().currentUser?.uid
            else {
                return
        }
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            
            if let dictonary = snapshot.value as? [String: AnyObject] {
                //self.navigationItem.title = dictonary["name"] as? String
                
                let user = UsersManagment()
                user.name = dictonary["name"] as? String
                user.profileImageUrl = dictonary["profileImageUrl"] as? String
                self.setupNavBarWithUser(user: user)
            }
            
            print(snapshot)
            
        }, withCancel: nil)
        
    }
    
    func setupNavBarWithUser(user: UsersManagment)
    {
        let titleView = UIButton()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        if let profileImageUrl = user.profileImageUrl {
             profileImageView.loadImageCacheWithUrlString(urlString: profileImageUrl)
        }
       
        containerView.addSubview(profileImageView)
        
        //iOS 9 Constraint Setup
        //need X,Y,Width and Height
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //need X,Y,Width and Height
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        
        titleView.addTarget(self, action: #selector(showChatController), for: .touchUpInside)
        
    }
    
    @objc func showChatController()
    {
        
        print(123)
        let chatLogController = ChatLogController()
        navigationController?.pushViewController(chatLogController, animated: true)

    }
    
    @objc func handleLogout()
    {
        do {
           try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        loginController.messageController = self
        present(loginController, animated: true, completion: nil)
    }
    
    @objc func handleNewMessage()
    {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
}

