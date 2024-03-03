//
//  ProfileViewController.swift
//  AR Character Camera
//
//  Created by cmStudent on 2023/11/22.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseFirestore
import FirebaseAuth

class ProfileViewController: UIViewController {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelName: UILabel!
    
    
    @IBOutlet weak var editView: UIView!
    
    @IBOutlet weak var change_passwordView: UIView!
    
    @IBOutlet weak var logoutView: UIView!
    
    @IBOutlet weak var settingsview: UIView!
    var userData: UserData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundedBorderColor()
        
        // Check login status and load the profile
        //loadProfile()
        
        fetchUser()
        
        backButton()
    }
    
    func backButton() {
        let backImage = UIImage(named: "icon-back")

        self.navigationController?.navigationBar.backIndicatorImage = backImage

        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: nil, action: nil)

    }
    
    func roundedBorderColor() {
        editView.layer.borderColor = UIColor(hexString: "#5FA6F4").cgColor
        
        editView.layer.borderWidth = 2
        
        change_passwordView.layer.borderColor = UIColor(hexString: "#5FA6F4").cgColor
        
        change_passwordView.layer.borderWidth = 2
        
        logoutView.layer.borderColor = UIColor(hexString: "#5FA6F4").cgColor
        
        logoutView.layer.borderWidth = 2
        
        settingsview.layer.borderColor = UIColor(hexString: "#5FA6F4").cgColor
        
        settingsview.layer.borderWidth = 2
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
           
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           
            alertController.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { action in
                // Handle logout
                self.logout()
            }))
           
            present(alertController, animated: true, completion: nil)
    }
    // Get the profile
    func loadProfile() {
        // Fetch user data from Firestore and save to UserManager
    
        
        guard let userData = UserManager.shared.currentUser else { return }
        imgProfile.image = userData.profile
        labelName.text = userData.name
        labelEmail.text = userData.email
    }
    
    func fetchUser() {
        guard let userUID = Auth.auth().currentUser?.uid else {
            // No logged-in user, handle as needed
            return
        }

        Firestore.firestore().collection("users").document(userUID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                // Handle the error as needed
            } else if let snapshot = snapshot, snapshot.exists {
                // User data found in Firestore
                let userName = snapshot.get("name") as? String ?? ""
                let userEmail = snapshot.get("email") as? String ?? ""

                // Create UserData instance
                let userDictionary: [String: Any] = [
                    "name": userName,
                    "email": userEmail,
                    // Convert the profile image to Data
                    "profileData": UIImage(named: "user")?.jpegData(compressionQuality: 1.0)?.base64EncodedString() ?? ""
                ]

                if let userData = UserData(dictionary: userDictionary) {
                    // Use the userData instance here
                    print("User created successfully: \(userData)")
                    // Save user data to UserManager
                    UserManager.shared.saveUser(userData)
                    
                    self.loadProfile()
                    
                } else {
                    // Handle the case where UserData cannot be created from the dictionary
                    print("Error creating user data")
                }


                
            } else {
                print("User data not found in Firestore")
                // Handle the case where user data is not found
            }
        }
    }

    
    // Logout
    func logout() {
        GIDSignIn.sharedInstance.signOut()
        Auth.auth().signOut()
        
        // Remove user data
        UserManager.shared.removeUser()
        
        // Move to the main screen
        let board = UIStoryboard(name: "Main", bundle: nil)
        guard let nextVC = board.instantiateViewController(withIdentifier: "Login") as? LoginViewController else { return }
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: true)
    }
}


