//
//  videoTableViewCell.swift
//  DBS
//
//  Created by SDG on 18/1/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit

class videoTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    
    @IBOutlet weak var videoTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
