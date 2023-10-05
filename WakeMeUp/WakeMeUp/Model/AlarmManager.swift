
import Foundation
import CoreData
import UIKit

struct Alarms {
    var title: String
    var days: String
    var time: String
    var isAble: Bool
    var repeating: Bool
}


class AlarmManager {

    static let shared = AlarmManager()
    
    private let context: NSManagedObjectContext

    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }


    func createData(title: String, days: String, time: String, isAble: Bool, repeating: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let titleEntity = NSEntityDescription.entity(forEntityName: "Alarm", in: context)!
        
        let newItem = NSManagedObject(entity: titleEntity, insertInto: context)
        newItem.setValue(title, forKey: "title")
        newItem.setValue(days, forKey: "days")
        newItem.setValue(time, forKey: "time")
        newItem.setValue(isAble, forKey: "isAble")
        newItem.setValue(repeating, forKey: "repeating")
        
        do {
            try context.save()
        } catch {
            print("데이터를 저장할 수 없습니다. 오류: \(error)")
        }
        
    }
    
    func getAllAlarms() -> [NSManagedObject]? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Alarm")
        
        do {
            let alarms = try context.fetch(fetchRequest)
            return alarms
        } catch {
            print("데이터를 조회할 수 없습니다. 오류: \(error)")
            return nil
        }
    }


    func updateAlarm(alarm: NSManagedObject, title: String, days: String, time: String, isAble: Bool, repeating: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        alarm.setValue(title, forKey: "title")
        alarm.setValue(days, forKey: "days")
        alarm.setValue(time, forKey: "time")
        alarm.setValue(isAble, forKey: "isAble")
        alarm.setValue(repeating, forKey: "repeating")
        
        do {
            try context.save()
        } catch {
            print("데이터를 업데이트할 수 없습니다. 오류: \(error)")
        }
    }

    
    func deleteAlarm(alarm: NSManagedObject) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        context.delete(alarm)
        
        do {
            try context.save()
        } catch {
            print("데이터를 삭제할 수 없습니다. 오류: \(error)")
        }
    }

}
