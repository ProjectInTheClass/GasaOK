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
    @IBOutlet weak var emptyView: UIView!
    let isDark = UserDefaults.standard.bool(forKey: "darkModeState")
    
    @IBAction func btnMoveDatePickerView( sender: UIButton) {
          tabBarController?.selectedIndex = 1 // 데이트 피커 뷰 탭으로 이동
      }
    
    lazy var songLists:[NSManagedObject] = {
        return CoreDataMethod.dataWillFetch()
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
        songLists = CoreDataMethod.dataWillFetch()
        DispatchQueue.main.async {
            self.mySongTableView.reloadData()
        }
        self.checkStorageisEmpty()
    }

    // MARK: - 보관함 내 노래 삭제 시 뜨는 알림창
    /// - Parameter deleteIndex: 삭제하려는 노래의 인덱스
    func songWillDelete(deleteIndex:IndexPath) {
        let alert = UIAlertController(title: nil, message: "보관함에서 이 노래를 삭제하시겠습니까?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "노래 삭제", style: .destructive) { (_) in
            let object = self.songLists[deleteIndex.row]
            if CoreDataMethod.dataWillDelete(object: object) {
                self.songLists.remove(at: deleteIndex.row)
                self.mySongTableView.deleteRows(at: [deleteIndex], with: .fade)
                self.checkStorageisEmpty()
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)

    }


    // MARK: - 다크모드 설정 확인
    /// 앱의 설정에 따라 다크모드인지 라이트모드인지 결정됨.
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
                //
                self.checkStorageisEmpty()
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
    
// MARK: - 보관함에 저장된 노래가 있는지 없는지 확인
    func checkStorageisEmpty() {
        if self.songLists.count == 0 {
            self.emptyView.isHidden = false
        } else {
            self.emptyView.isHidden = true
            
        }
    }
    // MARK: - 가사 보기 알림창
    ///FIXME: 변수명 제안 lyricsAlertWillShow
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
				
