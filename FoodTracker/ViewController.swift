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
        let url = URL(string: "https://auth.dev.4tellus.net/auth/realms/evv-dev/protocol/openid-connect/token")!
         DataService(url: url)
            .setMethod(method: .post)
            .setBody(body: UrlEncodedBody([
                "client_id": "mobile-dev",
                "username": self.userNameTextField.text!,
                "password": self.passwordTextField.text!,
                "grant_type":"password"
            ]))
            .getObject() { [weak self] (result: Token?, apiError: ErrorResponse?, error) in
            if let error = error {
                var alertMessage: String
                switch error {
                case ParserError.DictionaryCasting:
                    alertMessage = "Error when casting object to dictionary"
                case ParserError.EmptyResponse:
                    alertMessage = "The specified URL returns an empty response"
                case ParserError.JsonParsing:
                    alertMessage = "Error parsing JSON"
                default:
                    alertMessage = error.localizedDescription
                }
                let alert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            } else if let apiError = apiError {
                let alert = UIAlertController(title: "Error response", message: apiError.description, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            } else {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let responseViewController = storyBoard.instantiateViewController(withIdentifier: "responseViewController") as! ResponseViewController
                self?.present(responseViewController, animated: true, completion: nil)
            }
        }
    }
}
