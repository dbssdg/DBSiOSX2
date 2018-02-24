//
//  descriptionsTableViewCell.swift
//  DBS
//
//  Created by Ben Lou on 22/12/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit

class descriptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var descriptionText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        background.layer.cornerRadius = background.frame.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
