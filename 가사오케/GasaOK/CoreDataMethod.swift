//
//  CoreDataMethod.swift
//  GasaOK
//
//  Created by 이봄이 on 2022/08/28.
//

import Foundation
import UIKit
import CoreData

class CoreDataMethod {
    // 데이터 fetch
    static public func dataWillFetch() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Song")
        let result = try! context.fetch(fetchRequest)
        return result
    }
    
    // 데이터 삭제
    static public func dataWillDelete(object: NSManagedObject) -> Bool {
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
}
