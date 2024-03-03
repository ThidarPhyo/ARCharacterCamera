//
//  UserData.swift
//  AR Character Camera
//
//  Created by cmStudent on 2023/11/25.
//

//import Foundation
//import UIKit
//
//struct UserData {
//    let profile: UIImage
//    let name: String
//    let email: String
//}
//
//class UserManager {
//    static let shared = UserManager()
//
//    var currentUser: UserData?
//
//    private init() {
//        // Retrieve saved user data when the UserManager is initialized
//        currentUser = getSavedUser()
//        
//    }
//
//    func saveUser(_ userData: UserData) {
//        currentUser = userData
//
//        // Save the user data to UserDefaults
//        UserDefaults.standard.set(userData.name, forKey: "UserName")
//        UserDefaults.standard.set(userData.email, forKey: "UserEmail")
//
//        // Convert the profile image to data and save it
//        if let profileData = userData.profile.jpegData(compressionQuality: 1.0) {
//            UserDefaults.standard.set(profileData, forKey: "UserProfile")
//        }
//
//        // Synchronize UserDefaults to ensure data is saved immediately
//        UserDefaults.standard.synchronize()
//    }
//
//    func removeUser() {
//        // Remove user data from UserDefaults
//        UserDefaults.standard.removeObject(forKey: "UserName")
//        UserDefaults.standard.removeObject(forKey: "UserEmail")
//        UserDefaults.standard.removeObject(forKey: "UserProfile")
//
//        // Synchronize UserDefaults to ensure data is removed immediately
//        UserDefaults.standard.synchronize()
//        
//    }
//
//    private func getSavedUser() -> UserData? {
//        // Retrieve user data from UserDefaults
//        guard let name = UserDefaults.standard.string(forKey: "UserName"),
//              let email = UserDefaults.standard.string(forKey: "UserEmail"),
//              let profileData = UserDefaults.standard.data(forKey: "UserProfile"),
//              let profileImage = UIImage(data: profileData) else {
//            // User data not found
//            return nil
//        }
//
//        return UserData(profile: profileImage, name: name, email: email)
//    }
//}
//

import Foundation
import UIKit

struct UserData {
    let profile: UIImage
    let name: String
    let email: String

    // Convert UserData to dictionary for easier storage
    var dictionary: [String: Any] {
        return [
            "name": name,
            "email": email,
            // Convert the profile image to Data
            "profileData": profile.jpegData(compressionQuality: 1.0)?.base64EncodedString() ?? ""
        ]
    }

    // Initialize UserData from dictionary
    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
              let email = dictionary["email"] as? String,
              let profileDataString = dictionary["profileData"] as? String,
              let profileData = Data(base64Encoded: profileDataString),
              let profileImage = UIImage(data: profileData) else {
            return nil
        }
        self.name = name
        self.email = email
        self.profile = profileImage
    }
}

class UserManager {
    
    static let shared = UserManager()

    var currentUser: UserData?

    private init() {
        // Retrieve saved user data when the UserManager is initialized
        currentUser = getSavedUser()
    }

    func saveUser(_ userData: UserData) {
        currentUser = userData

        // Save the user data to UserDefaults
        UserDefaults.standard.set(userData.dictionary, forKey: "UserDictionary")

        // Synchronize UserDefaults to ensure data is saved immediately
        UserDefaults.standard.synchronize()
    }

    func removeUser() {
        
        currentUser = nil

        // Remove user data from UserDefaults
        UserDefaults.standard.removeObject(forKey: "UserDictionary")

        // Synchronize UserDefaults to ensure data is removed immediately
        UserDefaults.standard.synchronize()
    }

    private func getSavedUser() -> UserData? {
        // Retrieve user data from UserDefaults
        if let userDictionary = UserDefaults.standard.dictionary(forKey: "UserDictionary") as? [String: Any],
           let userData = UserData(dictionary: userDictionary) {
            return userData
        }

        // User data not found
        return nil
    }
}
