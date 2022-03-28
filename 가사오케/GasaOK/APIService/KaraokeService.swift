//
//  KaraokeService.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/24.
//

import Foundation

class KaraokeService {
    static let shared = KaraokeService()
    let url = "https://api.manana.kr/karaoke/"

    // 사용하고 있지 않음. 삭제할 것.
    func fetchSongData(songTitle: String, songSinger: String) {
        let session = URLSession.shared
        let title = songTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlSongString = url + "song/" + title + ".json"
        
        guard let requestURL = URL(string: urlSongString) else { return }
        session.dataTask(with: requestURL) { (data, response, error) in
             guard error == nil else { return }
             if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                 do {
                     let songResult = try JSONDecoder().decode(SongInfo2.self, from: data)
                     filteredSong1 = songResult
                     DispatchQueue.main.async {
                     }
                     print(filteredSong1)
                 } catch(let err) {
                     print("Decoding Error")
                     print(err.localizedDescription)
                 }
             }
        }.resume()
    }
    
}
