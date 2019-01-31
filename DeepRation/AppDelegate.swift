//
//  AppDelegate.swift
//  DeepRation
//
//  Created by Charles Bethin on 1/8/19.
//  Copyright © 2019 Charles Bethin. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
    
        let currentUser = Auth.auth().currentUser
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if currentUser == nil {
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "loginVC")
        } else {
            DeepRationManager.shared.uid = currentUser?.uid
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "mainVC")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // Firebase
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error occured on google sign in:", error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            guard error == nil else {
                print("Error signing in: \(error as Any)")
                return
            }
            
            Auth.auth().currentUser?.getIDTokenForcingRefresh(true, completion: { (idToken, error) in
                guard error == nil else {
                    print("Error geting idToken: \(error as Any)")
                    return
                }
                
                DeepRationManager.shared.signInUser(withIDToken: idToken!)
                self.tryToMoveToMainView()
            })
        }
        
        DeepRationManager.shared.profile = user.profile
        print("USER PROFILE: \(user.profile as Any)")
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform operations for when user disconnects
    }
    
    func tryToMoveToMainView() {
        let currentUser = Auth.auth().currentUser
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if currentUser != nil {
            DeepRationManager.shared.uid = currentUser?.uid
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "mainVC")
//            UIApplication.setRootView(storyboard.instantiateViewController(withIdentifier: "mainVC"))
        }
    }

}

