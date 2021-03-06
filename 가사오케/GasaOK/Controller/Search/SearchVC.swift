//
//  SearchVC.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/15.
//

import UIKit
import CoreData

class SearchVC: UIViewController {
    
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
       
        searchControllerDelegate()
        barButtonItemTextRemove()
       
    }
    

    // MARK: - set up
    // search Controller 생성
    func searchControllerSetUp() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "노래 제목을 입력해주세요"
        searchController.searchBar.searchBarStyle = .minimal
        navigationItem.searchController = searchController
        definesPresentationContext = false
        searchResultScopeBarSetUp()
    }
    
    //scope Bar 생성
    func searchResultScopeBarSetUp() {
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["전체보기", "TJ", "KY"]
    }
    
    // MARK: - song filter by brand
    func songSeperatedByBrand() {
        filteredSongOfTJ = filteredSong.filter({ (song:SongInfoElement) -> Bool in
            return song.brand!.rawValue == "tj"
        })
        filteredSongOfKY = filteredSong.filter({ (song:SongInfoElement) -> Bool in
            return song.brand!.rawValue == "kumyoung"
        })
        filteredSong = filteredSongOfTJ + filteredSongOfKY
        filteredSong.sort(by: {$0.title < $1.title} )
    }
    
    // MARK: - func
    func barButtonItemTextRemove() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }

    
    func fetchSongDataByTitle(songTitle: String) {
        let url = "https://api.manana.kr/karaoke/"
        let session = URLSession.shared
        let title = songTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        print(title)
        let urlSongString = url + "song/" + title + ".json"
        
        guard let requestURL = URL(string: urlSongString) else { return }
        session.dataTask(with: requestURL) { (data, response, error) in
             guard error == nil else { return }
             if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                 do {
                     let songResult = try JSONDecoder().decode(SongInfo.self, from: data)
                     self.filteredSong = songResult
                     DispatchQueue.main.async {
                         self.songSeperatedByBrand()
                         self.searchTableView.reloadData()
                     }
                 } catch(let err) {
                     print("Decoding Error")
                     print(err)
                 }
             }
        }.resume()
    }
    
    
    // MARK: - 곡 추가 버튼 누름
    @IBAction func songAddButtonDidTap(_ sender: UIButton) {
//        Swift.print("추가 버튼 누름!")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Song", in: context)
        
        if let entity = entity {
            let mySongList = NSManagedObject(entity: entity, insertInto: context)
            let contentView = sender.superview
            let cell = contentView?.superview as! UITableViewCell
            let index = searchTableView.indexPath(for: cell)
            if searchController.searchBar.selectedScopeButtonIndex == 0 {
                mySongList.setValue(filteredSong[index!.row].title, forKey: "songTitle")
                mySongList.setValue(filteredSong[index!.row].singer, forKey: "singer")
                mySongList.setValue(filteredSong[index!.row].no, forKey: "number")
                mySongList.setValue(filteredSong[index!.row].brand?.rawValue, forKey: "brand")
                
            } else if searchController.searchBar.selectedScopeButtonIndex == 1 {
                mySongList.setValue(filteredSongOfTJ[index!.row].title, forKey: "songTitle")
                mySongList.setValue(filteredSongOfTJ[index!.row].singer, forKey: "singer")
                mySongList.setValue(filteredSongOfTJ[index!.row].no, forKey: "number")
                mySongList.setValue(filteredSongOfTJ[index!.row].brand?.rawValue, forKey: "brand")
            } else {
                mySongList.setValue(filteredSongOfKY[index!.row].title, forKey: "songTitle")
                mySongList.setValue(filteredSongOfKY[index!.row].singer, forKey: "singer")
                mySongList.setValue(filteredSongOfKY[index!.row].no, forKey: "number")
                mySongList.setValue(filteredSongOfKY[index!.row].brand?.rawValue, forKey: "brand")                            
            }
                
            do {
                try context.save()
                showAlert()
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

// MARK: - UITableView extension
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK:  tableView Delegate func
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            return filteredSong.count
        } else if searchController.searchBar.selectedScopeButtonIndex == 1 {
            return filteredSongOfTJ.count
        } else {
            return filteredSongOfKY.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchTableViewCell = self.searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            cell.setSongData(model: filteredSong[indexPath.row])
            return cell
        } else if searchController.searchBar.selectedScopeButtonIndex == 1 {
            cell.setSongData(model: filteredSongOfTJ[indexPath.row])
        
            return cell
        } else {
            cell.setSongData(model: filteredSongOfKY[indexPath.row])
           // cell.brandImage.image = UIImage(named: "KG_logo")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var songTitle = ""
        var singer = ""
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            songTitle = filteredSong[indexPath.row].title
            singer = filteredSong[indexPath.row].singer
        } else if searchController.searchBar.selectedScopeButtonIndex == 1 {
            songTitle = filteredSongOfTJ[indexPath.row].title
            singer = filteredSongOfTJ[indexPath.row].singer
        } else {
            songTitle = filteredSongOfKY[indexPath.row].title
            singer = filteredSongOfKY[indexPath.row].singer
        }
        showLyricsAlert(title: songTitle, singer: singer)
    }
    
    // MARK:  DataSource, DataSource
    func tableViewDataSource() {
        searchTableView.dataSource = self
    }
    func tableViewDelegate() {
        searchTableView.delegate = self
    }
    
    func showLyricsAlert(title: String, singer: String) {
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
        }))
        self.present(alert, animated: false)
    }
    
}

// MARK: - UISearchController, UISearchBar extension
extension SearchVC: UISearchControllerDelegate, UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchSongDataByTitle(songTitle: searchController.searchBar.text!.lowercased())
//        fetchSongDataBySinger(songSinger: searchController.searchBar.text!.lowercased())
        print("search Bar Search Button Clicked")
        searchResultScopeBarSetUp()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("search Bar Cancel Button Clicked")
        filteredSong = []
        filteredSongOfTJ = []
        filteredSongOfKY = []
        searchTableView.reloadData()
    }
    
    
    func searchControllerDelegate() {
        searchController.searchBar.delegate = self
    }



}
