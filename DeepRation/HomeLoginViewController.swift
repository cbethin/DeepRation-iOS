//
//  HomeLoginViewController.swift
//  DeepRation
//
//  Created by Charles Bethin on 1/16/19.
//  Copyright © 2019 Charles Bethin. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class HomeLoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var gSigninButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.uiDelegate = self
        
        gSigninButton.frame = CGRect(origin: gSigninButton.center, size: CGSize(width: gSigninButton.frame.width, height: 180))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
