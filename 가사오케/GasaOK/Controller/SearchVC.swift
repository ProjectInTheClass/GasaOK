//
//  SearchVC.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/15.
//

import UIKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var searchTableView: UITableView!
    
    private let isSearchBarButtonClicked: Bool = false
    private let isSearchBarCancelButtonClicked: Bool = false
    var searchController: UISearchController = UISearchController()
    var fileterdSong: [SongInfo] = []
//    var isSearchBarEmpty: Bool {
//        return searchController.searchBar.text?.isEmpty ?? true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDelegate()
        tableViewDataSource()
        searchControllerSetting()
        hotSongScopeBarSetting()

        searchControllerDelegate()
    }
    
    func searchControllerSetting() {
        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
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
    
    func hotSongShowUp() {
        
    }
    func searchResultShowUp() {
        
    }
    
    func searchBar(_ searchBar: UISearchBar,
                   selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchTableView.reloadData()
    }
    func updateSearchResults(for searchController: UISearchController) {
        fileterdSong = searchResultDummy.filter({ (song:SongInfo) -> Bool in
            return song.songName.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        print("update Search Result")
        searchTableView.reloadData()
    }
    
    // MARK: searchBar Delegate func
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let isSearchBarButtonClicked: Bool = true
        fileterdSong = searchResultDummy.filter({ (song:SongInfo) -> Bool in
            let noBlankTitle = song.songName.lowercased().split(separator: " ")
            let noBlankInputText = searchController.searchBar.text!.lowercased().split(separator: " ")
            return noBlankTitle.reduce("", +).contains(noBlankInputText.reduce("", +))
        })
        print("search Bar Search Button Clicked")
        print(fileterdSong)

        searchResultScopeBarSetting()
        searchTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        let isSearchBarCancelButtonClicked: Bool = true
        print("search Bar Cancel Button Clicked")
        fileterdSong = []
        print(fileterdSong.isEmpty)
        hotSongScopeBarSetting()
        searchTableView.reloadData()
    }
    
//    func fileterdSongSeperatedKaraokeType(type: KaraokeType) -> [SongInfo] {
//        if type == .TJ {
//            var fileterdSongOfTJ: [SongInfo] = []
//            for song in fileterdSong {
//                fileterdSongOfTJ.append(song)
//            }
//            return fileterdSongOfTJ
//        } else if type == .KY {
//            var fileterdSongOfKY: [SongInfo] = []
//            for song in fileterdSong {
//                fileterdSongOfKY.append(song)
//            }
//            return fileterdSongOfKY
//        }
//        return 0
//    }

    // MARK: tableView Delegate func
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            if fileterdSong.isEmpty {
                return hotSongDummyTJ.count
            } else {
                return 0
            }
        } else {
            if fileterdSong.isEmpty {
                return hotSongDummyKY.count
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchTableViewCell = self.searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        if fileterdSong.isEmpty {
            if searchController.searchBar.selectedScopeButtonIndex == 0 {
                cell.songNameLabel.text = hotSongDummyTJ[indexPath.row].songName
                cell.songNameLabel.sizeToFit()
                cell.singerNameLabel.text = hotSongDummyTJ[indexPath.row].singerName
                cell.singerNameLabel.sizeToFit()
                cell.karaokeNumber.text = hotSongDummyTJ[indexPath.row].karaokeNumber
                cell.karaokeNumber.sizeToFit()
                return cell
            } else {
                cell.songNameLabel.text = hotSongDummyKY[indexPath.row].songName
                cell.songNameLabel.sizeToFit()
                cell.singerNameLabel.text = hotSongDummyKY[indexPath.row].singerName
                cell.singerNameLabel.sizeToFit()
                cell.karaokeNumber.text = hotSongDummyKY[indexPath.row].karaokeNumber
                cell.karaokeNumber.sizeToFit()
                return cell
            }
        } else {
            if searchController.searchBar.selectedScopeButtonIndex == 0 && fileterdSong[indexPath.row].karaokeType == .TJ {
                cell.songNameLabel.text = fileterdSong[indexPath.row].songName
                cell.singerNameLabel.text = fileterdSong[indexPath.row].singerName
                cell.karaokeNumber.text = fileterdSong[indexPath.row].karaokeNumber
                return cell
            } else if searchController.searchBar.selectedScopeButtonIndex == 0 && fileterdSong[indexPath.row].karaokeType == .KY {
                cell.songNameLabel.text = fileterdSong[indexPath.row].songName
                cell.singerNameLabel.text = fileterdSong[indexPath.row].singerName
                cell.karaokeNumber.text = fileterdSong[indexPath.row].karaokeNumber
                return cell
            }
        }
        return cell
    }
    
    // MARK: Delegate
    func tableViewDelegate() {
        searchTableView.delegate = self
    }
    func searchControllerDelegate() {
        searchController.searchBar.delegate = self
    }
    // MARK: DataSource
    func tableViewDataSource() {
        searchTableView.dataSource = self
    }

   
}
