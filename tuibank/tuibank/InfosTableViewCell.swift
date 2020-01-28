//
//  InfoTableViewCell.swift
//  tuibank
//
//  Created by Arthur Rodrigues on 08/01/20.
//  Copyright © 2020 Arthur Rodrigues. All rights reserved.
//

import UIKit

class InfosTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
