//
//  ChatMessageCell.swift
//  ChatAppWithFirebase
//
//  Created by Ammy Pandey on 04/12/17.
//  Copyright © 2017 Ammy Pandey. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Some types of Text"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.allowsEditingTextAttributes = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textView)
        
        //Mark: Setup Constraint
        //X,Y,Width,Height
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
