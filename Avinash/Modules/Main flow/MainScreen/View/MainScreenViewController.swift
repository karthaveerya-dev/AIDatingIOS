//
//
//
//  MainScreenViewController.swift
//	Avinash
//

import UIKit

class MainScreenViewController: UIViewController {
    var mainView = MainScreenView()
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        
        initViewController()
    }
    
    private func initViewController() {
        title = "Main app screen"
        
        mainView.logOutButton.addTarget(self, action: #selector(logOutButtonTapped(_:)), for: .touchUpInside)
    }
}

//MARK: - helpers and handlers
extension MainScreenViewController {
    @objc private func logOutButtonTapped(_ sender: UIButton) {
        AuthorizationService.shared.state = .noneAuthorized
    }
}
