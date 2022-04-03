////
////  LyricsModel.swift
////  GasaOK
////
////  Created by Da Hae Lee on 2022/02/23.
////
//
//// This file was generated from JSON Schema using quicktype, do not modify it directly.
//// To parse the JSON, add this file to your project and do:
////
////   let lryicsModel = try? newJSONDecoder().decode(LryicsModel.self, from: jsonData)
//
//import Foundation
//
//// MARK: - LyricsModel
//struct LyricsModel: Codable {
//    let meta: Meta?
//    let response: Response?
//}
//
//// MARK: - Meta
//struct Meta: Codable {
//    let status: Int
//}
//
//// MARK: - Response
//struct Response: Codable {
//    let hits: [Hit]
//}
//
//// MARK: - Hit
//struct Hit: Codable {
//    let result: SongResult
//}
//
//// MARK: - Result
//struct SongResult: Codable {
//    let artistNames, path, title: String
//
//    enum CodingKeys: String, CodingKey {
//        case artistNames = "artist_names"
//        case path, title
//    }
//}
