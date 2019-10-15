//
//  ViewController.swift
//  FoodTracker
//
//  Created by Hung Dao on 9/23/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Handle the text field’s user input through delegate callbacks.
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        // safe
        // unsafe
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Actions
    @IBAction func getResponseFromLabel(_ sender: UIButton) {
        guard let username = userNameTextField.text, let password = passwordTextField.text else {
            let alert = UIAlertController(title: "Error", message: "Please input username and password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        let url = URL(string: "https://auth.qa.4tellus.net/auth/realms/evv-qa/protocol/openid-connect/token")!
        DataService(url: url)
            .setMethod(method: .post)
            .setBody(body: UrlEncodedBody([
                "client_id": "mobile-qa",
                "username": username,
                "password": password,
                "grant_type":"password"
            ]))
            .getObject() { [weak self] (result: Token?, error) in
                guard let self = self else {
                    return
                }
                if let error = error {
                    let status = ErrorResponse(exception: error)
                    let alertMessage: String
                    if (status.isUnauthorized) {
                        alertMessage = "User name or password does not match"
                    } else {
                        alertMessage = status.errorDescription
                    }
                    let alert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                if let token = result {
                    Settings.shared.accessToken = token.accessToken
                    let responseViewController = self.storyboard!.instantiateViewController(withIdentifier: "CustomerTableViewController") as! CustomerTableViewController
                    self.navigationController!.pushViewController(responseViewController, animated: true)
                }
        }
    }
}
