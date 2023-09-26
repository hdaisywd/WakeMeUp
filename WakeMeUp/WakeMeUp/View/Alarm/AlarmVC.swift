
import Foundation
import UIKit

class AlarmVC: UIViewController {
    
    static let alarmTableViewIdentifier = "AlarmTableViewCell"
    
    // MARK: Property
    private let header = {
        let label = UILabel()
        label.text = "Alarms"
        label.textColor = UIColor(hexCode: "0077b6")
        label.font = .boldSystemFont(ofSize: 35)
        
        return label
    }()
    
    lazy var alarmList = {
        let tableview = UITableView()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(AlarmTableViewCell.self, forCellReuseIdentifier: AlarmVC.alarmTableViewIdentifier)
        
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

// MARK: TableView Delegate, DataSource Settings
extension AlarmVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Must"
        } else {
            return "Do"
        }
    }

    // Header 사이즈
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmVC.alarmTableViewIdentifier, for: indexPath) as! AlarmTableViewCell
        
        return cell
    }
}
