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

    var messages = [Message]()
    var messagesDictonary = [String: Message]()
    let cellId = "cellId"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Mark: navigation bar items set
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "newMessage")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        checkIfUserIsLoggedIn()
        //observeMessages()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    func observeUserMessage()
    {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRefrence = Database.database().reference().child("messages").child(messageId)
            messagesRefrence.observeSingleEvent(of: .value, with: { (snapshot) in
                
                print(snapshot)
                if let dictonary = snapshot.value as? [String: AnyObject]
                {
                    let message = Message()
                    message.fromId = dictonary["fromId"] as? String
                    message.text = dictonary["text"] as? String
                    message.timeStamp = dictonary["timeStamp"] as? NSNumber
                    message.toId = dictonary["toId"] as? String
                    
                    //self.messages.append(message)
                    
                    if let chatPatnerId = message.chatPatnerId()
                    {
                        self.messagesDictonary[chatPatnerId] = message
                        
                        self.messages = Array(self.messagesDictonary.values)
                        //                    self.messages.sort(by: { (message1, message2) -> Bool in
                        //
                        //                        return message1.timeStamp?.intValue > message2.timeStamp?.intValue
                        //                    })
                    }
                    
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
                    
                    
                }
                
            }, withCancel: nil)
            
            //print(snapshot)
            
        }, withCancel: nil)
    }
    
    var timer: Timer?
    
   @objc func handleReloadTable()
    {
        //Mark: Call this method on main thread.
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
    func observeMessages()
    {
        let ref = Database.database().reference().child("messages")
        ref.observe(.childAdded, with: { (snapshot) in
            
            if let dictonary = snapshot.value as? [String: AnyObject]
            {
                let message = Message()
                message.fromId = dictonary["fromId"] as? String
                message.text = dictonary["text"] as? String
                message.timeStamp = dictonary["timeStamp"] as? NSNumber
                message.toId = dictonary["toId"] as? String
                
                //self.messages.append(message)
                
                if let toId = message.toId
                {
                    self.messagesDictonary[toId] = message
                    
                    self.messages = Array(self.messagesDictonary.values)
//                    self.messages.sort(by: { (message1, message2) -> Bool in
//                        
//                        return message1.timeStamp?.intValue > message2.timeStamp?.intValue
//                    })
                }
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let message = messages[indexPath.row]
        
        guard let chatPatnerId = message.chatPatnerId() else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(chatPatnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictonary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = UsersManagment()
            user.id = chatPatnerId
            user.email = dictonary["email"] as? String
            user.name = dictonary["name"] as? String
            user.profileImageUrl = dictonary["profileImageUrl"] as? String

            //user.setValuesForKeys(dictonary)
            self.showChatControllerForUser(user: user)
            
        }, withCancel: nil)
        
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
        messages.removeAll()
        messagesDictonary.removeAll()
        tableView.reloadData()
        
        observeUserMessage()
        
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
        
       // titleView.addTarget(self, action: #selector(showChatControllerForUser), for: .touchUpInside)
        
    }
    
    @objc func showChatControllerForUser(user: UsersManagment)
    {
        print(123)
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
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
        newMessageController.messageController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
}

