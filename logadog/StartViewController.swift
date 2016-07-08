//
//  StartViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-25.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class StartViewController: UIViewController {
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        
        view.backgroundColor = Colors.colorWithHexString(COLOR_BACKGROUND_VIEW)
        signupButton.setTitleColor(Colors.colorWithHexString(COLOR_BUTTON), forState: .Normal)
        loginButton.setTitleColor(Colors.colorWithHexString(COLOR_BUTTON), forState: .Normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let token = TokenController.getToken()
        if !(token ?? "").isEmpty {
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("dogsListSegue", sender: self)
                }
            } else {
                // There is a token, but it's expired. User must log in again
                TokenController.removeTokenAndUser()
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                }
        }
    }
}
    


