//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Jake Connerly on 8/8/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    
    @IBOutlet weak var jobTItleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextview: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
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
