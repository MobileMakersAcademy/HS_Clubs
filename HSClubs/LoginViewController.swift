//
//  LoginViewController.swift
//  HSClubs
//
//  Created by Bruce Wayne on 11/24/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
    @IBAction func logUserOnTapped(sender: UIButton)
    {
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text) { (returnedUser, returnedError) -> Void in
            if returnedError == nil
            {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else
            {
                self.showErrorAlert("We were unable to login that user account", error: returnedError)
            }
        }
    }

    @IBAction func signUserUpOnTapped(sender: UIButton)
    {
        let user = PFUser()
        user.email = usernameTextField.text
        user.username = usernameTextField.text
        user.password = passwordTextField.text

        user.signUpInBackgroundWithBlock { (returnedResult, returnedError) -> Void in
            if returnedError == nil
            {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else
            {
                self.showErrorAlert("Unable to sign up user", error: returnedError)
            }
        }
    }

    func showErrorAlert(title: String, error: NSError)
    {
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}
