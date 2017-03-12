//
//  LoginViewController.swift
//  ParseInstagramCP
//
//  Created by Eric Suarez on 3/6/17.
//  Copyright © 2017 Eric Suarez. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(_ title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        })))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.DismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        
        var errorMessage = "Please try again later"
        
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) {
            (user: PFUser?, error: Error?) -> Void in
            
            //            self.activityIndicator.stopAnimating()
            //            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if user != nil {
                // Do stuff after successful login.
                self.performSegue(withIdentifier: "loginSegue", sender: self)
                print("logged in!")
                
            } else {
                // The login failed. Check error to see why.
                
                if let errorString = error!.localizedDescription as? String {
                    
                    errorMessage = errorString
                    
                }
                
                self.displayAlert("Login Failed", message: errorMessage)
                
            }
        }
        
    }

    
    @IBAction func signUpPressed(_ sender: Any) {
        
        let newUser = PFUser()
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackground(block: { (success: Bool, error: Error?) -> Void in
            if success {
                // Hooray! Let them use the app now.
                print("Created a new user!")
                
                self.performSegue(withIdentifier: "loginSegue", sender: self)
                
            } else {
                let errorString = error?.localizedDescription as? NSString
                // Show the errorString somewhere and let the user try again.
                
                self.displayAlert("Login Failed", message: (errorString as? String)!)
            }
        })
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
