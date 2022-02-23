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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nav bar 가사 화면 네이비게이션 뒤로가기버튼 설정
        self.navigationController?.navigationBar.topItem?.title = ""
        // 가사 상세 보기화면에서 탭 숨기기
        //  self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
        songNameLabel.text = songDetailData.songName
        singerNameLabel.text = songDetailData.singerName
        karaokaNumberLabel.text = songDetailData.karaokeNumber
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
