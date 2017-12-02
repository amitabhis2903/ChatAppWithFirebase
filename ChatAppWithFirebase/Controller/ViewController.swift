//
//  ViewController.swift
//  ChatAppWithFirebase
//
//  Created by Ammy Pandey on 01/12/17.
//  Copyright © 2017 Ammy Pandey. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITableViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        //Create left bar item of navigation bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "logOut", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    @objc func handleLogout()
    {
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
}

