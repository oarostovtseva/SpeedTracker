//
//  ResultCell.swift
//  SpeedTracker
//
//  Created by Olena Rostovtseva on 04.06.2020.
//  Copyright © 2020 orost. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {

    @IBOutlet weak var speedResult: UILabel!
    @IBOutlet weak var timeResult: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
