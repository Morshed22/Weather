//
//  ProfileVC.swift
//  WeatherForeCast
//
//  Created by Morshed Alam on 14/2/18.
//  Copyright © 2018 GG. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import PKHUD
import FirebaseAuth

class ProfileVC: UIViewController {

    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var profileNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
   
        if   FBSDKAccessToken.current() != nil {
             PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
            self.getFBUserData()
            
        }else if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            if  let user = GIDSignIn.sharedInstance().currentUser {
                self.profileNameLabel.text = user.profile.givenName
                self.logOutBtn.setTitle("SignOutFromGmail", for: .normal)
            }
           
        }else {
            self.profileNameLabel.text = "Guest"
            self.logOutBtn.setTitle("Guest SignOut", for: .normal)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.logOutBtn.isHidden = !Reachability.isReachable
        
    }
    
    // get fb user data
    func getFBUserData(){
        if !Reachability.isReachable{
           return
        }
        PKHUD.sharedHUD.show()
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                PKHUD.sharedHUD.hide()
                if (error == nil){
                    
                    let dict = result as! [String : AnyObject]
                    //print(result!)
                    
                    if let name = dict["name"] as? String{
                        self.profileNameLabel.text = name
                        self.logOutBtn.setTitle("SignOutFromFaceBook", for: .normal)
                        
                    }

                    
                }

            })
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func pressLogOutBtn(_ sender: Any) {
    if Reachability.isReachable{
        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            GIDSignIn.sharedInstance().signOut()
           // GIDSignIn.sharedInstance().disconnect()
            setLoginVCRootController()
        }else if  (FBSDKAccessToken.current()) != nil{
            FBSDKLoginManager().logOut()
            setLoginVCRootController()
        }else{
             do{
                try Auth.auth().signOut()
               setLoginVCRootController()
            } catch(let error as NSError){
                
                print(error.localizedDescription)
            }
        }
        
    }
}
    
    func setLoginVCRootController(){
            DispatchQueue._onceTracker.removeAll()
        DispatchQueue.main.async {
            let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            UIApplication.shared.keyWindow?.rootViewController = loginVC
        }
        
        
        
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
