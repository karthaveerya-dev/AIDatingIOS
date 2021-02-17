//
//  CustomTextField.swift
//  Telesim
//
//  Created by KMI on 11.05.2020.
//  Copyright © 2020 4K-SOFT. All rights reserved.
//

import UIKit

class CustomTextField: UIView, ErrorBehaviour {
    
    var type: TextFieldType
    
    var text: String? {
        get {
            return textField.text
        }
        set {
            textFieldDidBeginEditing(textField)
            textField.text = newValue
            textFieldDidEndEditing(textField)
        }
    }
    
    var animationDuration = 0.2
    
    // MARK: - Properties
    
    lazy var fieldNameLabel: UILabel = {
        let obj = UILabel()
        obj.alpha = 0.5
        obj.font = UIFont.ProximaNovaRegular(size: 15)
        obj.textColor = UIColor.white
        obj.text = type.text
        return obj
    }()
    
    var separator: UIView = {
        let obj = UIView()
        obj.backgroundColor = UIColor.white
        obj.alpha = 0.5
        return obj
    }()
    
    lazy var textField: UITextField = {
        let obj = UITextField()
        obj.textColor = UIColor.white
        obj.font = UIFont.ProximaNovaRegular(size: 18)
        obj.keyboardType = type.keyboardType
        obj.returnKeyType = .done
        obj.delegate = self
        return obj
    }()
    
    lazy var eyeButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.setImage(UIImage(named: "eyeIcon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        obj.imageView?.contentMode = .scaleAspectFit
        obj.tintColor = .white
        return obj
    }()
    
    // MARK: - Initializations
    
    init(fieldType: TextFieldType) {
        type = fieldType
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setup() {
        backgroundColor = .clear
        
        addSubview(fieldNameLabel)
        addSubview(textField)
        addSubview(separator)
        
        if type == .password || type == .retypePassword || type == .passwordExt {
            textField.isSecureTextEntry = true
            textField.rightView = eyeButton
            textField.rightViewMode = .always
            
            eyeButton.addTarget(self, action: #selector(toogleSecureTextEntry(_:)), for: .touchUpInside)
        }
        
        textField.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
    
        fieldNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(SizeHelper.sizeH(20))
            make.bottom.equalTo(textField).offset(-2)
            make.left.right.equalTo(textField)
        }

        separator.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.right.equalTo(textField)
            make.height.equalTo(2)
        }
    }
    
    @discardableResult override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
}

// MARK: - Helpers and handlers

extension CustomTextField {
    @objc func toogleSecureTextEntry(_ sender: UIButton) {
        textField.isSecureTextEntry.toggle()
        let imageName = textField.isSecureTextEntry ? "eyeIcon" : "eyeCrossedIcon"
        eyeButton.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
    }
}

// MARK: - UITextField Delegate

extension CustomTextField: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: animationDuration) {
            self.separator.alpha = 1
            self.fieldNameLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8).translatedBy(x: -self.fieldNameLabel.bounds.width / 8, y: SizeHelper.sizeH(-30))
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            UIView.animate(withDuration: animationDuration) {
                self.separator.alpha = 0.5
                self.fieldNameLabel.transform = .identity
            }
        }
    }

}

extension CustomTextField {
    
    enum TextFieldType {
        case name
        case location
        case email
        case password
        case passwordExt
        case retypePassword
        
        var text: String {
            switch self {
            case .name:
                return "name".localized()
            case .location:
                return "location".localized()
            case .email:
                return "email".localized()
            case .password:
                return "password".localized()
            case .passwordExt:
                return "passwordExt".localized()
            case .retypePassword:
                return "retype_password".localized()
            }
        }
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .name,
                 .password,
                 .passwordExt,
                 .retypePassword,
                 .location:
                return .default
            case .email:
                return .emailAddress
            }
        }
    }
    
}

