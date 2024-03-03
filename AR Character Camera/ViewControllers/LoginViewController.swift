//
//  LoginViewController.swift
//  AR Character Camera
//
//  Created by cmStudent on 2023/11/20.
//

import UIKit
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var cardView: UIView!
    
    
    @IBOutlet weak var roundedCircle: UIView!
    
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var passwrodView: UIView!
    
    
    @IBOutlet weak var txtEmail: UITextField!
    
    
    @IBOutlet weak var txtPassword: UITextField!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        
        cardView.layer.masksToBounds = true
        roundedCircle.layer.masksToBounds = true
        passwrodView.layer.masksToBounds = true
        
        passwrodView.layer.borderColor = UIColor(hexString: "#5FA6F4").cgColor
        
        
        passwrodView.layer.borderWidth = 2
        
        emailView.layer.masksToBounds = true
        
        emailView.layer.borderColor = UIColor(hexString: "#5FA6F4").cgColor
        
        
        emailView.layer.borderWidth = 2
        
        checkState()
    }
    func checkState() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Not signed in
                print("Not Sign In")
            } else {
                // Signed in
                guard let user = user else { return }
                guard let profile = user.profile else { return }
                // Load user data
                self.loadUserData(profile)
            }
        }
    }
    
    @IBAction func btnLoginPressed(_ sender: UIButton) {
        
        //        let loginManager = FirebaseAuthManager()
        //        guard let email = contactPointTextField.text, let password = passwordTextField.text else { return }
        //        loginManager.signIn(email: email, pass: password) {[weak self] (success) in
        //          self?.showPopup(isSuccess: success)
        //        }
        self.view.endEditing(true)
        
        if let email = txtEmail.text, let password = txtPassword.text{
            if !email.validateEmailId(){
                openAlert(title: "Alert", message: "Please enter valid email", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{_ in }])
                print("email is not valid")
            } else if password == ""{
                print("Please enter password")
            }
            else{
                Auth.auth().signIn(withEmail: self.txtEmail.text!, password: self.txtPassword.text!) { (user, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        
                    }
                    else if let user = user {
                        print(user)
                        let successVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
                        
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
    
    @IBAction func btnGoogleTapped(_ sender: UIButton) {
        googleLogin()
    }
    // Google login
    func googleLogin() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else {
                // Login failed
                let popup = UIAlertController(title: "Login Failed", message: "Please log in again", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                popup.addAction(action)
                self.present(popup, animated: true)
                return
            }
            // Login successful
            guard let user = signInResult?.user else { return }
            guard let profile = user.profile else { return }
            // Load user data
            self.loadUserData(profile)
        }
    }
    
    // Load user data
    func loadUserData(_ profile: GIDProfileData) {
        let emailAddress = profile.email
        let fullName = profile.name
        let profilePicUrl = profile.imageURL(withDimension: 180)
        
        // Download profile image
        if let profilePicUrl = profilePicUrl {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: profilePicUrl) {
                    if let image = UIImage(data: data) {
                        // UI updates must be done on the main thread
                        DispatchQueue.main.async {
                            let data = UserData(profile: image, name: fullName, email: emailAddress)
                            self.moveMyPage(data)
                        }
                    }
                }
            }
        }
    }
    // Move to the My Page
    func moveMyPage(_ data: UserData) {
        let board = UIStoryboard(name: "Profile", bundle: nil)
        guard let nextVC = board.instantiateViewController(withIdentifier: "Profile") as? ProfileViewController else { return }
        nextVC.userData = data
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: true)
    }
    
    @IBAction func btnFacebookTapped(_ sender: UIButton) {
        didTapFacebookButton()
    }
    
    func didTapFacebookButton() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
          if error != nil {
            self.showPopup(isSuccess: false)
            return
          }
          guard let token = AccessToken.current else {
            print("Failed to get access token")
            self.showPopup(isSuccess: false)
            return
          }
          
          FirebaseAuthManager().login(credential: FacebookAuthProvider.credential(withAccessToken: token.tokenString)) {[weak self] (success) in
            self?.showPopup(isSuccess: true)
          }
        }
    }
    
    @IBAction func btnAppleLoginTapped(_ sender: UIButton) {
    }
    
}
//extension UIColor {
//    convenience init?(hexString: String) {
//        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
//        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
//        
//        var rgb: UInt64 = 0
//        
//        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
//            return nil
//        }
//        
//        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
//        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
//        let blue = CGFloat(rgb & 0x0000FF) / 255.0
//        
//        self.init(red: red, green: green, blue: blue, alpha: 1.0)
//    }
//}
