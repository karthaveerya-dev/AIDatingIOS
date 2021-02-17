//
//  LookingForLabel.swift
//  Blindee
//
//  Created by Mihail Konoplitskyi on 4/7/19.
//  Copyright © 2019 4K-SOFT. All rights reserved.
//

import Foundation
import UIKit

protocol LookingForLabelDelegate: class {
    func didTappedLookingForLabel(label: LookingForLabel)
}

class LookingForLabel: UILabel {
    weak var delegate: LookingForLabelDelegate?
    
    var lookingForLabelStatus: LookingForLabelStatus  = .unselected {
        didSet {
            handleTextColor()
        }
    }
    
    var lookingForType: LookingForType = .male {
        didSet {
            text = lookingForType.lookingForText
        }
    }
    
    private let underlineView: UIView = {
        let obj = UIView()
        obj.backgroundColor = .white
        obj.isHidden = true
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .didTapLookingForLabel, object: nil)
    }
    
    private func setup() {
        addSubview(underlineView)
        
        underlineView.snp.makeConstraints { (make) in
            make.top.equalTo(snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(1.2)
            make.height.equalTo(2)
        }
        
        isUserInteractionEnabled = true
        textAlignment = .center
        font = UIFont.ProximaNovaRegular(size: 19)
        textColor = UIColor.white.withAlphaComponent(0.5)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleSelfExclusiveLabels),
            name: .didTapLookingForLabel,
            object: nil)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        addGestureRecognizer(gestureRecognizer)
    }
}

extension LookingForLabel {
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? LookingForLabel else {
            return
        }
        
        if label.lookingForLabelStatus == .unselected {
            label.lookingForLabelStatus = .selected
        }
        
        delegate?.didTappedLookingForLabel(label: self)

        //handle indicators
        NotificationCenter.default.post(name: .didTapLookingForLabel, object: label)
    }
    
    @objc func handleSelfExclusiveLabels(notification: NSNotification) {
        if let obj = notification.object as? LookingForLabel {
            if obj == self {
                return
            }
            
            lookingForLabelStatus = .unselected
        }
    }
    
    private func handleTextColor() {
        textColor = (lookingForLabelStatus == .selected ? UIColor.white : UIColor.white.withAlphaComponent(0.5))
        underlineView.isHidden = !(lookingForLabelStatus == .selected)
        
        //font = (lookingForLabelStatus == .selected ? UIFont.SFUITextBold(size: 24) : UIFont.SFUITextRegular(size: 25))
    }
}

enum LookingForLabelStatus: Int {
    case selected
    case unselected
}

@objc enum LookingForType: Int, Codable {
    case male = 0
    case female = 1
    
    var lookingForText: String {
        switch self {
        case .male:
            return "male".localized()
        case .female:
            return "female".localized()
        }
    }
}

