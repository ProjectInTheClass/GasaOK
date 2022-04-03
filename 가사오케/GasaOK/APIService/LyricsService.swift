////
////  LyricsService.swift
////  GasaOK
////
////  Created by Da Hae Lee on 2022/02/23.
////
//
//import Foundation
//
//class LyricsService {
//    static let shared = LyricsService()
//
//    let authorization = "Bearer " + GeniusAuthorization.authorization
//    let url = "https://api.genius.com/search?q="
////
//    func fetchLyricsData(songTitle: String, songSinger: String, completion: @escaping (Result<Any, Error>) -> ()) {
//        let title = songTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        let singer = songSinger.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        let urlString = url + title + "%20" + singer
////        print(urlString)
//        if let url = URL(string: urlString) {
//            let sesseion = URLSession(configuration: .default)
//            var requestURL = URLRequest(url: url)
//            requestURL.addValue(authorization, forHTTPHeaderField: "Authorization")
////            print(":hi")
//            let dataTask = sesseion.dataTask(with: requestURL) { (data, response, error) in
//                if error != nil {
//                    print(error!)
//                    return
//                }
//                
//                if let safeData = data {
//                    do {
//                        let decodedData = try? JSONDecoder().decode(LyricsModel.self, from: safeData)
////                        print(decodedData as Any)
//                        completion(.success(decodedData as Any))
//                    }
//                }
//            }
//            dataTask.resume()
//        }
//    }
//    
//}
