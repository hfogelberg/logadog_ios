//
//  IdentityViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-05-30.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

class IdentityViewController: UIViewController {
    @IBOutlet weak var chipmarkTextfield: UITextField!
    @IBOutlet weak var earmarktextfield: UITextField!
    @IBOutlet weak var passportTextfield: UITextField!
    @IBOutlet weak var commenttextview: UITextView!
    
    override func viewDidLoad() {
        print("IdentityVC")
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        print("Save identity")
        
        
    }
}
