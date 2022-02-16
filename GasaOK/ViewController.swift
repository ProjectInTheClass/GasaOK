//
//  ViewController.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/12.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchBar: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setSearchBar()
        setNavigationItems()
        searchBar.delegate = self
    }

    ///검색창 설정
    func setSearchBar() {
        searchBar.layer.cornerRadius = 10
        
        ///여백 추가
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: searchBar.frame.height))
        searchBar.leftView = paddingView
        searchBar.leftViewMode = .always
        
        ///돋보기 이미지 추가
        let image = UIImage(systemName: "magnifyingglass")
        let leftimage = UIImageView()
        leftimage.image = image
        leftimage.tintColor = UIColor.init(red: 255/255, green: 51/255, blue: 102/255, alpha: 1)
        searchBar.leftView = leftimage
        searchBar.leftViewMode = .always
    }

    ///네비게이션 아이템 (통계, 설정 버튼) 생성
    func setNavigationItems() {
        let settings = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingsButtonDidTap))
        self.navigationItem.rightBarButtonItem = settings
        settings.tintColor = UIColor.init(red: 255/255, green: 51/255, blue: 102/255, alpha: 1)
        let statistics = UIBarButtonItem(image: UIImage(systemName: "chart.bar.fill"), style: .plain, target: self, action: nil)
        statistics.tintColor = UIColor.init(red: 255/255, green: 51/255, blue: 102/255, alpha: 1)
        self.navigationItem.rightBarButtonItems = [settings, statistics]
    }
    
    ///설정버튼 액션
    @objc func settingsButtonDidTap() {
        let changeVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController")
        self.navigationController?.pushViewController(changeVC!, animated: true)
    }

    ///searchBar 클릭시 검색화면으로 넘어가는 이벤트... 안 됨... 수정해야 함..
    @IBAction func searchBardidTapped(_ sender: Any) {
//        let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchVC")
//        self.navigationController?.pushViewController(searchVC!, animated: true)
        print("서치바 눌럿슴!")
    }
    
    
}
