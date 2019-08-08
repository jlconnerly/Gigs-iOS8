//
//  GigsViewController.swift
//  Gigs
//
//  Created by Jake Connerly on 8/7/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

class GigsViewController: UIViewController {
    
    //
    //MARK: - IBOutlets & Properties
    //
    
    @IBOutlet weak var tableView: UITableView!
    
    let gigController = GigController()
    
    let dateFormatter = DateFormatter()
    
    //
    //MARK: - View LifeCycle
    //

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gigController.bearer == nil {
            performSegue(withIdentifier: "SignInSegue", sender: self)
        }else {
            gigController.fetchAllGigs { (result) in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    

    
    //
    // MARK: - Navigation
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInSegue" {
            guard let signUpVC = segue.destination as? SignInViewController else { return }
            signUpVC.gigController = gigController
        }
        
        if segue.identifier == "AddGigSegue" {
            guard let addGigVC = segue.destination as? GigDetailViewController else { return }
            addGigVC.gigController = gigController
        }
        
        if segue.identifier == "ShowGigSegue" {
            guard let showGigVC = segue.destination as? GigDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow else { return }
            showGigVC.gigController = gigController
            showGigVC.gig = gigController.gigs[indexPath.row]
        }
    }
    

}

extension GigsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gigController.gigs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        let gig = gigController.gigs[indexPath.row]
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        cell.textLabel?.text = gig.title
        
        cell.detailTextLabel?.text = dateFormatter.string(from: gig.dueDate)
        return cell
    }
}

extension GigsViewController: UITableViewDelegate {
}
