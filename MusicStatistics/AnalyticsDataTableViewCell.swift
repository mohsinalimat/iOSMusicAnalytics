//
//  AnalyticsDataTableViewCell.swift
//  MusicStatistics
//
//  Created by Jing Wei Li on 1/16/18.
//  Copyright © 2018 Jing Wei Li. All rights reserved.
//

import UIKit
import MediaPlayer

class AnalyticsDataTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptor: UILabel!
    @IBOutlet weak var descriptorInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateData(with title:String, and data:String){
        descriptor.text = title
        descriptorInfo.text = data
    }

}
