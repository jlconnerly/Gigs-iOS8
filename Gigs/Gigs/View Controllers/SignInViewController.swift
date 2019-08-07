//
//  SignInViewController.swift
//  Gigs
//
//  Created by Jake Connerly on 8/7/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import UIKit

enum SignInType {
    case signUp
    case signIn
}

class SignInViewController: UIViewController {
    
    //
    // MARK: - IBOutlets & Properties
    //
    
    var authController: AuthenticationController?
    var signInType: SignInType = .signUp

    @IBOutlet weak var signInSegmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    
    //
    // MARK: - IBActions & Methods
    //
    
    @IBAction func signInSegmentedControlDidChangeValue(_ sender: UISegmentedControl) {
        if signInSegmentedControl.selectedSegmentIndex == 1 {
            signInType = .signIn
            signInButton.setTitle("Sign In", for: .normal)
        }else {
            signInType = .signUp
            signInButton.setTitle("Sign Up", for: .normal)
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        guard let username = usernameLabel.text,
              !username.isEmpty,
              let password = passwordLabel.text,
              !password.isEmpty else { return }
        
        // MARK: - Sign Up Type
        
        if signInType == .signUp {
            authController?.signUp(username: username, password: password, completion: { (error) in
                guard error == nil else { return }
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Sign Up Successful", message: "Now please sign in", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                        self.signInType = .signIn
                        self.signInSegmentedControl.selectedSegmentIndex = 1
                        self.signInButton.setTitle("Sign In", for: .normal)
                    })
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            })
            
        //MARK:- Sign In Type
            
        }else {
            
            authController?.signIn(with: username, password: password, completion: { (error) in
                guard error == nil else { return }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    
    //
    // MARK: - Navigation
    //
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
