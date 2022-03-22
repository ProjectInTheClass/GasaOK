//
//  AddFolderVC.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/16.
//

import UIKit

class AddFolderVC: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var folderNameLabel: UILabel!
    @IBOutlet weak var folderNameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButtonSetUp()
        folderNameLabelSetUp()
        
        
    }


    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func addFolder(_ sender: Any) {
//        /// if let 구문으로 바꾸자.
//        if folderNameText.isEditing == false {
//            print("메롱")
//        } else {
//            /// 실제로는 데이터베이스에 폴더를 추가하도록~
//            folderName.append(folderNameText.text ?? "0")
//            print(folderName)
//            exitButton(self)
//        }
//    }
    
    func addButtonSetUp() {
        addButton.layer.cornerRadius = 10.0
    }
    
    func folderNameLabelSetUp() {
        folderNameLabel.text = "보관함 이름"
    }
    
}
