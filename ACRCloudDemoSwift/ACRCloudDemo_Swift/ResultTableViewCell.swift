//
//  ResultTableViewCell.swift
//  ACRCloudDemo_Swift
//
//  Created by Aprcot on 1/20/19.
//  Copyright © 2019 olym.yin. All rights reserved.
//

import UIKit

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var event_image: UIImageView!
    
    @IBOutlet weak var event_name: UILabel!
    
    
    @IBOutlet weak var event_date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    

}
