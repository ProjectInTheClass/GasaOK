//
//  SearchVC.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/15.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchFilterButton: UIButton!
    @IBOutlet weak var customSearchBar: UISearchBar!
    @IBOutlet weak var searchFilterSegmentedControl: UISegmentedControl!
    @IBOutlet weak var searchTableView: UITableView!
   
    var filteredSongs: [SongInfoElement] = []
    var filteredSongsOfTJ: [SongInfoElement] = []
    var filteredSongsOfKY: [SongInfoElement] = []
    var searchFilterType: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
        customSearchBar.delegate = self
        
        setSearchFilterButton()
    }
    
    // MARK: - View
    func setSearchFilterButton() {
        searchFilterButton.showsMenuAsPrimaryAction = true
        searchFilterButton.menu = UIMenu(children: self.searchFilterMenuActions())
    }
    
    func searchFilterMenuActions() -> [UIMenuElement] {
        let searchAll = UIAction(title: "전체 검색", image: UIImage(systemName: "line.horizontal.3.decrease")) { _ in
            // 전체 검색 함수 호출
            print("전체 검색")
            self.searchFilterType = 0
            self.searchFilterButton.setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .normal)
            self.searchBarSearchButtonClicked(self.customSearchBar)
        }
        
        let searchBySinger = UIAction(title: "가수 검색", image: UIImage(systemName: "person.fill")) { _ in
            // 가수 검색 함수 호출
            print("가수 검색")
            self.searchFilterType = 1
            self.searchFilterButton.setImage(UIImage(systemName: "person.fill"), for: .normal)
            self.searchBarSearchButtonClicked(self.customSearchBar)
        }
        
        let searchByTitle = UIAction(title: "제목 검색", image: UIImage(systemName: "music.note.list")) { _ in
            // 제목 검색 함수 호출
            print("제목 검색")
            self.searchFilterType = 2
            self.searchFilterButton.setImage(UIImage(systemName: "music.note.list"), for: .normal)
            self.searchBarSearchButtonClicked(self.customSearchBar)
        }
        
        return [searchAll, searchBySinger, searchByTitle]
    }

    /// 사용자가 검색한 결과를 노래방 브랜드별로 필터링합니다.
    func songFilterByBrand() {
        filteredSongsOfTJ = filteredSongs.filter({ (song:SongInfoElement) -> Bool in
            return song.brand!.rawValue == "tj"
        })
        filteredSongsOfKY = filteredSongs.filter({ (song:SongInfoElement) -> Bool in
            return song.brand!.rawValue == "kumyoung"
        })
//        filteredSongs = filteredSongsOfTJ + filteredSongsOfKY

        filteredSongs.sort(by: {$0.title < $1.title} )
    }

    /// API에 노래 제목 검색을 요청합니다.
    /// - Parameter title: song title
    func requestSongsFilterByTitle(title: String) {
        let url = "https://api.manana.kr/karaoke/"
        let session = URLSession.shared
        let title = title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlSongString = url + "song/" + title + ".json"
        
        guard let requestURL = URL(string: urlSongString) else { return }
        session.dataTask(with: requestURL) { (data, response, error) in
             guard error == nil else { return }
             if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                 do {
                     let songResult = try JSONDecoder().decode(SongInfo.self, from: data)
                     // 전체 검색이면 filteredSongs에 검색 결과를 '합친다'
                     if self.searchFilterType == 0 {
                         self.filteredSongs += songResult
                     } else {
                         self.filteredSongs = songResult
                     }
                     DispatchQueue.main.async {
                         self.songFilterByBrand()
                         self.searchTableView.reloadData()
                     }
                 } catch(let err) {
                     print("Decoding Error")
                     print(err)
                 }
             }
        }.resume()
    }
    
    /// API에 노래 가수 검색을 요청합니다.
    /// - Parameter title: song title
    func requestSongsFilterBySinger(artistName: String) {
        let url = "https://api.manana.kr/karaoke/"
        let session = URLSession.shared
        let singer = artistName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlSongString = url + "singer/" + singer + ".json"
        
        guard let requestURL = URL(string: urlSongString) else { return }
        session.dataTask(with: requestURL) { (data, response, error) in
             guard error == nil else { return }
             if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                 do {
                     let songResult = try JSONDecoder().decode(SongInfo.self, from: data)
                     // 전체 검색이면 filteredSongs에 검색 결과를 '합친다'
                     if self.searchFilterType == 0 {
                         self.filteredSongs += songResult
                     } else {
                         self.filteredSongs = songResult
                     }
                     DispatchQueue.main.async {
                         self.songFilterByBrand()
                         self.searchTableView.reloadData()
                     }
                 } catch(let err) {
                     print("Decoding Error")
                     print(err)
                 }
             }
        }.resume()
    }
  
    
    @IBAction func scopeBarDidChange(_ sender: Any) {
        self.searchTableView.reloadData()
    }
}



// MARK: - UITableView

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// 어떤 scope(전체, TJ, KY)가 선택되었는지에 따라 table view cell 갯수를 반환합니다.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let searchType = searchController.searchBar.selectedScopeButtonIndex
        let searchType = searchFilterSegmentedControl.selectedSegmentIndex
        switch searchType {
        case 0:
            return filteredSongs.count
        case 1:
            return filteredSongsOfTJ.count
        case 2:
            return filteredSongsOfKY.count
        default:
            print("table view numberOfRowsInSectin: 검색 타입이 정확하지 않습니다.")
            return 0
        }
    }
    
    /// 선택된 scope에 따라 필터링된 노래 데이터를 cell에 넘겨 줍니다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchTableViewCell = self.searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        cell.cellDelegate = self
        
        let searchType = searchFilterSegmentedControl.selectedSegmentIndex
        switch searchType {
        case 0:
            cell.setSongData(model: filteredSongs[indexPath.row])
            return cell
        case 1:
            if filteredSongsOfTJ.count > 0 {
                cell.setSongData(model: filteredSongsOfTJ[indexPath.row])
            } else {
                // FIXME: 0일 경우 검색 결과가 없다는 화면 출력
            }
            return cell
        case 2:
            if filteredSongsOfKY.count > 0 {
                cell.setSongData(model: filteredSongsOfKY[indexPath.row])
            } else {
                // FIXME: 0일 경우 검색 결과가 없다는 화면 출력
            }
            return cell
        default:
            print("table view cellForRow: 검색 타입이 명확하지 않습니다.")
            return UITableViewCell()
        }
    }
    
    /// tableView의 cell이 선택되었을 때, 해당 셀의 노래 가사를 함수를 호출한다.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var songTitle = ""
        var singer = ""
        let searchType = searchFilterSegmentedControl.selectedSegmentIndex
        switch searchType {
        case 0:
            songTitle = filteredSongs[indexPath.row].title
            singer = filteredSongs[indexPath.row].singer
        case 1:
            songTitle = filteredSongsOfTJ[indexPath.row].title
            singer = filteredSongsOfTJ[indexPath.row].singer
        case 2:
            songTitle = filteredSongsOfKY[indexPath.row].title
            singer = filteredSongsOfKY[indexPath.row].singer
        default:
            print("table view didSelectRowAt: 검색 타입이 명확하지 않습니다.")
        }
        AlertManager.shared.lyricsAlert(vc: self, title: songTitle, singer: singer)
    }
    
}


// MARK: - UISearchController, UISearchBar

extension SearchViewController: UISearchBarDelegate {
    
    /// 검색창에서 scope를 바꾸면 해당 데이터로 테이블뷰를 리로드하게 한다.
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchTableView.reloadData()
    }
    
    /// 검색창의 검색 버튼이 눌리면 검색을 시작하게 한다.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setValue("취소", forKey: "cancelButtonText")
        searchBar.setShowsCancelButton(true, animated: true)
        switch searchFilterType {
        case 1:
            requestSongsFilterBySinger(artistName: searchBar.text!.lowercased())
        case 2:
            requestSongsFilterByTitle(title: searchBar.text!.lowercased())
        default:
            print("전체 검색 시작")
            self.filteredSongs = []
            requestSongsFilterBySinger(artistName: searchBar.text!.lowercased())
            requestSongsFilterByTitle(title: searchBar.text!.lowercased())
        }
    }
    
    /// 검색창의 취소 버튼이 눌리면 검색 내용을 초기화한다.
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.searchTextField.text = nil    // 커서도 안보이게 clear 할 수는 없을까
        filteredSongs = []
        filteredSongsOfTJ = []
        filteredSongsOfKY = []
        searchTableView.reloadData()
    }

    // Asks the delegate if editing should stop in the specified search bar.
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        // false로 해줘야 cancel 버튼이 활성화된다.
        return false
    }
}


// MARK: - menuActionDelegate
/// 더보기 메뉴 Action delegate 함수 구현
extension SearchViewController: menuActionDelegate {
    
    /// 노래 추가 버튼을 눌렀을 때 노래를 보관함에 저장합니다.
    /// - Parameter sender: UIButton of SearchTableViewCell
    func addSongButton(sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Song", in: context)
        
        if let entity = entity {
            let mySongList = NSManagedObject(entity: entity, insertInto: context)
            let contentView = sender.superview
            let cell = contentView?.superview?.superview as! UITableViewCell    // 스토리보드 구조가 바뀌어서 superview 하나 더 붙임
            let index = searchTableView.indexPath(for: cell)

            // FIXME: 아래의 반복되는 코드를 어떻게 합칠 수 있을까...
//            let searchType = searchController.searchBar.selectedScopeButtonIndex
            let searchType = searchFilterSegmentedControl.selectedSegmentIndex
            switch searchType {
            case 0:
                mySongList.setValue(filteredSongs[index!.row].title, forKey: "songTitle")
                mySongList.setValue(filteredSongs[index!.row].singer, forKey: "singer")
                mySongList.setValue(filteredSongs[index!.row].no, forKey: "number")
               //예원
                mySongList.setValue(filteredSongs[index!.row].brand?.rawValue, forKey: "brand")
            case 1:
                mySongList.setValue(filteredSongsOfTJ[index!.row].title, forKey: "songTitle")
                mySongList.setValue(filteredSongsOfTJ[index!.row].singer, forKey: "singer")
                mySongList.setValue(filteredSongsOfTJ[index!.row].no, forKey: "number")
                mySongList.setValue(filteredSongsOfTJ[index!.row].brand?.rawValue, forKey: "brand")
            case 2:
                mySongList.setValue(filteredSongsOfKY[index!.row].title, forKey: "songTitle")
                mySongList.setValue(filteredSongsOfKY[index!.row].singer, forKey: "singer")
                mySongList.setValue(filteredSongsOfKY[index!.row].no, forKey: "number")
                mySongList.setValue(filteredSongsOfKY[index!.row].brand?.rawValue, forKey: "brand")
            default:
                print("didTapSongAddButton: 검색 타입이 정확하지 않습니다.")
            }
                
            do {
                try context.save()
                AlertManager.shared.songAddAlert(vc: self)
            } catch {
                Swift.print(error.localizedDescription)
            }
        }
    }
    
    /// 노래 가사 보기 버튼을 눌렀을 때
    /// - Parameter sender: UIButton of SearchTableViewCell
    func showLyricsButton(sender: UIButton) {
        let contentView = sender.superview
        let cell = contentView?.superview?.superview as! UITableViewCell    // 스토리보드 구조가 바뀌어서 superview 하나 더 붙임
        let index = searchTableView.indexPath(for: cell)
        var songTitle = ""
        var singer = ""
        let searchType = searchFilterSegmentedControl.selectedSegmentIndex
        switch searchType {
        case 0:
            songTitle = filteredSongs[index!.row].title
            singer = filteredSongs[index!.row].singer
        case 1:
            songTitle = filteredSongsOfTJ[index!.row].title
            singer = filteredSongsOfTJ[index!.row].singer
        case 2:
            songTitle = filteredSongsOfKY[index!.row].title
            singer = filteredSongsOfKY[index!.row].singer
        default:
            print("table view didSelectRowAt: 검색 타입이 명확하지 않습니다.")
        }
        AlertManager.shared.lyricsAlert(vc: self, title: songTitle, singer: singer)
    }
}
