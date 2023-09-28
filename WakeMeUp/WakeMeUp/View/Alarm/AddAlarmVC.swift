
import Foundation
import UIKit

class AddAlarmVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
    }
    
    // MARK: ConfigureNavigationBar
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
        
    }
    
    @objc func cancelButtonAction() {
        
    }
    
    @objc func saveButtonAction() {
        
    }
}
