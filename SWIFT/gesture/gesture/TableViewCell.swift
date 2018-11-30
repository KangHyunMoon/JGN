//
//  TableViewCell.swift
//  gesture
//
//  Created by KangHyunMoon on 2018. 4. 15..
//  Copyright © 2018년 KangHyunMoon. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell{
   
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var cellView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        btn.setTitle("Hi!", for: UIControlState.normal)
        
        print(12345)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
