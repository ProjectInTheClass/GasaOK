//
//  SettingsVC.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/16.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate/*, UITableViewDragDelegate */{

    @IBOutlet weak var folderSettingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDelegate()
        tableViewDataSource()
//        folderSettingTableView.reloadSections(IndexSet(1...1), with: .right)
//        AddFolderVC.transitioningDelegate = self
//        folderSettingTableView.dragDelegate = self
    }
    
    func songWillDelete(deleteIndex: IndexPath) {
        let alert = UIAlertController(title: nil, message: "보관함에서 이 노래를 삭제하시겠습니까?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "노래 삭제", style: .destructive) { (_) in
            folderName.remove(at: deleteIndex.row)
            self.folderSettingTableView.deleteRows(at: [deleteIndex], with: .fade)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let modify = UIContextualAction(style: .normal, title: "수정", handler: {(action, view, completionHandler) in
            print("folder name modify")
            completionHandler(true)
        })
        modify.backgroundColor = .systemBlue
        let delete = UIContextualAction(style: .normal, title: "삭제", handler: {(action, view, completionHandler) in
            print("folder delete")
            self.songWillDelete(deleteIndex: indexPath)
            completionHandler(true)
        })
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete, modify])
    }
    
//    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        <#code#>
//    }
    
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

//extension SettingsVC: UIAdaptivePresentationControllerDelegate {
//    func presentationController
//}

//extension SettingsVC: UIViewControllerTransitioningDelegate {
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        print("dismiss!!!")
//        return nil
//    }
//}
