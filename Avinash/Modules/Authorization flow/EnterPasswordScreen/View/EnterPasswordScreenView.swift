//
//
//
//  EnterPasswordScreenView
//	Avinash
//

import UIKit

class EnterPasswordScreenView: BaseBackgroundedView {
    var email: String = "" {
        didSet {
            descriptionLabel.text = "enter_password_to_sign_in_with".localized() + "\r\n" + email
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
        obj.text = "almost_there".localized()
        obj.textAlignment = .center
        obj.textColor = .white
        return obj
    }()
    
    var descriptionLabel: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.ProximaNovaRegular(size: 14)
        obj.text = "enter_password_to_sign_in_with".localized()
        obj.numberOfLines = 0
        obj.textAlignment = .center
        obj.textColor = .white
        return obj
    }()
    
    var passwordTextField: CustomTextField = {
        let obj = CustomTextField(fieldType: .password)
        return obj
    }()
    
    var signInButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.backgroundColor = .white
        let attributedString = NSAttributedString(string: "sign_in".localized(),
                                                  attributes: [.foregroundColor: UIColor.black,
                                                               .font: UIFont.ProximaNovaBold(size: 16) as Any])
        obj.setAttributedTitle(attributedString, for: .normal)
        obj.alpha = 0.5
        obj.isEnabled = false
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
        addSubview(descriptionLabel)
        addSubview(passwordTextField)
        addSubview(signInButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(SizeHelper.sizeH(85))
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.left.right.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(25))
            make.top.equalTo(descriptionLabel.snp.bottom).offset(SizeHelper.sizeH(73))
        }
        
        signInButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(50))
            make.top.equalTo(passwordTextField.snp.bottom).offset(SizeHelper.sizeH(38))
            make.height.equalTo(SizeHelper.sizeH(51))
        }
    }
}
