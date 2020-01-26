//
//  CustomCell.swift
//  Reizouko
//
//  Created by 工藤彩名 on 2018/12/01.
//  Copyright © 2018 Kudo Ayana. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    @IBOutlet var foodimg: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var date: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    }

}
