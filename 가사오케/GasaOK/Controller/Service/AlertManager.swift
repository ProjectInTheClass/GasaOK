//
//  AlertManager.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/08/29.
//

import Foundation
import UIKit
import SafariServices

class AlertManager {
    
    static let shared = AlertManager()
    
    /// 노래 가사를 보기 전 알림창을 띄웁니다.
    /// - Parameter title: song title
    /// - Parameter singer: singer name
    func lyricsAlert(vc: UIViewController, title: String, singer: String) {
        let alert = UIAlertController(title: "가사를 보시겠습니까?", message: "가사 저작권에 의해 앱 내에서 바로 가사를 보여드릴 수 없습니다.\n링크를 통해 가사를 확인하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "이동", style: .default, handler: { _ in
            let baseURL = "https://m.search.naver.com/search.naver?sm=mtp_hty.top&where=m&query="
            var titleArray: [Character] = []
            for char in title{
                if char == "(" { break }
                titleArray.append(char)
            }
            let realTitle = titleArray.map{String($0)}.joined()
            print(realTitle)
            let url = baseURL + realTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "+" + singer.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + "+" + "가사".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let searchURL = URL(string: url)
            UIApplication.shared.open(searchURL!, options: [:])
//            let config = SFSafariViewController.Configuration()
//            config.entersReaderIfAvailable = true
//
//            let safariView = SFSafariViewController(url: searchURL!, configuration: config)
//            safariView.modalPresentationStyle = .pageSheet
//            vc.present(safariView, animated: true)
        }))
        vc.present(alert, animated: false)
    }
    
    /// 노래가 보관함에 추가되었다는 알림창을 띄웁니다.
    func songAddAlert(vc: UIViewController) {
        let alert = UIAlertController(title: nil, message: "보관함에 추가되었습니다.", preferredStyle: .alert)
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        alert.setMessage(color: UIColor(red: 255/255, green: 51/255, blue: 102/255, alpha: 1))
        vc.present(alert, animated: false)
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: {_ in alert.dismiss(animated: true, completion: nil)})
    }
    
}
