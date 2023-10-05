
import Foundation
import UIKit

final class SelectDaysView: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let pickerview = UIPickerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialConfiguration()
        toolbarConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialConfiguration() {
        pickerview.delegate = self
        pickerview.dataSource = self
        self.inputView = pickerview
        self.tintColor = .clear
    }
    
    let daysString: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let numbers: [String] = ["1", "2", "3", "4", "5", "6", "7"]
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return daysString[row]
        } else {
            return numbers[row]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return daysString.count
    }
    
    func toolbarConfiguration() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnAction))
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtnAction))
        toolBar.setItems([cancelBtn, flexibleSpace, doneBtn], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
    }
    
    @objc func cancelBtnAction() {
        self.resignFirstResponder()
    }
    
    @objc func doneBtnAction() {
        self.resignFirstResponder()
    }
    
    
}
