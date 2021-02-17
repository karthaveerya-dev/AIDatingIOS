//
//  UserPhotoCollectionViewCell.swift
//  Blindee
//
//  Created by Mihail Konoplitskyi on 5/12/19.
//  Copyright © 2019 4K-SOFT. All rights reserved.
//

import Foundation
import UIKit

class UserPhotoCollectionViewCell: UICollectionViewCell, Reusable {
    var state: UserPhotoState = .notSet {
        didSet {
            var backgroundColor: UIColor = .white
            var image = UIImage(named: "removePhotoIcon")?.withRenderingMode(.alwaysTemplate)
            switch state {
            case .set:
                backgroundColor = .white
                image = UIImage(named: "removePhotoIcon")?.withRenderingMode(.alwaysTemplate)
            case .notSet:
                
                backgroundColor = UIColor.white
                image = UIImage(named: "addPhotoIcon")?.withRenderingMode(.alwaysTemplate)
            }
            
            actionButton.setImage(image, for: .normal)
            actionButton.backgroundColor = backgroundColor
        }
    }
    
    var userPhotoImageView: UIImageView = {
        let obj = UIImageView()
        obj.contentMode = .scaleAspectFill
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.layer.cornerRadius = 11
        obj.clipsToBounds = true
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.backgroundColor = .white
        return obj
    }()
    
    var actionButton: UIButton = {
        let obj = UIButton(type: .system)
        obj.tintColor = UIColor.Button.customPurple
        obj.layer.borderWidth = 1
        obj.layer.borderColor = UIColor.Button.customPurple.cgColor
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.setImage(UIImage(named: "removePhotoIcon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        obj.backgroundColor = .white
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
        backgroundColor = .clear
        
        addSubview(userPhotoImageView)
        addSubview(actionButton)
        
        userPhotoImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        actionButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(SizeHelper.sizeW(20))
            make.centerX.equalTo(snp.right).offset(-5)
            make.centerY.equalTo(snp.bottom).offset(-5)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        actionButton.layer.cornerRadius = actionButton.frame.width/2
    }
    
    enum UserPhotoState {
        case set
        case notSet
    }
}
