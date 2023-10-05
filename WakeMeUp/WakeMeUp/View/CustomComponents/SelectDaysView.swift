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
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 5.0
        self.delegate = self
    }
    
    let daysString: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    var selectedDay: String?
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return daysString[row]
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
        self.delegate?.textFieldDidEndEditing(self)
    }
    
    func setSelectedDay(_ day: String) {
        selectedDay = day
    }
    
    func showSelectionAlert() {
        let alert = UIAlertController(title: "Select Day", message: nil, preferredStyle: .actionSheet)
        
        for day in daysString {
            let action = UIAlertAction(title: day, style: .default) { [weak self] _ in
                self?.setSelectedDay(day)
            }
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}

extension SelectDaysView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let selectedDay = selectedDay {
            textField.text = selectedDay
        }
    }
}
