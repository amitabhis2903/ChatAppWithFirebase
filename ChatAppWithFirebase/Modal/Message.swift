//
//  Message.swift
//  ChatAppWithFirebase
//
//  Created by Ammy Pandey on 03/12/17.
//  Copyright © 2017 Ammy Pandey. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject
{
    var fromId: String?
    var text: String?
    var timeStamp: NSNumber?
    var toId: String?

    func chatPatnerId() -> String?
    {
        return fromId == Auth.auth().currentUser?.uid ? toId: fromId

    }
    
}
