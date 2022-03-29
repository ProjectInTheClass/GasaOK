//
//  DarkModeTableViewCell.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/20.
//

import UIKit

class DarkModeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var darkModeCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
