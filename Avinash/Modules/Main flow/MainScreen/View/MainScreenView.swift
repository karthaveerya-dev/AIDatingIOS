//
//
//
//  MainScreenView
//	Avinash
//

import UIKit

class MainScreenView: BaseBackgroundedView {
    var isFacebookConnectedToProfile: Bool = false {
        didSet {
            connectFacebookButton.isEnabled = !isFacebookConnectedToProfile
            connectFacebookButton.alpha = (isFacebookConnectedToProfile ? 0.5 : 1 )
            
            faceboolStatusLabel.text = "status".localized() + (isFacebookConnectedToProfile ? "connected".localized() : "not_connected".localized())
        }
    }
    
    var titleLabel: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.ProximaNovaBold(size: 30)
        obj.text = "profile".localized()
        obj.textAlignment = .center
        obj.textColor = .white
        return obj
    }()
    
    var connectFacebookButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.isEnabled = false
        obj.alpha = 0.5
        obj.backgroundColor = .white
        obj.setImage(UIImage(named: "facebookIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        obj.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        let attributedString = NSAttributedString(string: "connect_facebook".localized(),
                                                  attributes: [.foregroundColor: UIColor.black,
                                                               .font: UIFont.ProximaNovaRegular(size: 20) as Any])
        obj.setAttributedTitle(attributedString, for: .normal)
        return obj
    }()
    
    var faceboolStatusLabel: UILabel = {
        let obj = UILabel()
        obj.text = "status".localized()
        return obj
    }()
    
    var settingsButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.backgroundColor = .white
        let attributedString = NSAttributedString(string: "settings".localized(),
                                                  attributes: [.foregroundColor: UIColor.black,
                                                               .font: UIFont.ProximaNovaRegular(size: 20) as Any])
        obj.setAttributedTitle(attributedString, for: .normal)
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
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(connectFacebookButton)
        addSubview(faceboolStatusLabel)
        addSubview(settingsButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(SizeHelper.sizeH(85))
        }
        
        connectFacebookButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(50))
            make.top.equalTo(titleLabel.snp.bottom).offset(SizeHelper.sizeH(30))
            make.height.equalTo(SizeHelper.sizeH(51))
        }
        
        faceboolStatusLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(connectFacebookButton)
            make.top.equalTo(connectFacebookButton.snp.bottom).offset(12)
        }
        
        settingsButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(50))
            make.centerY.equalToSuperview()
            make.height.equalTo(SizeHelper.sizeH(51))
        }
    }
}
