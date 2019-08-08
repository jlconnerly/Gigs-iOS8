//
//  GigDetailViewController.swift
//  Gigs
//
//  Created by Jake Connerly on 8/8/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    var gigController: GigController?
    
    var gig: Gig?
    
    @IBOutlet weak var jobTitleTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var descriptionTextview: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        updateViews()
        
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let gigController = gigController else { return }
        
        if let title = jobTitleTextField?.text,
           let description = descriptionTextview.text,
           !title.isEmpty,
            !description.isEmpty {
            let dueDate = dueDatePicker.date
            gigController.createGig(with: title, dueDate: dueDate, description: description) { error in
                guard error == nil else { return }
                
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
        
    }
    
    private func updateViews() {
        guard let gig = gig else {
            self.title = "New Gig"
            self.saveButton.isEnabled = true
            return
        }
        title = gig.title
        jobTitleTextField.text = gig.title
        descriptionTextview.text = gig.description
        dueDatePicker.date = gig.dueDate
    }

}
