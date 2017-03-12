//
//  InstaCell.swift
//  ParseInstagramCP
//
//  Created by Eric Suarez on 3/12/17.
//  Copyright © 2017 Eric Suarez. All rights reserved.
//

import UIKit

class InstaCell: UITableViewCell {
    
    
    @IBOutlet weak var postedImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
