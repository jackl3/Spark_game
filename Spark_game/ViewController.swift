//
//  ViewController.swift
//  Spark_game
//
//  Created by jackl3 on 30/7/2017.
//  Copyright © 2017 jackl3. All rights reserved.
//

import UIKit
import SparkSDK
class ViewController: UIViewController {
    
    let clientId = "Cb6843ede7ad5b39fe52c9e861d447c5d8a211a55d79e81af184f93998f2b9088"
    let clientSecret = "cb7470f6d3f7ffa418e74cfe1b352da9aa24a31ed0f6fb59c227cf3e410dbe66"
//    let clientId = "C416dd36dd57b536a35816978e4f063a98849d285ca191f5566a32c0f0c3481ab"
//    let clientSecret = "bc851e0f4d4bd62c020a45de08e374101910200d43096f32d14b9e08164adac7"
    let scope = "spark:all"
    let redirectUri = "Spark-game://response"
//    let redirectUri = "KitchenSink://response"
    private var oauthenticator: OAuthAuthenticator!
    private var loginStatus: Bool = false
    var spark: Spark?
    
    @IBOutlet weak var loginPrompt: UILabel!
    @IBOutlet weak var signoutButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destionation =  segue.destination as? GamingViewController {
            destionation.oauthenticator = self.oauthenticator
            destionation.spark = self.spark
            print(self.spark)
            print(destionation.spark)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // An [OAuth](https://oauth.net/2/) based authentication strategy
        // is to be used to authenticate a user on Cisco Spark.
        
        oauthenticator = OAuthAuthenticator(clientId: clientId, clientSecret: clientSecret, scope: scope, redirectUri: redirectUri)   //we cant' use let to define oauthenticator 
        spark = Spark(authenticator: oauthenticator)
        print("spark value is \(String(describing: spark))")
        if !oauthenticator.authorized {
            print("you are not authorized")
            loginStatus = false
            
        }
        else {
            print("you already authorized")
            loginStatus = true
            signoutButton.isHidden = false
            loginButton.isHidden = true
        }
        print(oauthenticator)
        
        //SparkContext.initSparkForSparkIdLogin()
        //oauthenticator = SparkContext.sharedInstance.spark?.authenticator as! OAuthAuthenticator
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Returns True if the user is logically authorized.
        // This may not mean the user has a valid
        // access token yet, but the authentication strategy should be able to obtain one without
        // further user interaction.
        print(oauthenticator)
        if oauthenticator!.authorized {
            showApplicationHome()
            loginPrompt.textColor = UIColor.green
            loginPrompt.text = "Welcome to use Cisco Spark."
            print("thanks for login")
            signoutButton.isHidden = false
            loginButton.isHidden = true
//            self.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)  redirect to specific indentifier segue
            }
        else {
            loginPrompt.textColor = UIColor.blue
            loginPrompt.text = "Please login first"
            signoutButton.isHidden = true
            loginButton.isHidden = false
        }
        
        }
    
    
    @IBAction func sparkLogin(sender: AnyObject){
        
        //let authenticator = OAuthAuthenticator(clientId: clientId, clientSecret: clientSecret, scope: scope, redirectUri: redirectUri)
        let spark = Spark(authenticator: oauthenticator)
        print("spark value is \(spark)")
        
        if !oauthenticator.authorized {
            print("you need to login first")
            oauthenticator.authorize(parentViewController: self) { success in
                if !success {
                    print("User not authorized")
                }
            }
        }
        else {
            print("you are log in")
            //showApplicationHome()
            signoutButton.isHidden = false
            loginButton.isHidden = true
        }
    }
    
    private func showApplicationHome() {
        self.performSegue(withIdentifier: "pass_spark_data", sender: self)

//        let viewController = storyboard?.instantiateViewController(withIdentifier: "GamingViewController") as! GamingViewController
        //print(viewController)
        //navigationController?.pushViewController(viewController, animated: true)
        print("redirect to new view")
    }
    
    @IBAction func signOut(_ sender: Any) {
        loginPrompt.textColor = UIColor.red
        
        loginPrompt.text = "You are log out, Have a good day"
        //spark?.authenticator.deauthorize()
        oauthenticator.deauthorize()
        signoutButton.isHidden = true
        loginButton.isHidden = false
        _ = navigationController?.popToRootViewController(animated: true)
    }





}



