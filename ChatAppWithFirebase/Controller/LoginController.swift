//
//  LoginController.swift
//  ChatAppWithFirebase
//
//  Created by Ammy Pandey on 01/12/17.
//  Copyright © 2017 Ammy Pandey. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController
{

    //Mark Create Container View which hold the all UIContent
    let inputsContainerView: UIView =
    {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    //Mark: Login And Register Button
    lazy var loginRegisterButton: UIButton =
    {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleLoginRegister()
    {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else
        {
            handleRegister()
        }
    }
    
    func handleLogin()
    {
        //Authenticate with firebase
        guard let email = emailTextfield.text, let password = passwordTextfield.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            //Mark: Successfully logged in our users
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    //Mark: TextField
    let nameTextfield: UITextField =
    {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //Mark: Provide Seperator to textFields
    let nameSepratorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Mark: TextField
    let emailTextfield: UITextField =
    {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //Mark: Provide Seperator to textFields
    let emailSepratorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //Mark: TextField
    let passwordTextfield: UITextField =
    {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        return textField
    }()
    
    //Mark: Profile Image
    lazy var profileImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "chat.png")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        image.isUserInteractionEnabled = true
        return image
    }()
    
    
    
    //Create Segment control for login and register toggle
    lazy var loginRegisterSegmentedControl: UISegmentedControl =
    {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(handleLoginRegisterChanged), for: .valueChanged)
        return sc
    }()
    
    @objc func handleLoginRegisterChanged()
    {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        
        //Mark: Change the button title when press segment control
        loginRegisterButton.setTitle(title, for: .normal)
        
        //Mark: Change height of inputContainerView
        inputContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100: 150
        
        //Mark: Change Height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //Mark: Change Height of emailTextField
        emailTextFieldHelightAnchor?.isActive = false
        emailTextFieldHelightAnchor = emailTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/3)
        emailTextFieldHelightAnchor?.isActive = true
        
        //Mark: Change Height of passwordTextField
        passwordTextFieldHelightAnchor?.isActive = false
        passwordTextFieldHelightAnchor = passwordTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2: 1/3)
        passwordTextFieldHelightAnchor?.isActive = true
        
        print(loginRegisterSegmentedControl.selectedSegmentIndex)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        setupInputsContainer()
        setupLoginRegisterButton()
        setupProfileImage()
        setupLoginRegisterSegmentedControl()
        
        
    }
    //Set UIbarStyle Content......
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupLoginRegisterSegmentedControl()
    {
        //Mark: Calculate x,y,width and height and setup autolayout
        
        //X
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //Y
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        
        //Width
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        //Height
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupProfileImage()
    {
        //Mark: Calculate x,y,width and height and setup autolayout
        
        //X
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //Y
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -12).isActive = true
        
        //Width
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        //Height
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHelightAnchor: NSLayoutConstraint?
    var passwordTextFieldHelightAnchor: NSLayoutConstraint?
    
    func setupInputsContainer()
    {
        //Mark: Calculate x,y,width and height and setup autolayout
        
        //X
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //Y
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //Width
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        //Height
        inputContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerViewHeightAnchor?.isActive = true
        
        //Add textfield and Seprator on inputContainerView
        inputsContainerView.addSubview(nameTextfield)
        inputsContainerView.addSubview(nameSepratorView)
        inputsContainerView.addSubview(emailTextfield)
        inputsContainerView.addSubview(emailSepratorView)
        inputsContainerView.addSubview(passwordTextfield)
        
        //Mark: Calculate x,y,width and height and setup autolayout for textfield
        
        //X
        nameTextfield.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        
        //Y
        nameTextfield.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        
        //Width
        nameTextfield.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        //Height
        nameTextFieldHeightAnchor = nameTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        //Mark: Calculate x,y,width and height and setup autolayout for sepratorView
        
        //X
        nameSepratorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        
        //Y
        nameSepratorView.topAnchor.constraint(equalTo: nameTextfield.bottomAnchor).isActive = true
        
        //Width
        nameSepratorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        //Height
        nameSepratorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Mark: Calculate x,y,width and height and setup autolayout for textfield
        
        //X
        emailTextfield.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        
        //Y
        emailTextfield.topAnchor.constraint(equalTo: nameTextfield.bottomAnchor).isActive = true
        
        //Width
        emailTextfield.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        //Height
        emailTextFieldHelightAnchor = emailTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHelightAnchor?.isActive = true
        
        //Mark: Calculate x,y,width and height and setup autolayout for sepratorView
        
        //X
        emailSepratorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        
        //Y
        emailSepratorView.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor).isActive = true
        
        //Width
        emailSepratorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        //Height
        emailSepratorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Mark: Calculate x,y,width and height and setup autolayout for textfield
        
        //X
        passwordTextfield.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        
        //Y
        passwordTextfield.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor).isActive = true
        
        //Width
        passwordTextfield.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        //Height
        passwordTextFieldHelightAnchor = passwordTextfield.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHelightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton()
    {
        //Mark: Calculate x,y,width and height and setup autolayout
        
        //X
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //Y
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        
        //Width
        
        loginRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        
        //Height
        
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
}

//Mark Setup UIColor View
extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
