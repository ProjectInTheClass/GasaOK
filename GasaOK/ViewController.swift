//
//  ViewController.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/12.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    var searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBarSetting()
        searchBarDelegate()
    }

    func searchBarSetting() {
        searchBar.placeholder = "노래 제목이나 가수를 입력해주세요"
        self.navigationItem.titleView = searchBar
    }
    
    func searchBarDelegate() {
        searchBar.delegate = self
    }
    
    
    @IBAction func searchBarDidTapped(_ sender: Any) {
        print("hi")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let searchVC = storyboard.instantiateViewController(withIdentifier: "SearchVC") as UIViewController
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
}
