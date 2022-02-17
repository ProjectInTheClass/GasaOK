//
//  SearchVC.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/15.
//

import UIKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate {

    var searchController: UISearchController = UISearchController()
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDelegate()
        tableViewDataSource()
        searchControllerSetting()
        hotSongScopeBarSetting()

        searchController.delegate = self
        searchController.searchBar.delegate = self
    }
    
    func searchControllerSetting() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "노래 제목이나 가수를 입력해주세요"
        searchController.searchBar.searchBarStyle = .minimal
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    func hotSongScopeBarSetting() {
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["TJ인기차트", "KY인기차트"]
    }
    
    func searchResultScopeBarSetting() {
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["TJ", "KY"]
    }
    
    func tableViewDelegate() {
        searchTableView.delegate = self
    }
    func tableViewDataSource() {
        searchTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            return hotSongDummyTJ.count
        } else {
            return hotSongDummyKY.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchTableViewCell = self.searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            cell.songNameLabel.text = hotSongDummyTJ[indexPath.row].songName
            cell.singerNameLabel.text = hotSongDummyTJ[indexPath.row].singerName
            cell.karaokeNumber.text = hotSongDummyTJ[indexPath.row].karaokeNumber
            return cell
        } else {
            cell.songNameLabel.text = hotSongDummyKY[indexPath.row].songName
            cell.singerNameLabel.text = hotSongDummyKY[indexPath.row].singerName
            cell.karaokeNumber.text = hotSongDummyKY[indexPath.row].karaokeNumber
            return cell
        }
    }
    
    func searchBar(_ searchBar: UISearchBar,
                   selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchTableView.reloadData()
    }

}
