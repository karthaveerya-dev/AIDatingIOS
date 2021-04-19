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
            connectFacebookButton.isHidden = isFacebookConnectedToProfile
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
        obj.isHidden = true
        obj.backgroundColor = .white
        obj.setImage(UIImage(named: "facebookIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        obj.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        let attributedString = NSAttributedString(string: "connect_facebook".localized(),
                                                  attributes: [.foregroundColor: UIColor.black,
                                                               .font: UIFont.ProximaNovaRegular(size: 20) as Any])
        obj.setAttributedTitle(attributedString, for: .normal)
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
    
    var logOutButton: UIButton = {
        var obj = UIButton(type: .system)
        obj.setTitle("Log out", for: .normal)
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
        
        addSubview(logOutButton)
        addSubview(titleLabel)
        addSubview(connectFacebookButton)
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
        
        settingsButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(50))
            make.centerY.equalToSuperview()
            make.height.equalTo(SizeHelper.sizeH(51))
        }
        
        logOutButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
        }
    }
}
