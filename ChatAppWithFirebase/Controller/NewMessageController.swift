//
//  NewMessageController.swift
//  ChatAppWithFirebase
//
//  Created by Ammy Pandey on 02/12/17.
//  Copyright © 2017 Ammy Pandey. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController
{

    
    let cellId = "cellId"
    var users = [UsersManagment]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Mark: navigation bar items set
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()

    }
    
    func fetchUser()
    {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                let user = UsersManagment()
                user.id = snapshot.key
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.profileImageUrl = dictionary["profileImageUrl"] as? String
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            //print(snapshot)
            
        }, withCancel: nil)
    }

    @objc func handleCancel()
    {
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl
        {
            
            cell.profileImageView.loadImageCacheWithUrlString(urlString: profileImageUrl)
            
//            let url = URL(string: profileImageUrl)
//            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//
//                if error != nil {
//                    print(error as Any)
//                    return
//                }
//
//                //Download Image Successfull
//
//                DispatchQueue.main.async {
//
//                    cell.profileImageView.image = UIImage(data: data!)
//                }
//
//            }).resume()
        }
        
        return cell
    }
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    //Mark: Refrence pf Message Controller
    var messageController: MessageController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismiss(animated: true) {
            print("Dismiss Completed")
            let user = self.users[indexPath.row]
            self.messageController?.showChatControllerForUser(user: user)
        }
        
    }
}





