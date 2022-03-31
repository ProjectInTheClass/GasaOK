//
//  ViewController.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/12.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITabBarControllerDelegate {

    @IBOutlet weak var mySongTableView: UITableView!
    
    let isDark = UserDefaults.standard.bool(forKey: "darkModeState")
    
    lazy var list:[NSManagedObject] = {
        return self.fetch()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFolderChangeButton()
        tableViewDelegate()
        tableViewDataSource()
        barButtonItemTextRemove()
        darkModeCheck()
    }
    
    // MARK: - 곡 추가 시 보관함 테이블뷰 reload
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        list = self.fetch()
//        print("보관함 화면으로 전환~")
        DispatchQueue.main.async {
            self.mySongTableView.reloadData()
        }
//        print("view will appear")
    }

    
    // MARK: - 네비게이션 아이템 (보관함 변경 버튼) 생성
    func setFolderChangeButton() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // MARK: - 보관함 내 노래 삭제 시 뜨는 알림창
    func songWillDelete(deleteIndex:IndexPath) {
        let alert = UIAlertController(title: nil, message: "보관함에서 이 노래를 삭제하시겠습니까?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "노래 삭제", style: .destructive) { (_) in
            let object = self.list[deleteIndex.row]
            if self.delete(object: object) {
                self.list.remove(at: deleteIndex.row)
                self.mySongTableView.deleteRows(at: [deleteIndex], with: .fade)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

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

// MARK: - 보관함 노래 목록 tableView
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = self.list[indexPath.row]
        let songTitle = index.value(forKey: "songTitle") as? String
        let singer = index.value(forKey: "singer") as? String
        let number = index.value(forKey: "number") as? String
        
        let cell = self.mySongTableView.dequeueReusableCell(withIdentifier: "MySongTableViewCell") as! MySongTableViewCell
        cell.songNameLabel.text = songTitle
        cell.singerNameLabel.text = singer
        cell.karaokeNumber.text = number
        return cell
    }
    ///스와이프 메뉴
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            let delete = UIContextualAction(style: .normal, title: "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                print("delete!!")
                self.songWillDelete(deleteIndex: indexPath)
                success(true)
            })
        
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableViewDelegate() {
        mySongTableView.delegate = self
    }
    
    func tableViewDataSource() {
        mySongTableView.dataSource = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "songDetailIdentifier2" {

            let songDetailIndexPath = mySongTableView.indexPath(for: sender as! MySongTableViewCell)!
            let VCDestination = segue.destination as! SongInfoDetailVC
//            VCDestination.songInfoData = list[songDetailIndexPath.row]
            let song: SongInfoElement = SongInfoElement( brand: nil,
                                                        no: list[songDetailIndexPath.row].value(forKey: "number") as! String,
                                                        title: list[songDetailIndexPath.row].value(forKey: "songTitle") as! String,
                                                        singer: list[songDetailIndexPath.row].value(forKey: "singer") as! String )
            VCDestination.songInfoData = song
        }
    }
    
    // MARK: - 데이터 fetch
    func fetch() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Song")
        let result = try! context.fetch(fetchRequest)
//        print(result)
        return result
    }
    
    // MARK: - 데이터 삭제
    func delete(object: NSManagedObject) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(object)
        
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
}
