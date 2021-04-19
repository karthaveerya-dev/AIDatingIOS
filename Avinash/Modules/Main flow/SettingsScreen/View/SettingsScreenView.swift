//
//
//
//  SettingsScreenView
//	AIDating
//

import UIKit
import RangeSeekSlider

class SettingsScreenView: BaseBackgroundedView {
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
        obj.text = "settings".localized()
        obj.textAlignment = .center
        obj.textColor = .white
        return obj
    }()
    
    var nameTextField: CustomTextField = {
        let obj = CustomTextField(fieldType: .name)
        return obj
    }()
    
    var locationTextField: CustomTextField = {
        let obj = CustomTextField(fieldType: .location)
        return obj
    }()
    
    var lookingToMeetLabel: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.ProximaNovaRegular(size: 19)
        obj.text = "looking_to_meet".localized()
        obj.textAlignment = .center
        obj.textColor = .white
        return obj
    }()
    
    var maleLabel: LookingForLabel = {
        let obj = LookingForLabel()
        obj.lookingForType = .male
        return obj
    }()
    
    var femaleLabel: LookingForLabel = {
        let obj = LookingForLabel()
        obj.lookingForType = .female
        return obj
    }()
    
    var ageLabel: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.ProximaNovaRegular(size: 19)
        obj.text = "age_between".localized()
        obj.textAlignment = .center
        obj.textColor = .white
        return obj
    }()
    
    var ageRangeSlider: RangeSeekSlider = {
        let obj = RangeSeekSlider()
        obj.minValue = 18
        obj.maxValue = 65
        obj.step = 1
        obj.handleColor = UIColor.white
        obj.handleBorderColor = UIColor.AgeSlider.handleBorderColor
        obj.handleBorderWidth = 1
        obj.selectedHandleDiameterMultiplier = 1.3
        obj.lineHeight = 2.5
        obj.colorBetweenHandles = UIColor.AgeSlider.colorBetweenHandles
        obj.tintColor = UIColor.AgeSlider.colorNotBetweenHandles
        obj.hideLabels = true
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    var distanceLabel: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.ProximaNovaRegular(size: 19)
        obj.text = "search_up_to".localized()
        obj.textAlignment = .center
        obj.textColor = .white
        return obj
    }()
    
    var distanceRangeSlider: RangeSeekSlider = {
        let obj = RangeSeekSlider()
        obj.minValue = 0
        obj.maxValue = 10
        obj.step = 1
        obj.handleColor = UIColor.white
        obj.handleBorderColor = UIColor.AgeSlider.handleBorderColor
        obj.handleBorderWidth = 1
        obj.selectedHandleDiameterMultiplier = 1.3
        obj.lineHeight = 2.5
        obj.colorBetweenHandles = UIColor.AgeSlider.colorBetweenHandles
        obj.tintColor = UIColor.AgeSlider.colorNotBetweenHandles
        obj.hideLabels = true
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
        addSubview(nameTextField)
        addSubview(locationTextField)
        addSubview(lookingToMeetLabel)
        addSubview(maleLabel)
        addSubview(femaleLabel)
        addSubview(ageLabel)
        addSubview(ageRangeSlider)
        addSubview(distanceLabel)
        addSubview(distanceRangeSlider)
        addSubview(nextButton)
        addSubview(termsAndConditionsTextView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(SizeHelper.sizeH(85))
        }
        
        nameTextField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(27))
            make.top.equalTo(titleLabel.snp.bottom).offset(SizeHelper.sizeH(43))
        }
        
        locationTextField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(27))
            make.top.equalTo(nameTextField.snp.bottom).offset(SizeHelper.sizeH(27))
        }
        
        lookingToMeetLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(locationTextField.snp.bottom).offset(26)
        }
        
        maleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().multipliedBy(0.5)
            make.top.equalTo(lookingToMeetLabel.snp.bottom).offset(9)
        }
        
        femaleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().multipliedBy(1.5)
            make.top.equalTo(lookingToMeetLabel.snp.bottom).offset(9)
        }
        
        ageLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(femaleLabel.snp.bottom).offset(SizeHelper.sizeH(42))
        }
        
        ageRangeSlider.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(48))
            make.height.equalTo(20)
            make.top.equalTo(ageLabel.snp.bottom).offset(13)
        }
        
        distanceLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(ageRangeSlider.snp.bottom).offset(SizeHelper.sizeH(25))
        }
        
        distanceRangeSlider.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(48))
            make.height.equalTo(20)
            make.top.equalTo(distanceLabel.snp.bottom).offset(13)
        }
        
        nextButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(27))
            make.top.equalTo(distanceRangeSlider.snp.bottom).offset(SizeHelper.sizeH(41))
            make.height.equalTo(SizeHelper.sizeH(51))
        }
        
        termsAndConditionsTextView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        femaleLabel.lookingForLabelStatus = .selected
        
        //just to update labels first time
        updateAgeTitle(minValue: 18, maxValue: 65)
        updateDistanceTitle(minValue: 0, maxValue: 10)
    }
}

//MARK: - helpers and handlers
extension SettingsScreenView {
    func updateAgeTitle(minValue: CGFloat, maxValue: CGFloat) {
        let ageString = String.init(format: "age_between".localized(), minValue, maxValue)
      
        ageLabel.text = ageString
        
        ageRangeSlider.selectedMinValue = CGFloat(minValue)
        ageRangeSlider.selectedMaxValue = CGFloat(maxValue)
    }
    
    func updateDistanceTitle(minValue: CGFloat, maxValue: CGFloat) {
        let distanceString = String.init(format: "search_up_to".localized(), minValue, maxValue)
      
        distanceLabel.text = distanceString
        
        distanceRangeSlider.selectedMinValue = CGFloat(minValue)
        distanceRangeSlider.selectedMaxValue = CGFloat(maxValue)
    }
}
