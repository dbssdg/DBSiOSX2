//
//  badgeTableViewCell.swift
//  DBS
//
//  Created by SDG on 20/11/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit

class badgeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var elementImage: UIImageView!
    @IBOutlet weak var elementTitle: UILabel!
    @IBOutlet weak var elementDescription: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        customView.layer.cornerRadius = 30
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
