
import Foundation
import UIKit

final class MyTextfield: UITextField, UITextFieldDelegate {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }

    private func setupTextField() {
        self.delegate = self
        self.clearButtonMode = .always
        self.borderStyle = .roundedRect
        self.placeholder = "Please enter a title."
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("클릭했습니다")
        self.becomeFirstResponder()
    }
}
