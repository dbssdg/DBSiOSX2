//
//  albumCollectionViewCell.swift
//  DBS
//
//  Created by SDG on 18/1/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit

class albumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var albumDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        image.layer.cornerRadius = image.frame.height/16
    }
}
