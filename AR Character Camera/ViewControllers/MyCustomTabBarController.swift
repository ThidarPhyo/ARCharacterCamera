//
//  MainTabBarController.swift
//  AR Character Camera
//
//  Created by cmStudent on 2023/12/13.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create instances of your view controllers
        let cameraViewController = CameraViewController()
        let modelViewController = ModelViewController()

        // Set the view controllers for the tab bar controller
        self.viewControllers = [cameraViewController, modelViewController]

        // Optionally, you can set titles and images for each tab
        cameraViewController.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(systemName: "camera"), tag: 0)
        modelViewController.tabBarItem = UITabBarItem(title: "Model", image: UIImage(systemName: "magnifyingglass"), tag: 1)
    }
}

