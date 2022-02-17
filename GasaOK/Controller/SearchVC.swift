//
//  SearchVC.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/15.
//

import UIKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var searchController: UISearchController = UISearchController()

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.\
        tableViewDelegate()
        tableViewDataSource()
        searchControllerSetting()
        hotSongScopeBarSetting()
//        searchResultScopeBarSetting()
    }
    
    func searchControllerSetting() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "노래 제목이나 가수를 입력해주세요"
        searchController.searchBar.searchBarStyle = .minimal
        searchTableView.tableHeaderView = searchController.searchBar
    }
    
    func hotSongScopeBarSetting() {
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "TJ인기차트", at: 2, animated: false)
        segmentedControl.insertSegment(withTitle: "KY인기차트", at: 2, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setWidth(100.0, forSegmentAt: 0)
        segmentedControl.setWidth(100.0, forSegmentAt: 1)
        
    }
    
    func searchResultScopeBarSetting() {
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "TJ", at: 2, animated: false)
        segmentedControl.insertSegment(withTitle: "KY", at: 2, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setWidth(60.0, forSegmentAt: 0)
        segmentedControl.setWidth(60.0, forSegmentAt: 1)
    }
    
    func tableViewDelegate() {
        searchTableView.delegate = self
    }
    func tableViewDataSource() {
        searchTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return hotSongDummyTJ.count
        } else {
            return hotSongDummyKY.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchTableViewCell = self.searchTableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        
        if segmentedControl.selectedSegmentIndex == 0 {
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

    @IBAction func segmentedControlDidTapped(_ sender: Any) {
        searchTableView.reloadData()
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
