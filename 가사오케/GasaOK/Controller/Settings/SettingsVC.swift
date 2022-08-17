//
//  SettingsVC.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/16.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate/*, UITableViewDragDelegate */{
    
    //userDefaults
    let userDefaults = UserDefaults.standard
    //다크모드스위치
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var darkModeSetView: UIView!
    @IBOutlet weak var folderSettingTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //다크모드스위치 값 설정(darkModeState)
        darkModeSwitch.isOn = userDefaults.bool(forKey: "darkModeState")

    }

    
    // MARK: - tableView Delegate, DataSource func
    /// tableView 색션 갯수 설정한다.
    /// - Parameter tableView: UITableView
    /// - Parameter section: section의 Row 갯수
    /// - Returns: section 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
    }
    
    /// tableView 셀 만들기.
    /// - Parameter tableView: UITableView
    /// - Parameter indexPath: index 위치
    /// - Returns: UITableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: DarkModeTableViewCell = folderSettingTableView.dequeueReusableCell(withIdentifier: "Dark Mode Cell", for: indexPath) as! DarkModeTableViewCell
            cell.darkModeCellLabel.text = "다크모드"
            // 다크모드인지 아닌지 확인한 결과가 들어가도록 수정.
            cell.darkModeSwitch.isOn = false
            return cell
        } else { return UITableViewCell() }
    }
    
 /*   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "보관함 순서"
        } else {
            return ""
        }
    }
 */
   /* func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   */
   
   /*
    // MARK: - Delegate
    func tableViewDelegate() {
        folderSettingTableView.delegate = self
    }
*/
 /*
    // MARK: - DataSource
    func tableViewDataSource() {
        folderSettingTableView.dataSource = self
    }
*/
    ///다크모드 스위치를 클릭했을 때 동작하는 함수
    ///- Parameter sender: UISwitch
    //FIXME: - 함수명 바꿔야할 것 같음.
    @IBAction func darkModeChangeSwitch(_ sender: UISwitch) {
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        
            if let window = windowScene?.windows.first{
            if #available(iOS 13.0, *){
                window.overrideUserInterfaceStyle = darkModeSwitch.isOn == true ? .dark : .light
                //변경된 스위치 값의 상태를 UserDefaults에 저장
                userDefaults.set(darkModeSwitch.isOn, forKey: "darkModeState")
            }else {
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
}
    

