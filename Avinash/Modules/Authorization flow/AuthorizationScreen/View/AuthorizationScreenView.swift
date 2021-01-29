//
//
//
//  AuthorizationScreenView
//	Avinash
//

import UIKit

class AuthorizationScreenView: BaseBackgroundedView {
    var authType: AuthorizationType = .signIn {
        didSet {
            if authType == .signUp {
                titleLabel.text = "create_account".localized()
                
                let emailAttributedString = NSAttributedString(string: "sign_up_with_email".localized(),
                                                               attributes: [.foregroundColor: UIColor.black,
                                                                            .font: UIFont.ProximaNovaRegular(size: 20) as Any])
                let googleAttributedString = NSAttributedString(string: "sign_up_with_google".localized(),
                                                                attributes: [.foregroundColor: UIColor.black,
                                                                             .font: UIFont.ProximaNovaRegular(size: 20) as Any])
                let facebookAttributedString = NSAttributedString(string: "sign_up_with_facebook".localized(),
                                                                  attributes: [.foregroundColor: UIColor.black,
                                                                               .font: UIFont.ProximaNovaRegular(size: 20) as Any])
                
                let createAccountAttributedTitle = NSMutableAttributedString(string: "have_an_account".localized() + " ",
                                                                             attributes: [.font: UIFont.ProximaNovaRegular(size: 17) as Any,
                                                                                          .foregroundColor: UIColor.white])
                let createAccountString = NSAttributedString(string: "sign_in".localized(),
                                                             attributes: [.font: UIFont.ProximaNovaBold(size: 18) as Any,
                                                                          .foregroundColor: UIColor.white])
                createAccountAttributedTitle.append(createAccountString)
                
                signInWithEmailButton.setAttributedTitle(emailAttributedString, for: .normal)
                signInWithGoogleButton.setAttributedTitle(googleAttributedString, for: .normal)
                signInWithFacebookButton.setAttributedTitle(facebookAttributedString, for: .normal)
                createAccountButton.setAttributedTitle(createAccountAttributedTitle, for: .normal)
            }
        }
    }
    
    var backButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.imageEdgeInsets = UIEdgeInsets(top: -3, left: 0, bottom: 0, right: 0)
        obj.setImage(UIImage(named: "backIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    var titleLabel: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.ProximaNovaBold(size: 30)
        obj.text = "sign_in".localized()
        obj.textAlignment = .center
        obj.textColor = .white
        return obj
    }()
    
    var signInWithEmailButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.backgroundColor = .white
        obj.setImage(UIImage(named: "mailIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        obj.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        let attributedString = NSAttributedString(string: "sign_in_with_email".localized(),
                                                  attributes: [.foregroundColor: UIColor.black,
                                                               .font: UIFont.ProximaNovaRegular(size: 20) as Any])
        obj.setAttributedTitle(attributedString, for: .normal)
        return obj
    }()
    
    var leftSeparator: UIView = {
        let obj = UIView()
        obj.backgroundColor = .white
        obj.alpha = 0.5
        return obj
    }()
    
    var orLabel: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.ProximaNovaRegular(size: 19)
        obj.text = "or".localized()
        obj.textAlignment = .center
        obj.textColor = .white
        obj.alpha = 0.5
        return obj
    }()
    
    var rightSeparator: UIView = {
        let obj = UIView()
        obj.backgroundColor = .white
        obj.alpha = 0.5
        return obj
    }()
    
    var signInWithGoogleButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.backgroundColor = .white
        obj.setImage(UIImage(named: "googleIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        obj.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        let attributedString = NSAttributedString(string: "sign_in_with_google".localized(),
                                                  attributes: [.foregroundColor: UIColor.black,
                                                               .font: UIFont.ProximaNovaRegular(size: 20) as Any])
        obj.setAttributedTitle(attributedString, for: .normal)
        return obj
    }()
    
    var signInWithFacebookButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.backgroundColor = .white
        obj.setImage(UIImage(named: "facebookIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        obj.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        let attributedString = NSAttributedString(string: "sign_in_with_facebook".localized(),
                                                  attributes: [.foregroundColor: UIColor.black,
                                                               .font: UIFont.ProximaNovaRegular(size: 20) as Any])
        obj.setAttributedTitle(attributedString, for: .normal)
        return obj
    }()
    
    var createAccountButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.backgroundColor = .clear
        
        let attributedTitle = NSMutableAttributedString(string: "new_here".localized() + " ",
                                                        attributes: [.font: UIFont.ProximaNovaRegular(size: 17) as Any,
                                                                     .foregroundColor: UIColor.white])
        let createAccountString = NSAttributedString(string: "create_account".localized(),
                                                     attributes: [.font: UIFont.ProximaNovaBold(size: 18) as Any,
                                                                  .foregroundColor: UIColor.white])
        attributedTitle.append(createAccountString)
        obj.setAttributedTitle(attributedTitle, for: .normal)
        return obj
    }()
    
    var termsAndConditionsTextView: UITextView = {
        let obj = UITextView()
        obj.isScrollEnabled = false
        obj.backgroundColor = .clear
        obj.isEditable = false
        obj.isSelectable = true
        
        let termsAndConditionstAttributedTitle = NSMutableAttributedString(string: "using_services".localized() + "\n",
                                                                           attributes: [.font: UIFont.ProximaNovaRegular(size: 17) as Any,
                                                                                        .foregroundColor: UIColor.white])
        let termsString = NSAttributedString(string: "terms".localized(),
                                             attributes: [.font: UIFont.ProximaNovaBold(size: 16) as Any,
                                                          .foregroundColor: UIColor.white,
                                                          .link: "https://apple.com"])
        let andString = NSAttributedString(string: " " + "and".localized() + " ",
                                           attributes: [.font: UIFont.ProximaNovaRegular(size: 15) as Any,
                                                        .foregroundColor: UIColor.white])
        let privacyStatementString = NSAttributedString(string: "privacy_statement".localized(),
                                                        attributes: [.font: UIFont.ProximaNovaBold(size: 16) as Any,
                                                                     .foregroundColor: UIColor.white,
                                                                     .link: "https://apple.com"])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        termsAndConditionstAttributedTitle.append(termsString)
        termsAndConditionstAttributedTitle.append(andString)
        termsAndConditionstAttributedTitle.append(privacyStatementString)
        
        termsAndConditionstAttributedTitle.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: termsAndConditionstAttributedTitle.length))
        
        obj.linkTextAttributes = [.foregroundColor: UIColor.white]
        obj.attributedText = termsAndConditionstAttributedTitle
        return obj
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(titleLabel)
        addSubview(signInWithEmailButton)
        addSubview(leftSeparator)
        addSubview(rightSeparator)
        addSubview(orLabel)
        addSubview(signInWithGoogleButton)
        addSubview(signInWithFacebookButton)
        addSubview(createAccountButton)
        addSubview(termsAndConditionsTextView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(SizeHelper.sizeH(85))
        }
        
        signInWithEmailButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(50))
            make.top.equalTo(titleLabel.snp.bottom).offset(SizeHelper.sizeH(16))
            make.height.equalTo(SizeHelper.sizeH(51))
        }
        
        leftSeparator.snp.makeConstraints { (make) in
            make.top.equalTo(signInWithEmailButton.snp.bottom).offset(SizeHelper.sizeH(52))
            make.left.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview().multipliedBy(0.45)
        }
        
        rightSeparator.snp.makeConstraints { (make) in
            make.top.equalTo(leftSeparator)
            make.right.equalToSuperview()
            make.height.equalTo(1)
            make.width.equalToSuperview().multipliedBy(0.45)
        }
        
        orLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(leftSeparator)
            make.left.equalTo(leftSeparator.snp.right)
            make.right.equalTo(rightSeparator.snp.left)
        }
        
        signInWithGoogleButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(50))
            make.top.equalTo(leftSeparator.snp.bottom).offset(SizeHelper.sizeH(52))
            make.height.equalTo(SizeHelper.sizeH(51))
        }
        
        signInWithFacebookButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(50))
            make.top.equalTo(signInWithGoogleButton.snp.bottom).offset(SizeHelper.sizeH(34))
            make.height.equalTo(SizeHelper.sizeH(51))
        }
        
        createAccountButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(signInWithFacebookButton.snp.bottom).offset(SizeHelper.sizeH(56))
        }
        
        termsAndConditionsTextView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
