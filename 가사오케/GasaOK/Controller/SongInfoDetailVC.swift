//
//  SongInfoDetailVC.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/16.
//

import UIKit

class SongInfoDetailVC: UIViewController {
    
    var songDetailData : SongInfo!
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    @IBOutlet weak var karaokaNumberLabel: UILabel!
    @IBOutlet weak var lyricsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        songInfodidshow()
    }
    
    func songInfodidshow() {
        songNameLabel.text = songDetailData.songName
        singerNameLabel.text = songDetailData.singerName
        karaokaNumberLabel.text = songDetailData.karaokeNumber
    }

}
