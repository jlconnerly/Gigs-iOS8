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
    
    let authController = AuthenticationController()
    
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
        
        if authController.bearer == nil {
            performSegue(withIdentifier: "SignInSegue", sender: self)
        }else {
            //fetch gigs
        }
    }
    

    
    //
    // MARK: - Navigation
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInSegue" {
            guard let signUpVC = segue.destination as? SignInViewController else { return }
            signUpVC.authController = authController
        }
    }
    

}

extension GigsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GigCell", for: indexPath)
        
        return cell
    }
}

extension GigsViewController: UITableViewDelegate {
}
