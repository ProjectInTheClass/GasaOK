//
//  SettingsVC.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/02/16.
//

import UIKit

class SettingsVC: UIViewController, UIViewControllerTransitioningDelegate {
    
    //userDefaults
    let userDefaults = UserDefaults.standard
    //다크모드스위치
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //다크모드스위치 값 설정(darkModeState)
        darkModeSwitch.isOn = userDefaults.bool(forKey: "darkModeState")

    }
    
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
    

