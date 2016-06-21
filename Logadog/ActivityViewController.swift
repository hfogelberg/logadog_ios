//
//  ActivityViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-21.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    
    @IBOutlet weak var typeTextfield: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var clubTextField: UITextField!
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var isCompetitionSegue: UISegmentedControl!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var activityDatePicker: UIDatePicker!
    
    var dogId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Don't use IQKeyboardManager for this field
        dateTextField.inputAccessoryView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        dateView.hidden = true
    }
    
    @IBAction func datePickerDoneTapped(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.stringFromDate(activityDatePicker.date)
        dateTextField.text = date
        self.dateView.hidden = true
    }
    
    @IBAction func dateCancelTapped(sender: AnyObject) {
        dateView.hidden = true
    }
    
    @IBAction func dateFieldTapped(sender: AnyObject) {
       dateView.hidden = false
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        print("Save tapped")
    }
}
