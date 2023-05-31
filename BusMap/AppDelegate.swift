//
//  AppDelegate.swift
//  BusMap
//
//  Created by user on 6/8/20.
//  Copyright © 2020 vinova. All rights reserved.
//

import UIKit
import CoreData
import GoogleSignIn
import GooglePlaces
import GoogleMaps

import RealmSwift
import Realm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {


    var signInCallback: (()->())?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Initialize sign-in
        GMSPlacesClient.provideAPIKey("eiei")

        GIDSignIn.sharedInstance().clientID = "eiei"
        GIDSignIn.sharedInstance().delegate = self
        
        
        GMSServices.provideAPIKey("eiei")
        
        // For Back button customization, setup the custom image for UINavigationBar inside CustomBackButtonNavController.
               let backButtonBackgroundImage = UIImage(systemName: "list.bullet")
               let barAppearance =
                   UINavigationBar.appearance(whenContainedInInstancesOf: [MainSearchViewController.self])
               barAppearance.backIndicatorImage = backButtonBackgroundImage
               barAppearance.backIndicatorTransitionMaskImage = backButtonBackgroundImage
               
               // Nudge the back UIBarButtonItem image down a bit.
               let barButtonAppearance =
                   UIBarButtonItem.appearance(whenContainedInInstancesOf: [MainSearchViewController.self])
               barButtonAppearance.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0, vertical: -5), for: .default)
        
        print ("Main VC")
        let creds = SyncCredentials.usernamePassword(username: "ggMaps", password: "123456", register: false);
        SyncUser.logIn(with: creds, server: Constants.AUTH_URL,callbackQueue: .global(), onCompletion: { (user, err) in
                
                print("RWERLoginDtabase")
                if let error = err {
                    // Auth error: user already exists? Try logging in as that user.
                    print("Login failed: \(error)");
                    
                    return;
                }
                
                print("Login succeeded!");
        });
        
        print("OK Login")
        

        return true
    }

    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func application(_ application: UIApplication,
                     open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
          print("The user has not signed in before or they have since signed out.")
        } else {
          print("\(error.localizedDescription)")
        }
        return
      }
        print("Ok! \(String(describing: user.profile.email))")
        signInCallback!()
      // Perform any operations on signed in user here.
//      let userId = user.userID                  // For client-side use only!
//      let idToken = user.authentication.idToken // Safe to send to the server
//      let fullName = user.profile.name
//      let givenName = user.profile.givenName
//      let familyName = user.profile.familyName
//      let email = user.profile.email
      // ...
        User.sharedInstance.email = user.profile.email
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "BusMap")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

