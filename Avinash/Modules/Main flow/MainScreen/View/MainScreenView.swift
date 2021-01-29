//
//
//
//  MainScreenView
//	Avinash
//

import UIKit

class MainScreenView: UIView {
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
        
        logOutButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
