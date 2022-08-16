//
//  SearchTableViewCell.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/15.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
   
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    @IBOutlet weak var karaokeNumber: UILabel!
    @IBOutlet weak var songAddButton: UIButton!
    
    func setSongData(model: SongInfoElement) {
        self.songNameLabel.text = model.title
        self.singerNameLabel.text = model.singer
        self.karaokeNumber.text = model.no
        if model.brand == Brand.tj {
            self.imageLogo.image = UIImage(named: "tjLogo")
        }
        else if model.brand == Brand.ky{
            self.imageLogo.image = UIImage(named: "kumyoungLogo")
        }
        else{ }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
