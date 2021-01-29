//
//
//
//  EnterEmailScreenView
//	Avinash
//

import UIKit

class EnterEmailScreenView: BaseBackgroundedView {
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
        obj.text = "welcome_back".localized()
        obj.textAlignment = .center
        obj.textColor = .white
        return obj
    }()
    
    var descriptionLabel: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.ProximaNovaRegular(size: 14)
        obj.text = "enter_email_to_sign_in".localized()
        obj.numberOfLines = 0
        obj.textAlignment = .center
        obj.textColor = .white
        return obj
    }()
    
    var emailTextField: CustomTextField = {
        let obj = CustomTextField(fieldType: .email)
        return obj
    }()
    
    var nextButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.backgroundColor = .white
        let attributedString = NSAttributedString(string: "next".localized(),
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
        addSubview(emailTextField)
        addSubview(nextButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(SizeHelper.sizeH(85))
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.left.right.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(25))
            make.top.equalTo(descriptionLabel.snp.bottom).offset(SizeHelper.sizeH(73))
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(50))
            make.top.equalTo(emailTextField.snp.bottom).offset(SizeHelper.sizeH(38))
            make.height.equalTo(SizeHelper.sizeH(51))
        }
    }
}
