//
//  UIAlertController.swift
//  GasaOK
//
//  Created by Da Hae Lee on 2022/08/16.
//

import Foundation
import UIKit

extension UIAlertController {

    // Set message font and message color
    func setMessage(color: UIColor?) {
        guard let message = self.message else { return }
        let attributeString = NSMutableAttributedString(string: message)
        
        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor: messageColorColor],
                                          range: NSRange(location: 0, length: message.count))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }
    
    
}
