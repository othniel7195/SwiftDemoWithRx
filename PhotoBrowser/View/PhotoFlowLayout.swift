//
//  PhotoFlowLayout.swift
//  PhotoBrowser
//
//  Created by zf on 2019/2/3.
//  Copyright © 2019 zf. All rights reserved.
//

import UIKit

class PhotoFlowLayout: UICollectionViewFlowLayout{
    
    let margin: CGFloat = 6.0
    let rowCount: CGFloat = 3.0
    var width: CGFloat {
        return  (kScrennWidth - (rowCount + 1) * margin) / rowCount
    }

    override func prepare() {
        dPrint(item: "perpare")
        itemSize = CGSize(width: width, height: 200)
        minimumInteritemSpacing = margin
        minimumLineSpacing = margin
        sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
    
}

