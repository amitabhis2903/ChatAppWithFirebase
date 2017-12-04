//
//  LoginController+handlers.swift
//  ChatAppWithFirebase
//
//  Created by Ammy Pandey on 03/12/17.
//  Copyright © 2017 Ammy Pandey. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleRegister()
    {
        //Authenticate with firebase
        guard let email = emailTextfield.text, let password = passwordTextfield.text, let name = nameTextfield.text else {
            print("Form is not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            //Successfully authenticated user
            //Save users with his name
            
            //Firebase Database Refrence
            guard let uid = user?.uid else {
                return
            }
            
            //Storage Profile Images on Firebase
            
            //Mark: unique id for image
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            //Mark: Compress the Images
            
            if let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                
                //Mark: Create binary data to upload image on firebase
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil
                    {
                        print(error as Any)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString
                    {
                       let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        
                        self.registerUserIntoDatabaseWithUid(uid: uid, values: values as [String : AnyObject])
                    }
                })
            }
        }
        print(123)
    }
    
    private func registerUserIntoDatabaseWithUid(uid: String, values: [String: AnyObject])
    {
        let refDatabase = Database.database().reference()
        //Adding child with user and it's uid
        let usersRef = refDatabase.child("users").child(uid)
        usersRef.updateChildValues(values, withCompletionBlock: { (err, refDatabase) in
            
            if err != nil {
                print(err as Any)
                return
            }
            
//            self.messageController?.fetchUserAndSetupNavBar()
//            self.messageController?.navigationItem.title = values["name"] as? String
            
            let user = UsersManagment()
            user.name = values["name"] as? String
            user.email = values["email"] as? String
            user.profileImageUrl = values["profileImageUrl"] as? String

            self.messageController?.setupNavBarWithUser(user: user)
            
            self.dismiss(animated: true, completion: nil)
            
            print("Saved user successfully into firebase database")
        })
    }
    
    @objc func handleSelectProfileImageView()
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            selectedImageFromPicker = editedImage
        }else if let orignalImage = info["UIImagePickerControllerOrignalImage"] as? UIImage
        {
            selectedImageFromPicker = orignalImage
        }
        
        if let selectedImage = selectedImageFromPicker
        {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled")
        dismiss(animated: true, completion: nil)
    }
}
