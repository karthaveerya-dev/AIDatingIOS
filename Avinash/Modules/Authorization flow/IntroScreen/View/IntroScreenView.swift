//
//
//
//  IntroScreenView
//	TouristDoc
//

import UIKit
import SnapKit

class IntroScreenView: BaseBackgroundedView {
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
        
        addSubview(heartButton)
        addSubview(eyesButton)
        
        heartButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(52))
            make.bottom.equalTo(SizeHelper.sizeH(-167))
        }
        
        eyesButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(SizeHelper.sizeW(36))
            make.bottom.equalTo(heartButton.snp.top).offset(SizeHelper.sizeH(-129))
        }
    }
}
