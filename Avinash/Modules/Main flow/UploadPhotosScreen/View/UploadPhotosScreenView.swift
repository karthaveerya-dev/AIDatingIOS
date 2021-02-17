//
//
//
//  UploadPhotosScreenView
//	AIDating
//

import UIKit

class UploadPhotosScreenView: BaseBackgroundedView {
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
        obj.text = "upload_photos".localized()
        obj.textAlignment = .center
        obj.textColor = .white
        return obj
    }()
    
    var userPhotosCollectionView: UICollectionView = {
        let flowLayout = GridCollectionViewLayout()
        let obj = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        obj.backgroundColor = UIColor.clear
        obj.translatesAutoresizingMaskIntoConstraints = false
        
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
        addSubview(userPhotosCollectionView)
        addSubview(nextButton)
        addSubview(termsAndConditionsTextView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(SizeHelper.sizeH(85))
        }
        
        userPhotosCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(26))
            make.top.equalTo(titleLabel.snp.bottom).offset(SizeHelper.sizeH(38))
            make.height.equalTo(SizeHelper.sizeW(336))
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(27))
            make.top.equalTo(userPhotosCollectionView.snp.bottom).offset(SizeHelper.sizeH(41))
            make.height.equalTo(SizeHelper.sizeH(51))
        }
        
        termsAndConditionsTextView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
}
