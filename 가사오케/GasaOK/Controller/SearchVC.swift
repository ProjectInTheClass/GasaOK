//
//  SearchVC.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/15.
//

import UIKit
import CoreData

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
   
    
    @IBOutlet weak var searchTableView: UITableView!
    var searchController: UISearchController = UISearchController()
    var filteredSong: [SongInfoElement] = []
    var filteredSongOfTJ: [SongInfoElement] = []
    var filteredSongOfKY: [SongInfoElement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDelegate()
        tableViewDataSource()
        searchControllerSetUp()
//        hotSongScopeBarSetUp()
        searchControllerDelegate()
        barButtonItemTextRemove()
//        fetchSong()
    }
    
    // MARK: - set up
    func searchControllerSetUp() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "노래 제목을 입력해주세요"
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
//    func songFilteredByTitle() -> [SongInfoElement] {
//        let filteredSongByTitle = searchResultDummy.filter({ (song:SongInfoElement) -> Bool in
//            let noBlankTitle = song.songName.lowercased().split(separator: " ")
//            let noBlankInputText = searchController.searchBar.text!.lowercased().split(separator: " ")
//            return noBlankTitle.reduce("", +).contains(noBlankInputText.reduce("", +))
//        })
//        return filteredSongByTitle
//    }
//
//    func songFilteredBySinger() -> [SongInfoElement] {
//        let filteredSongBySinger = searchResultDummy.filter({ (song:SongInfoElement) -> Bool in
//            let noBlankTitle = song.singerName.lowercased().split(separator: " ")
//            let noBlankInputText = searchController.searchBar.text!.lowercased().split(separator: " ")
//            return noBlankTitle.reduce("", +).contains(noBlankInputText.reduce("", +))
//        })
//        return filteredSongBySinger
//    }
    
    func songSeperatedByKaraokeType() {
        filteredSongOfTJ = filteredSong.filter({ (song:SongInfoElement) -> Bool in
            return song.brand!.rawValue == "tj"
        })
        filteredSongOfKY = filteredSong.filter({ (song:SongInfoElement) -> Bool in
            return song.brand!.rawValue == "kumyoung"
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
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.selectedScopeButtonIndex == 0 {
            filteredSong = getSearchSongData(title: searchController.searchBar.text!.lowercased(), singer: "")
        } else {
            filteredSong = getSearchSongData(title: searchController.searchBar.text!.lowercased(), singer: "")
        }
        print("search Bar Search Button Clicked")
        songSeperatedByKaraokeType()
        searchResultScopeBarSetUp()
//        searchTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("search Bar Cancel Button Clicked")
        filteredSong = []
//        hotSongScopeBarSetUp()
        searchTableView.reloadData()
    }
    
    // MARK: - tableView Delegate func
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredSong.isEmpty == false {
            if searchController.searchBar.selectedScopeButtonIndex == 0 {
                return filteredSongOfTJ.count
            } else {
                return filteredSongOfKY.count
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchTableViewCell = self.searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        if filteredSong.isEmpty == false {
            if searchController.searchBar.selectedScopeButtonIndex == 0 {
                cell.songNameLabel.text = filteredSongOfTJ[indexPath.row].title
                cell.singerNameLabel.text = filteredSongOfTJ[indexPath.row].singer
                cell.karaokeNumber.text = filteredSongOfTJ[indexPath.row].no
                return cell
            } else {
                cell.songNameLabel.text = filteredSongOfKY[indexPath.row].title
                cell.singerNameLabel.text = filteredSongOfKY[indexPath.row].singer
                cell.karaokeNumber.text = filteredSongOfKY[indexPath.row].no
                return cell
            }
        } else { return cell }
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
            if searchController.searchBar.selectedScopeButtonIndex == 0 {
                VCDestination.songInfoData = filteredSongOfTJ[songDetailIndexPath.row]
            } else {
                VCDestination.songInfoData = filteredSongOfKY[songDetailIndexPath.row]
            }
        }
    }
    
    func barButtonItemTextRemove() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func getSearchSongData(title: String, singer: String) -> [SongInfoElement] {
        var song: [SongInfoElement] = []
        KaraokeService.shared.fetchSongData(songTitle: title, songSinger: singer) { (response) in
            switch response {
            case .success(let lyricsData):
                if let decodedData = lyricsData as? SongInfo2 {
                    song = decodedData
//                    print(decodedData)
                    DispatchQueue.main.async {
                        self.searchTableView.reloadData()
                    }
                    return
                }
            case .failure(let lyricsData):
                print("fail", lyricsData)
            }
        }
        Thread.sleep(forTimeInterval: 1.5)
        return song
    }
    
    // MARK: - 곡 추가 버튼 누름
    @IBAction func songAddButtonDidTap(_ sender: UIButton) {
        Swift.print("추가 버튼 누름!")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Song", in: context)
        
        if let entity = entity {
            let mySongList = NSManagedObject(entity: entity, insertInto: context)
            let contentView = sender.superview
            let cell = contentView?.superview as! UITableViewCell
            let index = searchTableView.indexPath(for: cell)
            if searchController.searchBar.selectedScopeButtonIndex == 0 {
                mySongList.setValue(filteredSongOfTJ[index!.row].title, forKey: "songTitle")
                mySongList.setValue(filteredSongOfTJ[index!.row].singer, forKey: "singer")
                mySongList.setValue(filteredSongOfTJ[index!.row].no, forKey: "number")
            } else {
                mySongList.setValue(filteredSongOfKY[index!.row].title, forKey: "songTitle")
                mySongList.setValue(filteredSongOfKY[index!.row].singer, forKey: "singer")
                mySongList.setValue(filteredSongOfKY[index!.row].no, forKey: "number")
            }
                
            do {
                try context.save()
                try showAlert()
            } catch {
                Swift.print(error.localizedDescription)
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: nil, message: "보관함에 추가되었습니다.", preferredStyle: .alert)
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        alert.setMessage(color: UIColor(red: 255/255, green: 51/255, blue: 102/255, alpha: 1))
        self.present(alert, animated: false)
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: {_ in alert.dismiss(animated: true, completion: nil)})
    }
}

extension UIAlertController {

    // Set message font and message color
    func setMessage(color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        
        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor: messageColorColor],
                                          range: NSRange(location: 0, length: message.count))
            
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }

}
