//
//
//
//  EnterEmailScreenViewController.swift
//	Avinash
//

import UIKit

class EnterEmailScreenViewController: UIViewController {
    var mainView = EnterEmailScreenView()
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        
        initViewController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.emailTextField.textField.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.emailTextField.textField.becomeFirstResponder()
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
        mainView.emailTextField.textField.addTarget(self, action: #selector(emailTextFieldDidChangeValue(_:)), for: .editingChanged)
        mainView.nextButton.addTarget(self, action: #selector(nextButtonTapped(_:)), for: .touchUpInside)
    }
}

//MARK: - helpers and handlers
extension EnterEmailScreenViewController {
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func emailTextFieldDidChangeValue(_ sender: UITextField) {
        guard let emailString = sender.text else {
            return
        }
        
        mainView.nextButton.isEnabled = emailString.isValidEmail()
        mainView.nextButton.alpha = (emailString.isValidEmail() ? 1 : 0.5)
    }
    
    @objc private func nextButtonTapped(_ sender: UIButton) {
        let enterPasswordVC = EnterPasswordScreenViewController()
        enterPasswordVC.email = mainView.emailTextField.text?.lowercased() ?? ""
        navigationController?.pushViewController(enterPasswordVC, animated: true)
    }
}

