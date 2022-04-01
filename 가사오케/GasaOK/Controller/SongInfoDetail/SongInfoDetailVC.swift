//
//  SongInfoDetailVC.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/16.
//

import UIKit
import SwiftSoup

class SongInfoDetailVC: UIViewController {

    var songInfoData: SongInfoElement!
    var lyricsDataModel: LyricsModel?
    @IBOutlet weak var brandLogo: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    @IBOutlet weak var karaokaNumberLabel: UILabel!
    @IBOutlet weak var lyricsLabel: UILabel!
    
    
    let backbutton = UIBarButtonItem()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lyricssetting()
        songInfodidshow()
        
        navigationItem.largeTitleDisplayMode = .never

    }
    
    func songInfodidshow() {
        songNameLabel.text = songInfoData.title
        singerNameLabel.text = songInfoData.singer
        karaokaNumberLabel.text = songInfoData.no
        brandLogo.image = UIImage(named : songInfoData.brand!.rawValue+"Logo")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLyricsData(title: songInfoData.title, singer: songInfoData.singer)
    }
    func lyricssetting(){
        
        let attrString = NSMutableAttributedString(string: lyricsLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        lyricsLabel.attributedText = attrString
    }
    func getLyricsData(title: String, singer: String) {
        var lyricsPath: String = ""
        LyricsService.shared.fetchLyricsData(songTitle: title, songSinger: singer) { (response) in
            switch response {
            case .success(let lyricsData):
                if let decodedData = lyricsData as? LyricsModel {
//                    print(decodedData)
                    if let bool = decodedData.response?.hits.isEmpty {
                        if bool {
                            DispatchQueue.main.sync {
                                self.lyricsLabel.text = "노래 가사가 없습니다..."
                            }
                        } else {
                            lyricsPath = String((decodedData.response?.hits[0].result.path)!)
                            let lyrics = self.lyricsScrap(path: lyricsPath)
                            DispatchQueue.main.sync {
                                self.lyricsLabel.text = lyrics
                            }
                        }
                        
                    }
//                    print(lyricsPath)
                    
                    return 
                }
            case .failure(let lyricsData):
                print("fail", lyricsData)
            }
        }
    }
    
    func lyricsScrap(path: String) -> String {
        var lyrics: String = ""
        do {
            let url = URL(string: "https://genius.com" + path)!
            let html = try String(contentsOf: url, encoding: .utf8)
            let doc: Document = try SwiftSoup.parse(html)
            lyrics = try doc.select("div.Lyrics__Container-sc-1ynbvzw-6").text()
//            print(lyrics)
        } catch {
            print("error!")
        }
        return lyrics
    }
}
