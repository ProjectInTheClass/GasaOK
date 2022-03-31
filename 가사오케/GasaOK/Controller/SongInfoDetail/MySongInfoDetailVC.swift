//
//  MySongInfoDetailVC.swift
//  GasaOK
//
//  Created by 김예원 on 2022/02/23.
//

import UIKit

class MySongInfoDetailVC: UIViewController {

    var MySongDetailData : SongInfoElement!
    
    @IBOutlet weak var SongNameLabel: UILabel!
    @IBOutlet weak var singernameLabel: UILabel!
    @IBOutlet weak var karanumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        SongNameLabel.text = MySongDetailData.title
        singernameLabel.text = MySongDetailData.singer
        karanumberLabel.text = MySongDetailData.no
        
    }
    
}
