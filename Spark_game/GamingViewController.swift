//
//  GamingViewController.swift
//  Spark_game
//
//  Created by jackl3 on 30/7/2017.
//  Copyright © 2017 jackl3. All rights reserved.
//

import UIKit
import SparkSDK

class GamingViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Gaming View loaded")
    }
    
    //Sign out
    @IBAction func signOut(_ sender: Any) {
        //signInPrompt.text = "The app is not authorized to use the services. Please sign in first!"
        //spark?.authenticator.deauthorize()
        //beforeLoginAndAuth()
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
}
