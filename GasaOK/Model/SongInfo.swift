//
//  SongInfo.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/15.
//

import Foundation

struct SongInfo {
    let songName:String
    let singerName:String
    let karaokeNumber:String
    let lryics:String?
    let karaokeType:KaraokeType?
}

enum KaraokeType: String {
    case TJ = "TJ"
    case KY = "KY"
}
