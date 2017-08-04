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
    @IBOutlet weak var create_room: UIButton!
    @IBOutlet weak var join_room: UIImageView!
    @IBOutlet weak var addMemberMailField: UITextField!
    @IBOutlet weak var spaceTitleField: UITextField!
    
    @IBOutlet weak var sendMessageLabel: UIButton!
    @IBOutlet weak var chatMessage: UITextField!
    var oauthenticator: OAuthAuthenticator!
    var spark: Spark!
    let member_mail = "luzhang2@cisco.com"
    var room_id: String?
    var room: Room?
    var message: String?
    var last_space_title: String?
    var last_text_id: String?
    var last_text_time: Date = Date()
    var timer = Timer()
    
    @IBOutlet weak var chat_HistoryFiled: UITextView!
    
    @IBAction func SendMessageToRoom(_ sender: Any) {
        sendMessage(space: room!)
        
        //start to check message history when we send the first message
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(GamingViewController.updateMessage), userInfo: nil, repeats: true)

        //checkMessage(space: room!)
        chatMessage.text = nil
    }
  
    //logout function
    @IBAction func LogOut(_ sender: Any) {
        print("you will log out now")
        oauthenticator.deauthorize()
        _ = navigationController?.popToRootViewController(animated: true)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        join_room.isHidden = true
        print("Gaming View loaded")
        print(spark)
        print(oauthenticator)

    }
    
    
    
    @IBAction func createSpace(_ sender: Any) {
        let spaceTitle = spaceTitleField.text
        
        if last_space_title != spaceTitle{
        // Create a new room
        spark!.rooms.create(title: spaceTitle!){ response in
            switch response.result {
            case .success(let space):
                print("\(space.title!), created \(space.created!): \(space.id!)")
                self.room = space
                self.room_id = space.id!
                print(self.room!)
                self.addMember(space: space)
                //self.create_room.isHidden = true
                self.join_room.isHidden = false
                self.last_space_title = spaceTitle
                self.sendMessageLabel.isHidden = false
                
            case .failure(let error):
                print("Error : \(error.localizedDescription)")
                return
            }
        }
    }
        else{
            
            print(self.room!)
            self.addMember(space: room!)
        }
    }
    
    
    func addMember(space:Room) {
        let email_list = addMemberMailField.text?.components(separatedBy: ",")
        print(email_list!)
        for email in email_list! {
        if let email = EmailAddress.fromString(email){
            spark!.memberships.create(roomId: space.id!, personEmail: email) { response in
                switch response.result {
                case .success(let membership):
                    print("A member \(email) has been added into the space. membershipID:\(membership)")
                    self.addMemberMailField.text = nil
                    //self.sendMessage(space:space)
                case .failure(let error):
                    print("Adding a member to the space has been failed: \(error.localizedDescription)")
                    return
                }
            }
        }
    }
}

    // Post a text message to the space
    func sendMessage(space:Room) {
        self.message = chatMessage.text
        spark!.messages.post(roomId: space.id!, text: message!) { response in
            switch response.result {
            case .success(let message):
                print("Message: \"\(message)\" has been sent to the space!")
            case .failure(let error):
                print("Got error when posting a message: \(error.localizedDescription)")
                return
            }
        }
        
    }

    func updateMessage() {
        checkMessage(space: room!)
    }
    
    func checkMessage(space:Room) {
        //self.message = chatMessage.text
        spark!.messages.list(roomId: space.id!) { response in
            switch response.result {
            case .success(let allmessage):
                if let response_all_data = response.result.data {
                    print("check history message")
               for resonse_data in response_all_data
                {
                    print(resonse_data.text as Any)
                    print(resonse_data.id as Any)
                    print(resonse_data.created as Any)
                    print(resonse_data.personEmail as Any)
                    print(resonse_data.toPersonEmail as Any)
                    let result: ComparisonResult = (resonse_data.created?.compare(self.last_text_time))!
                    switch result {
                    case .orderedAscending : print("early")
                    
                    case .orderedDescending : print("late")
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
                    let string_created = dateFormatter.string(from: resonse_data.created!)
                    //let person_full_name = resonse_data.personEmail?.toString()
                    
                    self.chat_HistoryFiled.text.append((resonse_data.personEmail?.toString())! + " " + string_created + ":\n")
                    self.chat_HistoryFiled.text.append(resonse_data.text! + "\n")
                    self.last_text_id = resonse_data.id
                    self.last_text_time = resonse_data.created!
                        
                    case .orderedSame : print("the same")
                    }
                    
                    //self.chat_HistoryFiled.text.append(resonse_data.text! + "\n")
                    //self.chat_HistoryFiled.text = resonse_data.text! + "\t" + (resonse_data.personEmail?.toString())! + "\n"
                    
                    }
                }
            case .failure(let error):
                print("Got error when posting a message: \(error.localizedDescription)")
                return
            }
        }
    }



    
    
    
}
