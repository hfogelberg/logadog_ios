//
//  PuchaseViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-26.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit
import SwiftyJSON

class PuchaseViewController: UIViewController {

    @IBOutlet weak var objectTextfield: UITextField!
    @IBOutlet weak var dateTextfield: UITextField!
    @IBOutlet weak var costTextfield: UITextField!
    @IBOutlet weak var commentTextview: UITextView!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var purchaseId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func editButtonTapped(sender: AnyObject) {
    }
}
