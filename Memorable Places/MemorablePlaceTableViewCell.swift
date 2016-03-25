//
//  MemorablePlaceTableViewCell.swift
//  Memorable Places
//
//  Created by E Alan Hill on 3/25/16.
//  Copyright © 2016 619 Fitness. All rights reserved.
//

import UIKit

class MemorablePlaceTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
