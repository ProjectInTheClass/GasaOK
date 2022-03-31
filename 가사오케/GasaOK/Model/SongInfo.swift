//
//  SongInfo.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/15.
//

import Foundation

struct SongInfoElement: Codable {
    let brand: Brand?
    let no, title, singer: String
}

enum Brand: String, Codable {
    case tj = "tj"
    case ky = "kumyoung"
    case dam = "dam"
    case joysound = "joysound"
    case uga = "uga"
}

typealias SongInfo = [SongInfoElement]
