//
//  CoreTextField.swift
//  Demo
//
//  Created by Rushabh Shah on 10/7/19.
//  Copyright © 2019 Rushabh Shah. All rights reserved.
//

import UIKit

class CoreTextField: UITextField, UITextFieldDelegate {
    
    //MARK: - Properties
    var blockForTextChange: ((_ newText: String)->Void)? {
        didSet {
            if blockForTextChange != nil {
                addTarget(self, action: #selector(textFieldEditingChange(_:)), for: .editingChanged)
            }
        }
    }
    var blockForShouldReturn: (()->Bool)?
    var blockForShouldBeginEditing: (()->Bool)?
    var blockForShouldChangeCharacters: ((_ range: NSRange, _ replacementString: String)->Bool)?
    
    //MARK: - Init Methods
    func commonInit() {
        delegate = self
        enablesReturnKeyAutomatically = true
    }
    
    
    //MARK: - Other Methods
    @objc func textFieldEditingChange(_ sender: UITextField) {
        blockForTextChange?(sender.text!)
    }
    
    func bind(callback: @escaping (String) -> ()) {
        self.blockForTextChange = callback
    }
    
    //MARK: - UITextFieldDelegate Methods
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let returnBlock = blockForShouldBeginEditing {
            return returnBlock()
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let returnBlock = blockForShouldReturn {
            let res = returnBlock()
            if res {
                self.resignFirstResponder()
            }
            return res
        }
        self.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return blockForShouldChangeCharacters?((range), string) ?? true
    }
    
    //MARK: - Init Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForInterfaceBuilder() {
        commonInit()
    }
}
