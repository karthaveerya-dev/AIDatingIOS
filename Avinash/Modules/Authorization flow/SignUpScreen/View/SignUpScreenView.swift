//
//
//
//  SignUpScreenView
//	Avinash
//

import UIKit

class SignUpScreenView: BaseBackgroundedView {
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
        obj.text = "create_account".localized()
        obj.textAlignment = .center
        obj.textColor = .white
        return obj
    }()
    
    var nameTextField: CustomTextField = {
        let obj = CustomTextField(fieldType: .name)
        return obj
    }()
    
    var emailTextField: CustomTextField = {
        let obj = CustomTextField(fieldType: .email)
        return obj
    }()
    
    var passwordTextField: CustomTextField = {
        let obj = CustomTextField(fieldType: .passwordExt)
        return obj
    }()
    
    var signUpButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.backgroundColor = .white
        let attributedString = NSAttributedString(string: "create_account_s".localized(),
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
        addSubview(nameTextField)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(signUpButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(SizeHelper.sizeH(85))
        }
        
        nameTextField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(25))
            make.top.equalTo(titleLabel.snp.bottom).offset(SizeHelper.sizeH(90))
        }
        
        emailTextField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(25))
            make.top.equalTo(nameTextField.snp.bottom).offset(SizeHelper.sizeH(35))
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(25))
            make.top.equalTo(emailTextField.snp.bottom).offset(SizeHelper.sizeH(35))
        }
        
        signUpButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(50))
            make.top.equalTo(passwordTextField.snp.bottom).offset(SizeHelper.sizeH(38))
            make.height.equalTo(SizeHelper.sizeH(51))
        }
    }
}
