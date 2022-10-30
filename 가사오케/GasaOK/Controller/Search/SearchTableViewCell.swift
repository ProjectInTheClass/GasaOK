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
    @IBOutlet weak var moreMenuButton: UIButton!
    
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
        moreMenuButton.menu = UIMenu(title: "", children: menuItems())
        moreMenuButton.showsMenuAsPrimaryAction = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func menuItems() -> [UIMenuElement] {
        let addSongAction = UIAction(title: "보관함에 추가하기", image: UIImage(systemName: "plus")) {_ in
            print("추가 버튼 누름")
        }
        
        let showLyricsAction = UIAction(title: "가사 보기", image: UIImage(systemName: "text.justify.leading")) {_ in
            print("가사 보기 버튼 누름")
        }
        
        return [addSongAction, showLyricsAction]
    }
    
    
}

protocol menuActionDelegate: AnyObject {
    // 위임해줄 기능
    func addSongButton()
}
