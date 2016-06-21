//
//  ActivityViewController.swift
//  Logadog
//
//  Created by Henrik Fogelberg on 2016-06-21.
//  Copyright © 2016 Henrik Fogelberg. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    
    var dogId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Activity VC. Dog id: \(dogId)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
