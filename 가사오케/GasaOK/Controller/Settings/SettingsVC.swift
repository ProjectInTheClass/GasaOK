//
//  SettingsVC.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/16.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate/*, UITableViewDragDelegate */{
    
    let defaults = UserDefaults.standard
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var darkModeSetView: UIView!
    @IBOutlet weak var folderSettingTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //다크모드로 설정되어 잇으면
        darkModeSwitch.isOn = defaults.bool(forKey: "darkModeState")

    }

    
    // MARK: - tableView Delegate, DataSource func
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: DarkModeTableViewCell = folderSettingTableView.dequeueReusableCell(withIdentifier: "Dark Mode Cell", for: indexPath) as! DarkModeTableViewCell
            cell.darkModeCellLabel.text = "다크모드"
            /// 다크모드인지 아닌지 확인한 결과가 들어가도록 수정.
            cell.darkModeSwitch.isOn = false
            return cell
        } else { return UITableViewCell() }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "보관함 순서"
        } else {
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - Delegate
    func tableViewDelegate() {
        folderSettingTableView.delegate = self
    }

    // MARK: - DataSource
    func tableViewDataSource() {
        folderSettingTableView.dataSource = self
    }

   
    @IBAction func darkModeChangeSwitch(_ sender: UISwitch) {
        
        if let window = UIApplication.shared.windows.first {
            if #available(iOS 13.0, *){
                window.overrideUserInterfaceStyle = darkModeSwitch.isOn == true ? .dark : .light
                defaults.set(darkModeSwitch.isOn, forKey: "darkModeState")
            }else {
                window.overrideUserInterfaceStyle = .light
            }
        }
    }

}
    

