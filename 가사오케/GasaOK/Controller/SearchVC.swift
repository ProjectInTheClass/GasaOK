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
//    var filteredSong: [SongInfo] = []
    var filteredSong2: [SongInfoElement] = []
//    var filteredSongOfTJ: [SongInfo] = []
//    var filteredSongOfKY: [SongInfo] = []
    var filteredSongOfTJ2: [SongInfoElement] = []
    var filteredSongOfKY2: [SongInfoElement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDelegate()
        tableViewDataSource()
        searchControllerSetUp()
        hotSongScopeBarSetUp()
        
        searchControllerDelegate()
        barButtonItemTextRemove()
    }
    
    // MARK: - set up
    func searchControllerSetUp() {
        searchController = UISearchController(searchResultsController: nil)
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
        //        filteredSongOfTJ = filteredSong.filter({ (song:SongInfo) -> Bool in
        //            return song.karaokeType == KaraokeType.TJ
        //        })
        //        filteredSongOfKY = filteredSong.filter({ (song:SongInfo) -> Bool in
        //            return song.karaokeType == KaraokeType.KY
        //        })
        filteredSongOfTJ2 = filteredSong2.filter({ (song:SongInfoElement) -> Bool in
            return song.brand.rawValue == "tj"
        })
        filteredSongOfKY2 = filteredSong2.filter({ (song:SongInfoElement) -> Bool in
            return song.brand.rawValue == "kumyoung"
        })
    }
    
    // MARK: - searchController Delegate func
    func updateSearchResults(for searchController: UISearchController) {
//        filteredSong = searchResultDummy.filter({ (song:SongInfo) -> Bool in
//            return song.songName.lowercased().contains(searchController.searchBar.text!.lowercased())
//        })
        print("update Search Result")
//        searchTableView.reloadData()
    }
    
    // MARK: - searchBar Delegate func
    func searchBar(_ searchBar: UISearchBar,
                   selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        filteredSong = songFilteredByTitle() + songFilteredBySinger()
        filteredSong2 = getSearchSongData(title: searchController.searchBar.text!.lowercased(), singer: "10cm", brand: Brand.ky.rawValue)
        print("search Bar Search Button Clicked")
        songSeperatedByKaraokeType()
        searchResultScopeBarSetUp()
//        searchTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("search Bar Cancel Button Clicked")
        filteredSong2 = []
        hotSongScopeBarSetUp()
        searchTableView.reloadData()
    }
    
    // MARK: - tableView Delegate func
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            if filteredSong2.isEmpty {
                return hotSongDummyTJ.count
            } else {
                return filteredSongOfTJ2.count
            }
        } else {
            if filteredSong2.isEmpty {
                return hotSongDummyKY.count
            } else {
                return filteredSongOfKY2.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchTableViewCell = self.searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        if filteredSong2.isEmpty {
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
        } else {
            if searchController.searchBar.selectedScopeButtonIndex == 0 {
                cell.songNameLabel.text = filteredSongOfTJ2[indexPath.row].title
                cell.singerNameLabel.text = filteredSongOfTJ2[indexPath.row].singer
                cell.karaokeNumber.text = filteredSongOfTJ2[indexPath.row].no
                return cell
            } else {
                cell.songNameLabel.text = filteredSongOfKY2[indexPath.row].title
                cell.singerNameLabel.text = filteredSongOfKY2[indexPath.row].singer
                cell.karaokeNumber.text = filteredSongOfKY2[indexPath.row].no
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
    
    // MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "songDetailIdentifier" {
            let songDetailIndexPath = searchTableView.indexPath(for: sender as! UITableViewCell)!
            let VCDestination = segue.destination as! SongInfoDetailVC
            /// 수정해야 함
            VCDestination.songInfoData = hotSongDummyTJ[songDetailIndexPath.row]
        }
    }
    
    func barButtonItemTextRemove() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func getSearchSongData(title: String, singer: String, brand: String) -> [SongInfoElement] {
        var song: [SongInfoElement] = []
        KaraokeService.shared.fetchSongData(songTitle: title, songSinger: singer, brand: brand) { (response) in
            switch response {
            case .success(let lyricsData):
                if let decodedData = lyricsData as? SongInfo2 {
                    song = decodedData
                    DispatchQueue.main.async {
                        self.searchTableView.reloadData()
                    }
                    return
                }
            case .failure(let lyricsData):
                print("fail", lyricsData)
            }
        }
        Thread.sleep(forTimeInterval: 1)
        return song
    }
    
    
}
