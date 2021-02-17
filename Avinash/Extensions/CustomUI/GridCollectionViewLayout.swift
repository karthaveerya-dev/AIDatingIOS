//
//  GridCollectionViewLayout.swift
//  Blindee
//
//  Created by Mihail Konoplitskyi on 5/12/19.
//  Copyright © 2019 4K-SOFT. All rights reserved.
//

import Foundation
import UIKit

class GridCollectionViewLayout: UICollectionViewFlowLayout {
    let innerSpace: CGFloat = 10
    let numberOfCellsOnRow: CGFloat = 3
    
    var itemWidth: CGFloat {
        return (collectionView!.frame.size.width/self.numberOfCellsOnRow)-self.innerSpace-5
    }
    
    override init() {
        super.init()
        self.minimumLineSpacing = innerSpace + 5
        self.minimumInteritemSpacing = innerSpace
        self.scrollDirection = .vertical
        self.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width: itemWidth, height: itemWidth)
        }
        get {
            return CGSize(width: itemWidth ,height: itemWidth)
        }
    }
}
