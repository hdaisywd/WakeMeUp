
import Foundation
import CoreData
import UIKit

class AlarmManager {

    func createData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "YourEntityName", in: context)!
        
        let newItem = NSManagedObject(entity: entity, insertInto: context)
        newItem.setValue("새로운 데이터", forKey: "attributeName") // 속성 이름과 값을 설정
        
        do {
            try context.save()
        } catch {
            print("데이터를 저장할 수 없습니다. 오류: \(error)")
        }
        
    }
    
    func readData() -> [NSManagedObject] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "YourEntityName")
        
        do {
            let data = try context.fetch(fetchRequest)
            return data
        } catch {
            print("데이터를 불러올 수 없습니다. 오류: \(error)")
            return []
        }
    }

    func updateData(object: NSManagedObject, newValue: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        object.setValue(newValue, forKey: "attributeName") // 업데이트할 속성과 값을 설정
        
        do {
            try context.save()
        } catch {
            print("데이터를 업데이트할 수 없습니다. 오류: \(error)")
        }
    }
    
    func deleteData(object: NSManagedObject) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        context.delete(object)
        
        do {
            try context.save()
        } catch {
            print("데이터를 삭제할 수 없습니다. 오류: \(error)")
        }
    }
}
