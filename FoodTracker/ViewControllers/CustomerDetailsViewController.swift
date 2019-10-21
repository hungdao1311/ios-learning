//
//  CustomerDetailsViewController.swift
//  FoodTracker
//
//  Created by Hung Dao on 10/18/19.
//  Copyright © 2019 Hung Dao. All rights reserved.
//

import UIKit

class CustomerDetailsViewController: UIViewController {
    
    var customer: Customer?
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var idTexField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let customer = customer else {
            fatalError("No customer received for this view")
        }
        firstNameTextField.text = customer.firstName
        lastNameTextField.text = customer.lastName
        idTexField.text = customer.id
    }
}

