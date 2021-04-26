//
//  ViewController.swift
//  Access
//
//  Created by Lucas Fraga Schuler on 4/25/21.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    
    @IBOutlet weak var txt_username_signin: UITextField!
    @IBOutlet weak var txt_password_signin: UITextField!
    @IBOutlet weak var indicator_signin: UIActivityIndicatorView!
    
    @IBOutlet weak var txt_username_signup: UITextField!
    @IBOutlet weak var txt_password_signup: UITextField!
    @IBOutlet weak var indicator_signup: UIActivityIndicatorView!
    
    @IBOutlet weak var btn_logout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btn_logout.isHidden = true
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.systemBlue]
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillAppear(notification:)),name: UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillDisappear(notification:)),name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func signin(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: self.txt_username_signin.text!, password: self.txt_password_signin.text!) {
          (user: PFUser?, error: Error?) -> Void in
          if user != nil {
            self.displayAlert(withTitle: "Login Successful", message: "")
            self.btn_logout.isHidden = false
          } else {
            self.displayAlert(withTitle: "Error", message: error!.localizedDescription)
          }
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        let user = PFUser()
        user.username = self.txt_username_signup.text
        user.password = self.txt_password_signup.text
        
        self.indicator_signup.startAnimating()
        user.signUpInBackground {(succeeded: Bool, error: Error?) -> Void in
            self.indicator_signup.stopAnimating()
            if let error = error {
                self.displayAlert(withTitle: "Error", message: error.localizedDescription)
            } else {
                self.displayAlert(withTitle: "Success", message: "Account has been successfully created")
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        PFUser.logOut()
        self.btn_logout.isHidden = true
    }
    
    func displayAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    @objc func keyboardWillAppear(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 && (txt_password_signup.isFirstResponder || txt_username_signup.isFirstResponder ) {
               self.view.frame.origin.y -= keyboardSize.height - 40
           }
       }
    }
    
    @objc func keyboardWillDisappear(notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

