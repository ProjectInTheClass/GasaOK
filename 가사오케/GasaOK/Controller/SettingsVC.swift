//
//  SettingsVC.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/16.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var folderSettingTableView: UITableView!
    let folderName: [String] = ["보관함1", "힙합", "R&B"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDelegate()
        tableViewDataSource()
    }
    
    // MARK: - tableView Delegate, DataSource func
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return folderName.count
        case 2:
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
        } else if indexPath.section == 1 {
            let cell: FolderPositionChangeTableViewCell = folderSettingTableView.dequeueReusableCell(withIdentifier: "Folder Position Change Cell", for: indexPath) as! FolderPositionChangeTableViewCell
            cell.folderNameLabel.text = folderName[indexPath.row]
            return cell
        } else {
            let cell: FolderAddTableViewCell = folderSettingTableView.dequeueReusableCell(withIdentifier: "Folder Add Cell", for: indexPath) as! FolderAddTableViewCell
            cell.folderAddLabel.text = "보관함 추가하기..."
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "보관함 순서"
        } else {
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    // MARK: - Delegate
    func tableViewDelegate() {
        folderSettingTableView.delegate = self
    }

    // MARK: - DataSource
    func tableViewDataSource() {
        folderSettingTableView.dataSource = self
    }

}
