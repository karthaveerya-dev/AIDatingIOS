//
//
//
//  EnterPasswordScreenViewController.swift
//	Avinash
//

import UIKit

class EnterPasswordScreenViewController: UIViewController {
    var mainView = EnterPasswordScreenView()
    
    var email: String = "" {
        didSet {
            mainView.email = email
        }
    }
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        
        initViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.passwordTextField.textField.becomeFirstResponder()
    }
    
    private func initViewController() {
        //close screen navBar button
        let leftBarButton = UIBarButtonItem(customView: mainView.backButton)
        leftBarButton.customView?.snp.updateConstraints({ (make) in
            make.width.equalTo(40)
            make.height.equalTo(44)
        })
        navigationItem.leftBarButtonItem = leftBarButton
        
        mainView.backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        mainView.passwordTextField.textField.addTarget(self, action: #selector(passwordTextFieldDidChangeValue(_:)), for: .editingChanged)
        mainView.signInButton.addTarget(self, action: #selector(signInButtonTapped(_:)), for: .touchUpInside)
    }
}

//MARK: - helpers and handlers
extension EnterPasswordScreenViewController {
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func passwordTextFieldDidChangeValue(_ sender: UITextField) {
        guard let password = sender.text else {
            return
        }
        
        mainView.signInButton.isEnabled = password.length > 8
        mainView.signInButton.alpha = (password.length > 8 ? 1 : 0.5)
    }
    
    @objc private func signInButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

