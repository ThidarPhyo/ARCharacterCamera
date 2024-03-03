//
//  ViewController.swift
//  AR Character Camera
//
//  Created by cmStudent on 2023/11/26.
//

import UIKit

class HomeViewController: UIViewController {
  
  var tabController: VC_TYPE = .Dummy
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUPColors()
  }
  
  func setUPColors() {
    if tabController == .AR_Scan {
        self.view.backgroundColor = .blue
    }
    else if tabController == .Camera {
      self.view.backgroundColor = .lightText
    }
    else if tabController == .Model {
        self.view.backgroundColor = .systemPink
    }
    else if tabController == .Profile {
        self.view.backgroundColor = .systemPink
    }
  }
    

}

