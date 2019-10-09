//
//  CoreDatePickerTextField.swift
//  Demo
//
//  Created by Rushabh Shah on 10/8/19.
//  Copyright © 2019 Rushabh Shah. All rights reserved.
//

import UIKit

class CoreDatePickerTextField: CoreTextField {
    
    //MARK: - Controls
    private lazy var datePicker: UIDatePicker = {
        let pickerView = UIDatePicker()
        return pickerView
    }()
    private var toolBar: CoreToolbar!
    var doneButtonTitle: String = "Done"
    
    //MARK: - Properties
    var blockForCancelButtonTap: voidCompletion?
    var blockForDoneButtonTap: ((_ selectedDate: Date)->Void)?
    var datePickerMode: UIDatePicker.Mode = .dateAndTime {
        didSet {
            self.datePicker.datePickerMode = self.datePickerMode
        }
    }
    
    //MARK: - Methods
    override func commonInit() {
        super.commonInit()
        toolBar = CoreToolbar.getToolbar(doneTitle: doneButtonTitle, doneCompletion: {
            self.resignFirstResponder()
            self.blockForDoneButtonTap?((self.datePicker.date))
        }, cancelCompletion: {
            self.resignFirstResponder()
            self.blockForCancelButtonTap?()
        })
        toolBar.sizeToFit()
        inputView = datePicker
        inputAccessoryView = toolBar
    }
    
}
