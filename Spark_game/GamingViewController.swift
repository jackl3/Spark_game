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
    @IBOutlet weak var spaceTitleField: UITextField!
    
    var oauthenticator: OAuthAuthenticator!
    var spark: Spark!
    let member_mail = "luzhang2@cisco.com"
    
    
    //logout function
    @IBAction func LogOut(_ sender: Any) {
        print("you will log out now")
        oauthenticator.deauthorize()
        _ = navigationController?.popToRootViewController(animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Gaming View loaded")
        print(spark)
        print(oauthenticator)

    }
    
    
    
    @IBAction func createSpace(_ sender: Any) {
        let spaceTitle = spaceTitleField.text
        
        // Create a new space
        spark!.rooms.create(title: spaceTitle!){ response in
            switch response.result {
            case .success(let space):
                print("\(space.title!), created \(space.created!): \(space.id!)")
                self.addMember(space: space)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                return
            }
        }
    }
    
    
    func addMember(space:Room) {
        if let email = EmailAddress.fromString(member_mail){
            spark!.memberships.create(roomId: space.id!, personEmail: email) { response in
                switch response.result {
                case .success(let membership):
                    print("A member \(self.member_mail) has been added into the space. membershipID:\(membership)")
                    self.sendMessage(space:space)
                case .failure(let error):
                    print("Adding a member to the space has been failed: \(error.localizedDescription)")
                    return
                }
            }
        }
    }
    
    // Post a text message to the space
    func sendMessage(space:Room) {
        spark!.messages.post(roomId: space.id!, text: "Hello, anyone can help me?") { response in
            switch response.result {
            case .success(let message):
                print("Message: \"\(message)\" has been sent to the space!")
            case .failure(let error):
                print("Got error when posting a message: \(error.localizedDescription)")
                return
            }
        }
    }

    

    
    
    
}
