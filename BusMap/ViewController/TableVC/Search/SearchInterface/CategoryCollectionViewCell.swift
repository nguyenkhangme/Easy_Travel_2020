//
//  CategoryCollectionViewCell.swift
//  GoogleLogin
//
//  Created by user on 6/23/20.
//  Copyright © 2020 vinova. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        image.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        // Initialization code
    }

}
