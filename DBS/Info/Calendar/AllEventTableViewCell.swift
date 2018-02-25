//
//  AllEventTableViewCell.swift
//  DBS
//
//  Created by Anson Ieung on 28/12/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit

class AllEventTableViewCell: UITableViewCell {

    @IBOutlet weak var EventTypeBar: UIView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var dateTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
