//
//  SignupController.swift
//  Demo
//
//  Created by Rushabh Shah on 10/7/19.
//  Copyright © 2019 Rushabh Shah. All rights reserved.
//

import UIKit

class SignupController: UITableViewController {

    //MARK: Outlets
    @IBOutlet weak var fullNameTextField: CoreTextField!
    @IBOutlet weak var usernameTextField: CoreTextField!
    @IBOutlet weak var emailTextField: CoreTextField!
    @IBOutlet weak var dateOfBirthTextField: CoreDatePickerTextField!
    @IBOutlet weak var mobileNumberTextField: CoreTextField!
    @IBOutlet weak var passwordTextField: CoreTextField!
    
    //MARK: - Properties
    private var selectedBirthDate: Date?
    
    //MARK: - Main View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        handleEvents()
        dateOfBirthTextField.datePickerMode = .date
        mobileNumberTextField.text = "+91"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !((KeychainService.loadPassword() ?? "") as String).isEmpty {
            self.performSegue(withIdentifier: "PresentHomeNavVC", sender: nil)
        }
    }
    
    //MARK: - Handle Button Actions
    @IBAction func didTapSaveBarButton(_ sender: UIBarButtonItem) {
        let fullName = fullNameTextField.text!
        let userName = usernameTextField.text!
        let email = emailTextField.text!
        let mobileNumber = mobileNumberTextField.text!
        let password = passwordTextField.text!
        if validateFields(fullName: fullName, userName: userName, email: email, dob: selectedBirthDate, mobileNumber: mobileNumber, password: password) {
            CoreDataManager.shared.insertUser(fullName: fullName, userName: userName, email: email, dob: selectedBirthDate!, mobileNumber: mobileNumber) {
                KeychainService.savePassword(password: password)
                self.performSegue(withIdentifier: "PresentHomeNavVC", sender: nil)
            }
        }
    }
    
    //MARK: - Other Methods
    private func handleEvents() {
        fullNameTextField.blockForShouldReturn = {
            self.usernameTextField.becomeFirstResponder()
            return true
        }
        usernameTextField.blockForShouldReturn = {
            self.emailTextField.becomeFirstResponder()
            return true
        }
        emailTextField.blockForShouldReturn = {
            self.dateOfBirthTextField.becomeFirstResponder()
            return true
        }
        dateOfBirthTextField.blockForDoneButtonTap = { selectedDate in
            self.dateOfBirthTextField.text = selectedDate.getString(inFormat: "dd-MMM-yyyy")
            self.selectedBirthDate = selectedDate
            self.mobileNumberTextField.becomeFirstResponder()
        }
        mobileNumberTextField.blockForShouldReturn = {
            self.passwordTextField.becomeFirstResponder()
            return true
        }
        passwordTextField.blockForShouldReturn = { return true }
        mobileNumberTextField.blockForShouldChangeCharacters = { range, text in
            return range.location >= 3
        }
    }
    
    private func validateFields(fullName: String, userName: String, email: String, dob: Date? = nil, mobileNumber: String, password: String) -> Bool {
        var message = ""
        let dobYear = Calendar.current.component(.year, from: dob ?? Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        if fullName.isEmpty {
            message = "Please enter your full name"
        } else if fullName.count > 50 {
            message = "Full name must be less than 50 characters"
        } else if userName.isEmpty {
            message = "Please enter your username"
        } else if userName.count > 20 {
            message = "Username must be less than 20 characters"
        } else if !userName.isValidUserName {
            message = "Username must only contain alphanumeric, . & _ characters"
        } else if email.isEmpty {
            message = "Please enter your email"
        } else if !email.isEmail {
            message = "Please enter valid email"
        } else if dob == nil {
            message = "Please select your age"
        } else if (currentYear - dobYear) <= 18 {
            message = "Your age must be greater than 18"
        } else if mobileNumber.isEmpty {
            message = "Please enter your Mobile number"
        } else if !mobileNumber.isMobileNumber {
            message = "Please enter valid Mobile number"
        } else if password.isEmpty {
            message = "Please enter your password"
        } else if !password.isValidPassword {
            message = "Password must contain at-least one capital char one special char and one digit with minimum 8 chars length"
        }
        if !message.isEmpty {
            UIAlertController.showAlertWithOk(forTitle: "Cannot register!", message: message, sender: self, okCompletion: nil)
            return false
        }
        return true
    }


}

