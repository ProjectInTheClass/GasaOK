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
        DispatchQueue.main.async {
            self.mySongTableView.reloadData()
        }
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
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = self.list[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index = self.list[indexPath.row]
        guard let songTitle = index.value(forKey: "songTitle") as? String else { return }
        guard let singer = index.value(forKey: "singer") as? String else { return }
        
        showLyricsAlert(title: songTitle, singer: singer)
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
