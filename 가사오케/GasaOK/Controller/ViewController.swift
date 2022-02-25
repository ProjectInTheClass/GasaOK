//
//  ViewController.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/12.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mySongTableView: UITableView!
   
    let isDark = UserDefaults.standard.bool(forKey: "darkModeState")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFolderChangeButton()
        tableViewDelegate()
        tableViewDataSource()
        barButtonItemTextRemove()
        darkModeCheck()
     
    }
    // MARK: - 네비게이션 아이템 (보관함 변경 버튼) 생성
    /*iOS15부터 사용 가능한 configuration으로 하니 버튼 이미지나 타이틀 위치 조정이 쉬웠다*/
    func setFolderChangeButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10)
        let title = "💡 보관함1"
        let attribute = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 20)]
        let attributedTitle = NSAttributedString(string: title, attributes: attribute)
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "chevron.down")
        configuration.preferredSymbolConfigurationForImage = imageConfig
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 9
        
        let folderChangeButton = UIButton(configuration: configuration, primaryAction: nil)
        folderChangeButton.setAttributedTitle(attributedTitle, for: .normal)
            folderChangeButton.tintColor = .black
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: folderChangeButton)
    }
    
    
    
    // MARK: - 보관함 내 노래 삭제 시 뜨는 알림창
    func songWillDelete(deleteIndex:IndexPath) {
        let alert = UIAlertController(title: nil, message: "보관함에서 이 노래를 삭제하시겠습니까?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "노래 삭제", style: .destructive) { (_) in
            //self.mySongTableView.beginUpdates()
            mySongDummyFolder1.remove(at: deleteIndex.row)
            self.mySongTableView.deleteRows(at: [deleteIndex], with: .fade)
            //self.mySongTableView.endUpdates()
            
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

    }
    
}

// MARK: - 보관함별 노래 목록 tableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mySongDummyFolder1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MySongTableViewCell = self.mySongTableView.dequeueReusableCell(withIdentifier: "MySongTableViewCell", for:indexPath) as! MySongTableViewCell
        cell.songNameLabel.text = mySongDummyFolder1[indexPath.row].songName
        cell.singerNameLabel.text = mySongDummyFolder1[indexPath.row].singerName
        cell.karaokeNumber.text = mySongDummyFolder1[indexPath.row].karaokeNumber
        
        return cell
    }
    ///스와이프 메뉴
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let move = UIContextualAction(style: .normal, title: "이동", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("move!!")
                success(true)
            })
            
            let delete = UIContextualAction(style: .normal, title: "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("delete!!")
                self.songWillDelete(deleteIndex: indexPath)
                success(true)
            })
        
        move.backgroundColor = .systemBlue
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete, move])
    }
    
    func tableViewDelegate() {
        mySongTableView.delegate = self
    }
    
    func tableViewDataSource() {
        mySongTableView.dataSource = self
    }
    
    
//     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         if segue.identifier == "songDetailIdentifier" {
//             let MySongDetailTableViewIndexPath = mySongTableView.indexPath(for: sender as! MySongTableViewCell)!
//
//             let VCDestination = segue.destination as! SongInfoDetailVC
//             VCDestination.songInfoData =
//             mySongDummyFolder1[MySongDetailTableViewIndexPath.row]
//         }
//     }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "songDetailIdentifier2" {
            let songDetailIndexPath = mySongTableView.indexPath(for: sender as! MySongTableViewCell)!
            let VCDestination = segue.destination as! SongInfoDetailVC
            VCDestination.songInfoData = mySongDummyFolder1[songDetailIndexPath.row]
        }
    }
    
    func barButtonItemTextRemove() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func darkModeCheck(){
        
        if let window = UIApplication.shared.windows.first{
            if #available(iOS 13.0, *){
                window.overrideUserInterfaceStyle = isDark == true ? .dark : .light
            }
            else{
                window.overrideUserInterfaceStyle = .light
            }
            
        }
    }
    
    
    
}
