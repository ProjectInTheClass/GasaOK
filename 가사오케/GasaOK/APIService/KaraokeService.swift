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

    func fetchSongData(songTitle: String, songSinger: String, completion: @escaping (Result<Any, Error>) -> ()) {
        let title = songTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        let singer = songSinger.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlSongString = url + "song/" + title + ".json"
        print(urlSongString)
        if let url = URL(string: urlSongString) {
            let sesseion = URLSession(configuration: .default)
            let requestURL = URLRequest(url: url)
            let dataTask = sesseion.dataTask(with: requestURL) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    do {
                        let decodedData = try? JSONDecoder().decode(SongInfo2.self, from: safeData)
                        completion(.success(decodedData as Any))
                    }
                }
            }
            dataTask.resume()
        }
    }

    
}
