
import Foundation
import UIKit

class AlarmVC: UIViewController {
    
    // MARK: Property
    private let header = {
        let label = UILabel()
        label.text = "Alarms"
        label.textColor = UIColor(hexCode: "0077b6")
        label.font = .boldSystemFont(ofSize: 35)
        
        return label
    }()
    
    private let alarmList = {
        let tableview = UITableView()
        
        return tableview
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: Layout configuration
    func configureLayout() {
        view.addSubview(header)
        view.addSubview(alarmList)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        alarmList.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            header.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            header.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 20),
            
            alarmList.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 10),
            alarmList.leadingAnchor.constraint(equalTo: header.leadingAnchor),
            alarmList.trailingAnchor.constraint(equalTo: header.trailingAnchor),
            alarmList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
