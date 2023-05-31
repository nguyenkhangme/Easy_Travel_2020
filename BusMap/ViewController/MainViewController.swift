//
//  MainViewController.swift
//  BusMap
//
//  Created by user on 6/8/20.
//  Copyright © 2020 vinova. All rights reserved.
//

import UIKit
import GoogleSignIn
import Realm
import RealmSwift

class MainViewController: UIViewController {

    @IBOutlet weak var GIDSignInButton1: GIDSignInButton!
    let googleSignInButton = UIButton()
    
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
//        let queryRecentt = RecentQuery1()
//
//        try! realm.write{
//                        queryRecentt.setup(query: ".", user: "")
//                       realm.add(queryRecentt)
//        }

        
        let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationItem.backBarButtonItem = backBarButtton

        self.navigationItem.setHidesBackButton(true, animated: true);
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "old-map-background.jpg")!)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.rgb(r: 25, g: 51, b: 102)
        self.navigationController?.navigationBar.tintColor = UIColor.rgb(r: 0, g: 0, b: 0)

        
        self.view.backgroundColor = UIColor.rgb(r: 25, g: 51, b: 102)
//        GIDSignIn.sharedInstance()?.scopes.append(kGTLAuthScopeCalendarReadonly)
//        let auth: GTMOAuth2Authentication = GIDSignIn.sharedInstance()?.currentUser.authentication.fetchAuthorizer()
        
        GIDSignInButton1.isHidden = true
        email.textColor = .black
        
        refreshInterface()
        //(UIApplication.shared.delegate as! AppDelegate).signInCallback = refreshInterface
        (UIApplication.shared.delegate as! AppDelegate).signInCallback = refreshInterface

        //776959329784-pie0c3i77kgrugb7606graao3ctvkei6.apps.googleusercontent.com
        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance()?.presentingViewController = self

         // Automatically sign in the user.
         GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
       
        
        configureGoogleSignInButton()
        configureGIDDignInButton()
        
       // email.text = User.sharedInstance.email
        
        ///
    
        ///
        
       
    }
    
     let signInButton = GIDSignInButton(frame: CGRect(x: 0,y: 0,width: 100,height: 50))
    func configureGIDDignInButton(){
       
        signInButton.center = view.center
        
        view.addSubview(signInButton)
    }

    func refreshInterface() {
        if let currentUser = GIDSignIn.sharedInstance()?.currentUser {
            GIDSignInButton1.isHidden = true
            googleSignInButton.isHidden = true
            signInButton.isHidden = true
            googleSignOutButton.isHidden = true
            self.email.isHidden = true
            //self.email.text = User.sharedInstance.email
            print("welcome")
            User.sharedInstance.email = currentUser.profile.email
            self.email.text = "Welcome, \(currentUser.profile.name ?? "")"
            self.navigationController?.pushViewController(GoogleMapsViewController(), animated: true)
            //self.present(MapBoxViewController(), animated: true, completion: nil)
        } else {
            GIDSignInButton1.isHidden = true
            googleSignInButton.isHidden = true //Hide custom Login Button
            signInButton.isHidden = false
            googleSignOutButton.isHidden = true
            self.email.isHidden = false
            self.email.text = "Easy Travel"
            print("Not sign in yet")
        }
    }
    func configureGoogleSignInButton(){
         view.addSubview(googleSignInButton)
        
        googleSignInButton.setTitleColor(.black, for: .normal)
        googleSignInButton.setTitle("Google Sign In Custom Button", for: .normal)
        googleSignInButton.addTarget(self, action: #selector(onGoogleSignInButtonTap), for: .touchUpInside)
        
          googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
              
        NSLayoutConstraint(item: googleSignInButton, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 0.5, constant: 0).isActive = true
        NSLayoutConstraint(item: googleSignInButton, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 0.5, constant: 0).isActive = true
    }

    @IBOutlet weak var googleSignOutButton: UIButton!
    @IBAction func didTapSignOut(_ sender: AnyObject) {
      GIDSignIn.sharedInstance().signOut()
        //clearOutAllLocalUserInfo()
        refreshInterface()
    }
    
    @objc private func onGoogleSignInButtonTap() {
           GIDSignIn.sharedInstance()?.signIn()
        refreshInterface()
       }
    
    @IBOutlet weak var email: UILabel!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MainViewController: GIDSignInDelegate {
    // MARK: - GIDSignInDelegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        googleSignInButton.isHidden = error == nil
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
          print("The user has not signed in before or they have since signed out.")
        } else {
          print("\(error.localizedDescription)")
        }
        return
      }
      // Perform any operations on signed in user here.
//      let userId = user.userID                  // For client-side use only!
//      let idToken = user.authentication.idToken // Safe to send to the server
//      let fullName = user.profile.name
//      let givenName = user.profile.givenName
//      let familyName = user.profile.familyName
      //let email = user.profile.email
      // ...
        User.sharedInstance.email = user.profile.email
        
    }

}
