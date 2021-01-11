//
//
//
//  IntroScreenViewController.swift
//	TouristDoc
//

import UIKit

class IntroScreenViewController: UIViewController {
    var mainView = IntroScreenView()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        
        initViewController()
    }
    
    private func initViewController() {
        mainView.heartButton.addTarget(self, action: #selector(heartButtonTapped(_:)), for: .touchUpInside)
        mainView.eyesButton.addTarget(self, action: #selector(eyesButtonTapped(_:)), for: .touchUpInside)
    }
}

//MARK: - helpers and handlers
extension IntroScreenViewController {
    @objc private func eyesButtonTapped(_ sender: UIButton) {
        openSearchScreen()
    }
    
    @objc private func heartButtonTapped(_ sender: UIButton) {
        openAuthorizationScreen()
    }
    
    private func openSearchScreen() {
        let searchNavigationController = SearchNavigationController(nibName: nil, bundle: nil)
        searchNavigationController.modalPresentationStyle = .currentContext
        searchNavigationController.modalTransitionStyle = .flipHorizontal
        self.present(searchNavigationController, animated: true, completion: nil)
    }
    
    private func openAuthorizationScreen() {
        let authorizationNavigationController = AuthorizationNavigationController(nibName: nil, bundle: nil)
        authorizationNavigationController.modalPresentationStyle = .currentContext
        authorizationNavigationController.modalTransitionStyle = .flipHorizontal
        self.present(authorizationNavigationController, animated: true, completion: nil)
    }
}
