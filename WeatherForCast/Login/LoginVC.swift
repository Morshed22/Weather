//
//  ViewController.swift
//  WeatherForCast
//
//  Created by Morshed Alam on 13/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import UIKit
import CoreLocation
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth



class LoginVC: UIViewController {
    
    @IBOutlet weak var FBLoginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   // Google SingIN
    @IBAction func loginWithGmail(_ sender: Any) {
        if Reachability.isReachable{
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        }else{
            self.showInternetAlert()
        }
    }
    // fb login
    @IBAction func loginWithFaceBook(_ sender: Any) {
        if Reachability.isReachable{
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions:[.publicProfile, .email, .userFriends,], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, _):
                self.gotoTabVC()
            }
        }
        } else{
            self.showInternetAlert()
        }
    }
// Guest login
    @IBAction func pressLogin(_ sender: Any) {
        if Reachability.isReachable{
            Auth.auth().signInAnonymously(completion: { (user, error) in
            if error == nil, user != nil {
                print(user!.uid)
              self.gotoTabVC()
            }
        })
        }else{
            
            self.showInternetAlert()
        }
        
    }
    // go tabController
    func gotoTabVC() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabVC = storyBoard.instantiateViewController(withIdentifier: "tabVC") as? UITabBarController
        tabVC?.selectedIndex = 0
        self.present(tabVC!, animated: false, completion: nil)
    }
    
    
}

// delgegate for google SingIn
extension LoginVC:GIDSignInUIDelegate, GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            self.gotoTabVC()
        }
    }
}
