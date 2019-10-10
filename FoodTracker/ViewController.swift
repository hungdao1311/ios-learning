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
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Handle the text field’s user input through delegate callbacks.
        userNameTextField.delegate = self
        // safe
        // unsafe
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textLabel.text = textField.text
    }
    
    //MARK: Actions
    @IBAction func getResponseFromLabel(_ sender: UIButton) {
        guard let url = URL(string: textLabel.text!) else {
            self.resultTextView.text = "Invalid URL"
            return
        }
         DataService(url: url)
            .setMethod(method: .post)
            .setBody(body: UrlEncodedBody([
                "username":"2323",
                "password":"ewee",
                "client":"244"
            ]))
            .getRawResult { (result, error) in
                if let error = error {
                    self.resultTextView.text = error.localizedDescription
                } else {
                    self.resultTextView.text = result!.description
                }
//            .getObject() { (result: Response?, error) in
//            if let error = error {
//                switch error {
//                case ParserError.DictionaryCasting:
//                    self.resultTextView.text = "Error when casting object to dictionary"
//                case ParserError.EmptyResponse:
//                    self.resultTextView.text = "The specified URL returns an empty response"
//                case ParserError.JsonParsing:
//                    self.resultTextView.text = "Error parsing JSON"
//                default:
//                    self.resultTextView.text = error.localizedDescription
//                }
//            } else {
//                self.resultTextView.text = result!.description
//            }
        }
    }
}
