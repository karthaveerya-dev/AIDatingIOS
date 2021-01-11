//
//
//
//  IntroScreenView
//	TouristDoc
//

import UIKit
import SnapKit

class IntroScreenView: UIView {
    var gradientBackgroundView: UIView = {
        let obj = UIView()
        obj.translatesAutoresizingMaskIntoConstraints = false
        return obj
    }()
    
    private var gradientBackgroundViewLayer: CAGradientLayer = {
        let obj = CAGradientLayer()
        obj.colors = [UIColor.MainScreenGradient.startColor.cgColor, UIColor.MainScreenGradient.endColor.cgColor]
        return obj
    }()
    
    var heartButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.setImage(UIImage(named: "heartIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.contentMode = .scaleAspectFill
        return obj
    }()
    
    var eyesButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.setImage(UIImage(named: "eyesIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.contentMode = .scaleAspectFill
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
        
        addSubview(gradientBackgroundView)
        gradientBackgroundView.layer.addSublayer(gradientBackgroundViewLayer)
        
        addSubview(heartButton)
        addSubview(eyesButton)
        
        gradientBackgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        heartButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(52))
            make.bottom.equalTo(SizeHelper.sizeH(-167))
        }
        
        eyesButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(36))
            make.bottom.equalTo(heartButton.snp.top).offset(SizeHelper.sizeH(-129))
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientBackgroundViewLayer.frame = gradientBackgroundView.frame
    }
}
