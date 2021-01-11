//
//
//
//  SearchScreenViewController.swift
//	Avinash
//

import UIKit

class SearchScreenViewController: UIViewController {
    var mainView = SearchScreenView()
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        
        initViewController()
    }
    
    private func initViewController() {
        title = "search".localized()
        
        //close screen navBar button
        let leftBarButton = UIBarButtonItem(customView: mainView.backButton)
        leftBarButton.customView?.snp.updateConstraints({ (make) in
            make.width.equalTo(28)
            make.height.equalTo(18)
        })
        navigationItem.leftBarButtonItem = leftBarButton
        
        mainView.backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
    }
}

//MARK: - helpers and handlers
extension SearchScreenViewController {
    @objc private func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
