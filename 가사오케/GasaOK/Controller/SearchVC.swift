//
//  SearchVC.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/15.
//

import UIKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {

    @IBOutlet weak var searchTableView: UITableView!
    
    var searchController: UISearchController = UISearchController()
    var filteredSong: [SongInfo] = []
    var filteredSongOfTJ: [SongInfo] = []
    var filteredSongOfKY: [SongInfo] = []
//    var isSearchBarEmpty: Bool {
//        return searchController.searchBar.text?.isEmpty ?? true
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDelegate()
        tableViewDataSource()
        searchControllerSetUp()
        hotSongScopeBarSetUp()

        searchControllerDelegate()
    }
    
    // MARK: - set up
    func searchControllerSetUp() {
        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "노래 제목이나 가수를 입력해주세요"
        searchController.searchBar.searchBarStyle = .minimal
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    func hotSongScopeBarSetUp() {
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["TJ인기차트", "KY인기차트"]
    }
    func searchResultScopeBarSetUp() {
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["TJ", "KY"]
    }
    
    // MARK: - show up
    func hotSongShowUp() {
        
    }
    func searchResultShowUp() {
        
    }
    
    // MARK: - filtering
    func songFilteredByTitle() -> [SongInfo] {
        let filteredSongByTitle = searchResultDummy.filter({ (song:SongInfo) -> Bool in
            let noBlankTitle = song.songName.lowercased().split(separator: " ")
            let noBlankInputText = searchController.searchBar.text!.lowercased().split(separator: " ")
            return noBlankTitle.reduce("", +).contains(noBlankInputText.reduce("", +))
        })
        return filteredSongByTitle
    }
    
    func songFilteredBySinger() -> [SongInfo] {
        let filteredSongBySinger = searchResultDummy.filter({ (song:SongInfo) -> Bool in
            let noBlankTitle = song.singerName.lowercased().split(separator: " ")
            let noBlankInputText = searchController.searchBar.text!.lowercased().split(separator: " ")
            return noBlankTitle.reduce("", +).contains(noBlankInputText.reduce("", +))
        })
        return filteredSongBySinger
    }
    
    func songSeperatedByKaraokeType() {
        filteredSongOfTJ = filteredSong.filter({ (song:SongInfo) -> Bool in
            return song.karaokeType == KaraokeType.TJ
        })
        filteredSongOfKY = filteredSong.filter({ (song:SongInfo) -> Bool in
            return song.karaokeType == KaraokeType.KY
        })
    }
    
    // MARK: - searchController Delegate func
    func updateSearchResults(for searchController: UISearchController) {
        filteredSong = searchResultDummy.filter({ (song:SongInfo) -> Bool in
            return song.songName.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        print("update Search Result")
        searchTableView.reloadData()
    }
    
    // MARK: - searchBar Delegate func
    func searchBar(_ searchBar: UISearchBar,
                   selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filteredSong = songFilteredByTitle() + songFilteredBySinger()
        print("search Bar Search Button Clicked")
        print(filteredSong)
//        print( songSeperatedByKaraokeType() )
        songSeperatedByKaraokeType()
        searchResultScopeBarSetUp()
        searchTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("search Bar Cancel Button Clicked")
        filteredSong = []
        print(filteredSong.isEmpty)
        hotSongScopeBarSetUp()
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

    // MARK: - tableView Delegate func
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            if filteredSong.isEmpty {
                return hotSongDummyTJ.count
            } else {
                return filteredSongOfTJ.count
            }
        } else {
            if filteredSong.isEmpty {
                return hotSongDummyKY.count
            } else {
                return filteredSongOfKY.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchTableViewCell = self.searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        if filteredSong.isEmpty {
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
            if searchController.searchBar.selectedScopeButtonIndex == 0 {
                cell.songNameLabel.text = filteredSongOfTJ[indexPath.row].songName
                cell.singerNameLabel.text = filteredSongOfTJ[indexPath.row].singerName
                cell.karaokeNumber.text = filteredSongOfTJ[indexPath.row].karaokeNumber
                return cell
            } else {
                cell.songNameLabel.text = filteredSongOfKY[indexPath.row].songName
                cell.singerNameLabel.text = filteredSongOfKY[indexPath.row].singerName
                cell.karaokeNumber.text = filteredSongOfKY[indexPath.row].karaokeNumber
                return cell
            }
        }
    }
    
    // MARK: - Delegate
    func tableViewDelegate() {
        searchTableView.delegate = self
    }
    func searchControllerDelegate() {
        searchController.searchBar.delegate = self
    }
    
    // MARK: - DataSource
    func tableViewDataSource() {
        searchTableView.dataSource = self
    }

   
}
