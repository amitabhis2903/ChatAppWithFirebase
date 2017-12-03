//
//  ChatLogController.swift
//  ChatAppWithFirebase
//
//  Created by Ammy Pandey on 03/12/17.
//  Copyright © 2017 Ammy Pandey. All rights reserved.
//

import UIKit

class ChatLogController: UITableViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.title = "Chat Log Controller"
        
        setupInputComponents()
    }
    
    func setupInputComponents()
    {
        let containerView = UIView()
        containerView.backgroundColor = UIColor.red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
    }
    
}
