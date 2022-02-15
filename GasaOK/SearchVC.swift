//
//  SearchVC.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/15.
//

import UIKit

class SearchVC: UIViewController{
    
    var searchController: UISearchController = UISearchController()
    @IBOutlet weak var resultVC: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchControllerSetting()
        // Do any additional setup after loading the view.
        
    }
    
    func searchControllerSetting() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "노래 제목이나 가수를 입력해주세요"
        searchController.searchBar.scopeButtonTitles = [
            "TJ 인기차트", "KY 인기차트"
        ]
        self.navigationItem.searchController = searchController
    }
    
    func hotSongScopeBarSetting() {
        searchController.searchBar.scopeButtonTitles = [
            "TJ 인기차트", "KY 인기차트"
        ]
    }
    
    func TJorKYScopeBarSetting() {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
