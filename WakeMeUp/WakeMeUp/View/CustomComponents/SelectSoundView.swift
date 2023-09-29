
import Foundation
import UIKit

final class SelectSoundPickerView: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let pickerview = UIPickerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialConfiguration()
        dismissPickerView()
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
    
    let numbersString: [String] = ["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight"]
    let numbers: [String] = ["1", "2", "3", "4", "5", "6", "7", "8"]
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return numbersString[row]
        } else {
            return numbers[row]
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let cancelBtn = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(self.action))
        let doneBtn = UIBarButtonItem(title: "done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([cancelBtn, doneBtn], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.inputAccessoryView = toolBar
    }
    
    
}
