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
    
    lazy var songLists:[NSManagedObject] = {
        return self.fetch()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
//        setFolderChangeButton()
        tableViewDelegate()
        tableViewDataSource()
//        barButtonItemTextRemove()
        darkModeCheck()
    }
    
    // MARK: - 곡 추가 시 보관함 테이블뷰 reload
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        songLists = self.fetch()
        DispatchQueue.main.async {
            self.mySongTableView.reloadData()
        }
    }


    /// REMOVE🅾️: 보관함 변경 버튼 생성 시 살리고 아니면 삭제
//    // MARK: - 네비게이션 아이템 (보관함 변경 버튼) 생성
//    func setFolderChangeButton() {
//        navigationController?.navigationBar.prefersLargeTitles = true
//    }
    
    // MARK: - 보관함 내 노래 삭제 시 뜨는 알림창
    /// - Parameter deleteIndex: 삭제하려는 노래의 인덱스
    func songWillDelete(deleteIndex:IndexPath) {
        let alert = UIAlertController(title: nil, message: "보관함에서 이 노래를 삭제하시겠습니까?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "노래 삭제", style: .destructive) { (_) in
            let object = self.songLists[deleteIndex.row]
            if self.delete(object: object) {
                self.songLists.remove(at: deleteIndex.row)
                self.mySongTableView.deleteRows(at: [deleteIndex], with: .fade)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

    }

    ///REMOVE🅾️ : 가사를 보는 화면이 있을 때, 해당 화면의 백버튼 아이템의 타이틀을 지워주는 용도였음. 지금은 필요x
//    func barButtonItemTextRemove() {
//            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//            self.navigationItem.backBarButtonItem = backBarButtonItem
//        }
    
    /// 다크모드 설정을 확인한다.
    /// 앱의 설정에 따라 다크모드인지 라이트모드인지 결정됨.
    // FIXME: - 현재 13을 기준으로 개발되어있으므로 windows 말고 다른 방법으로 개발이 필요
    func darkModeCheck(){
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        
            if let window = windowScene?.windows.first{
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
        return self.songLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = self.songLists[indexPath.row]
        let songTitle = index.value(forKey: "songTitle") as? String
        let singer = index.value(forKey: "singer") as? String
        let number = index.value(forKey: "number") as? String
        //브랜드 이름을 songModel의 brand 속성으로부터 받아옴
        guard let brandName = index.value(forKey: "brand") as? String else { return UITableViewCell() }
        let cell = self.mySongTableView.dequeueReusableCell(withIdentifier: "MySongTableViewCell") as! MySongTableViewCell
        cell.songNameLabel.text = songTitle
        cell.singerNameLabel.text = singer
        cell.karaokeNumber.text = number
        //imageLogo를 brandName+"Logo"로 저장하여 해당 이름을 가진 이미지 로고를 불러오게 됨
        cell.imageLogo.image = UIImage (named: brandName + "Logo")
        return cell
    }
    /// 스와이프 메뉴
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
    
    /// 선택한 노래의 가사를 확인
    /// didSelectRowAt, IndexPath를 활용
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /// 선택한 셀이 화면에 뿌려지고 있는 songLists 배열에서 몇 번째인지 찾는다.
        let index = self.songLists[indexPath.row]
        /// 해당 셀의 노래제목과 가수를 가져온다.
        guard let songTitle = index.value(forKey: "songTitle") as? String else { return }
        guard let singer = index.value(forKey: "singer") as? String else { return }
        
        /// 노래제목과 가수를 파라미터로 함수 호출
        AlertManager.shared.lyricsAlert(vc: self, title: songTitle, singer: singer)

    }
    
    // MARK: - 데이터 fetch
    func fetch() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Song")
        let result = try! context.fetch(fetchRequest)
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
