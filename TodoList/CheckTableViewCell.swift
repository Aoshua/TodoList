//
//  CheckTableViewCell.swift
//  TodoList
//
//  Created by Joshua Abbott on 6/30/20.
//  Copyright © 2020 Joshua Abbott. All rights reserved.
//

import UIKit

class CheckTableViewCell: UITableViewCell {


    @IBOutlet weak var btnCheck: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
