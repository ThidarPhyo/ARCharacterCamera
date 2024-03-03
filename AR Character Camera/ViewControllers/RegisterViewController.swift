//
//  RegisterViewController.swift
//  AR Character Camera
//
//  Created by cmStudent on 2023/11/21.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var signupOutlet: UIView!
    
    
    @IBOutlet weak var userNameView: UIView!
    
    
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var passwordView: UIView!
    
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtUsername.delegate = self
        txtEmail.delegate = self
        txtPassword.delegate = self
        
        cardView.layer.masksToBounds = true
        signupOutlet.layer.masksToBounds = true
        userNameView.layer.masksToBounds = true
        emailView.layer.masksToBounds = true
        passwordView.layer.masksToBounds = true
        
        passwordView.layer.borderColor = UIColor(hexString: "#5FA6F4").cgColor
        
        
        passwordView.layer.borderWidth = 2
        
        emailView.layer.masksToBounds = true
        
        emailView.layer.borderColor = UIColor(hexString: "#5FA6F4").cgColor
        
        
        userNameView.layer.borderWidth = 2
        
        userNameView.layer.masksToBounds = true
        
        userNameView.layer.borderColor = UIColor(hexString: "#5FA6F4").cgColor
        
        
    }
    
    
    @IBAction func btnSignupClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if let email = txtEmail.text, let password = txtPassword.text, let username = txtUsername.text{
            if username == ""{
                print("Please enter username")
            }
            else if !email.validateEmailId(){
                openAlert(title: "Alert", message: "Please enter valid email", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                print("email is not valid")
            }

            else{
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        
                    }
                    else if let user = user {
                        print(user)
                        //self.dismiss(animated: true, completion: nil)
                        let successVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegisterSuccessViewController") as! RegisterSuccessViewController
                        
                        successVC.modalPresentationStyle = .fullScreen
                        
                        
                        self.present(successVC, animated: true, completion: nil)
                    }
                }
            }
        }else{
            print("Please check your details")
        }
  
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
