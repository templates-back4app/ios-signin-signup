//
//  ViewController.swift
//  Access
//
//  Created by Lucas Fraga Schuler on 4/25/21.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    
    @IBOutlet weak var txtUsernameSignin: UITextField!
    @IBOutlet weak var txtPasswordSignin: UITextField!
    @IBOutlet weak var indicatorSignin: UIActivityIndicatorView!
    
    @IBOutlet weak var txtUsernameSignup: UITextField!
    @IBOutlet weak var txtPasswordSignup: UITextField!
    @IBOutlet weak var indicatorSignup: UIActivityIndicatorView!
    
    @IBOutlet weak var btnLogout: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnLogout.isHidden = true
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.systemBlue]
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillAppear(notification:)),name: UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillDisappear(notification:)),name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func signin(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: self.txtUsernameSignin.text!, password: self.txtPasswordSignin.text!) {
          (user: PFUser?, error: Error?) -> Void in
          if user != nil {
            self.displayAlert(withTitle: "Login Successful", message: "")
            self.btnLogout.isHidden = false
          } else {
            self.displayAlert(withTitle: "Error", message: error!.localizedDescription)
          }
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        let user = PFUser()
        user.username = self.txtUsernameSignup.text
        user.password = self.txtPasswordSignup.text
        
        self.indicatorSignup.startAnimating()
        user.signUpInBackground {(succeeded: Bool, error: Error?) -> Void in
            self.indicatorSignup.stopAnimating()
            if let error = error {
                self.displayAlert(withTitle: "Error", message: error.localizedDescription)
            } else {
                self.displayAlert(withTitle: "Success", message: "Account has been successfully created")
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        PFUser.logOut()
        self.btnLogout.isHidden = true
    }
    
    func displayAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    @objc func keyboardWillAppear(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == 0 && (txtPasswordSignup.isFirstResponder || txtUsernameSignup.isFirstResponder ) {
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

