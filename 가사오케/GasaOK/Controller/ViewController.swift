//
//  ViewController.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/12.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setNavigationItems()
    }
    ///네비게이션 아이템 (largeTitle, 보관함 변경 버튼) 생성
    func setNavigationItems() {
        let folderChangeButton = UIButton(type: .system)
        folderChangeButton.setTitle("💡 보관함1", for: .normal)
        folderChangeButton.setImage(UIImage(systemName: "arrowtriangle.down.circle"), for: .normal)
        folderChangeButton.frame = CGRect(x: 0, y: 0, width: 70, height: 30)
        folderChangeButton.tintColor = .black
        folderChangeButton.semanticContentAttribute = .forceRightToLeft
        ///폰트사이즈 조정, 오류남 고쳐야함
        //folderChangeButton.titleLabel?.font = UIFont(name: , size: 20)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: folderChangeButton)
    }
    

    
    
}
