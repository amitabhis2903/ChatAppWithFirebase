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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "logOut", style: .plain, target: self, action: #selector(handleLogout))
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
            //Mark: If user logged in show his name on navigation bar title
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
                
                if let dictonary = snapshot.value as? [String: AnyObject] {
                    self.navigationItem.title = dictonary["name"] as? String
                }
                
                print(snapshot)
                
            }, withCancel: nil)
        }

    }
    
    @objc func handleLogout()
    {
        do {
           try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
    @objc func handleNewMessage()
    {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
}

