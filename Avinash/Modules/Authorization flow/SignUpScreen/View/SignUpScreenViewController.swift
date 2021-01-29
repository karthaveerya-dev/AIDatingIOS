//
//
//
//  SignUpScreenViewController.swift
//	Avinash
//

import UIKit

class SignUpScreenViewController: UIViewController {
    var mainView = SignUpScreenView()
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        
        initViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.nameTextField.textField.becomeFirstResponder()
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
        mainView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped(_:)), for: .touchUpInside)
        
        mainView.nameTextField.textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        mainView.emailTextField.textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
        mainView.passwordTextField.textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
    }
}

//MARK: - helpers and handlers
extension SignUpScreenViewController {
    @objc private func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func signUpButtonTapped(_ sender: UIButton) {
        signUp()
    }
    
    @objc func textFieldValueChanged(_ sender: UITextField) {
        validateAllInfo()
    }
    
    private func validateAllInfo() {
        guard let name = mainView.nameTextField.text,
              let email = mainView.emailTextField.text,
              let password = mainView.passwordTextField.text else {
            return
        }
        
        let isValidated = !name.isEmptyOrTooShort() &&
                          email.isValidEmail() &&
                          password.length > 8
        
        mainView.signUpButton.alpha = (isValidated ? 1 : 0.5)
        mainView.signUpButton.isEnabled = isValidated
    }
    
    private func signUp() {
        guard let name = mainView.nameTextField.text,
              let email = mainView.emailTextField.text,
              let password = mainView.passwordTextField.text else {
            return
        }
        
        ProgressHelper.show()
        AuthorizationService.shared.registerUser(email: email,
                                                 username: name,
                                                 password: password) { (error) in
            ProgressHelper.hide()
            AlertHelper.show(message: error.localizedDescription)
        } success: { (data) in
            ProgressHelper.hide()
            do {
                let defaultResponseModel = try JSONDecoder().decode(DefaultResponseModel.self, from: data)
                if defaultResponseModel.status {
                    AuthorizationService.shared.state = .authorized
                } else {
                    AlertHelper.show(message: defaultResponseModel.errorText, controller: self)
                }
            } catch let error {
                debugPrint(error.localizedDescription)
                AlertHelper.show(message: NetworkError.errorSerializationJson.localizedDescription, controller: self)
            }
        }
    }
}
