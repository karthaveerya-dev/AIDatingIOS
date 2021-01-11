//
//
//
//  SearchScreenView
//	Avinash
//

import UIKit

class SearchScreenView: UIView {
    var backButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.imageEdgeInsets = UIEdgeInsets(top: -3, left: 0, bottom: 0, right: 0)
        obj.setImage(UIImage(named: "backIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        obj.translatesAutoresizingMaskIntoConstraints = false
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
    }
}
