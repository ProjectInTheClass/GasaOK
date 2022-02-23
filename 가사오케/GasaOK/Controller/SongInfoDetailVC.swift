//
//  SongInfoDetailVC.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/16.
//

import UIKit
import SwiftSoup

class SongInfoDetailVC: UIViewController {
    
    var songInfoData: SongInfo!
    var lyricsDataModel: LyricsModel?
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var singerNameLabel: UILabel!
    @IBOutlet weak var karaokaNumberLabel: UILabel!
    @IBOutlet weak var lyricsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        songInfodidshow()
    }
    
    func songInfodidshow() {
        songNameLabel.text = songInfoData.songName
        singerNameLabel.text = songInfoData.singerName
        karaokaNumberLabel.text = songInfoData.karaokeNumber
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLyricsData(title: songInfoData.songName, singer: songInfoData.singerName)
    }

    func getLyricsData(title: String, singer: String) {
        var lyricsPath: String = ""
        LyricsService.shared.fetchLyricsData(songTitle: title, songSinger: singer) { (response) in
            switch response {
            case .success(let lyricsData):
                if let decodedData = lyricsData as? LyricsModel {
                    lyricsPath = String((decodedData.response?.hits[0].result.path)!)
//                    print(lyricsPath)
                    let lyrics = self.lyricsScrap(path: lyricsPath)
                    DispatchQueue.main.async {
                        self.lyricsLabel.text = lyrics
                    }
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
