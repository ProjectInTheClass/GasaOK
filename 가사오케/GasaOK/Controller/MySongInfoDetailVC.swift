//
//  MySongInfoDetailVC.swift
//  GasaOK
//
//  Created by 김예원 on 2022/02/23.
//

import UIKit

class MySongInfoDetailVC: UIViewController {

    var MySongDetailData : SongInfo!
    
    @IBOutlet weak var SongNameLabel: UILabel!
    @IBOutlet weak var singernameLabel: UILabel!
    @IBOutlet weak var karanumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nav bar 가사 화면 네이비게이션 뒤로가기버튼 설정
        self.navigationController?.navigationBar.topItem?.title = ""
        // Do any additional setup after loading the view.
        
        SongNameLabel.text = MySongDetailData.songName
        singernameLabel.text = MySongDetailData.singerName
        karanumberLabel.text = MySongDetailData.karaokeNumber
    }
    
}
