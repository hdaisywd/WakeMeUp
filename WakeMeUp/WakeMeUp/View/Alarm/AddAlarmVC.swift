
import Foundation
import UIKit
import SnapKit

class AddAlarmVC: UIViewController {
    
    // MARK: Property
    private let datepicker = {
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .time
        datepicker.preferredDatePickerStyle = .wheels
        datepicker.locale = Locale(identifier: "en_KR")
        
        return datepicker
    }()
    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureLayout()
    }

    private func configureNavigationBar() {
        view.backgroundColor = .white
        
        self.navigationItem.title = "Add Alarm"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(hexCode: "0077b6")]
        
        let leftBarItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonAction))
        leftBarItem.tintColor = UIColor(hexCode: "0077b6")
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        let rightBarItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonAction))
        rightBarItem.tintColor = UIColor(hexCode: "0077b6")
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    private func configureLayout() {
        view.addSubview(datepicker)
        
        datepicker.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.snp.top).offset(100)
        }
    }
    
    @objc func cancelButtonAction() {
        
    }
    
    @objc func saveButtonAction() {
        
    }
}
