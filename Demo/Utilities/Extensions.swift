//
//  Extensions.swift
//  Demo
//
//  Created by Rushabh Shah on 10/8/19.
//  Copyright © 2019 Rushabh Shah. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    static let flexibleBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
}

extension UIAlertController {
    
    class func showAlertWithOk(forTitle title: String, message: String,sender: UIViewController, okTitle: String = "OK", okCompletion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .default) { (okAlertAction) in
            if okCompletion != nil {
                okCompletion!()
            }
        }
        alertController.addAction(okAction)
        sender.present(alertController, animated: true, completion: nil)
    }
    
    class func showAlertWithOkCancel(forTitle title: String, message: String,sender: UIViewController, okTitle: String = "OK", cancelTitle: String = "Cancel", okCompletion: (() -> Void)?, cancelCompletion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okTitle, style: .destructive) { (okAlertAction) in
            if okCompletion != nil {
                okCompletion!()
            }
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (alertAction) in
            if cancelCompletion != nil {
                cancelCompletion!()
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        sender.present(alertController, animated: true, completion: nil)
    }
}

extension String {
    
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isMobileNumber: Bool {
        let numberCharacters = CharacterSet(charactersIn: "+1234567890").inverted
        let isMobileNumber = self.rangeOfCharacter(from: numberCharacters) == nil
        return (!self.isEmpty && isMobileNumber) && self.count == 13  && self.hasPrefix("+91")
    }
    
    var isValidPassword: Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    var isValidUserName: Bool {
        let userNameCharSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "._")).inverted
        return self.rangeOfCharacter(from: userNameCharSet) == nil && self.count < 20
    }
    
}

extension Date {
    
    func getString(inFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inFormat
        return dateFormatter.string(from: self)
    }

}
