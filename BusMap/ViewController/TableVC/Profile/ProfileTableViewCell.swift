//
//  ProfileTableViewCell.swift
//  GoogleLogin
//
//  Created by user on 6/11/20.
//  Copyright © 2020 vinova. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var optionViewModel: OptionViewModel! {
        didSet{
            OptionTitle?.text = optionViewModel.title
            print("")
        }
    }
    @IBOutlet weak var OptionTitle: UILabel!
}
