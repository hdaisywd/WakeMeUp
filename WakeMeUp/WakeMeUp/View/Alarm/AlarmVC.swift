import Foundation
import UIKit
import CoreData
import UserNotifications

class AlarmVC: UIViewController {
    
    static let alarmTableViewIdentifier = "AlarmTableViewCell"
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    let mustData: [Alarms] = [
        Alarms(title: "스크럼하기", days: "MON TUE WED THU FRI", time: "09:30 AM", isAble: true, repeating: true)
    ]
    
    var dummyData: [Alarms] = []
    
    // MARK: Property
    
    lazy var alarmList = {
        let tableview = UITableView()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(AlarmTableViewCell.self, forCellReuseIdentifier: AlarmVC.alarmTableViewIdentifier)
        tableview.separatorStyle = .none
        
        return tableview
    }()
    
    private let addButtonSize = 60.0
    
    private lazy var addButton = {
        let button = UIButton()
        
        button.frame = CGRect(x: 0, y: 0, width: addButtonSize, height: addButtonSize)
        button.backgroundColor = UIColor(hexCode: "0077b6")
        button.circleButton = true
        button.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)
        button.tintColor = .white
        button.setImage(image, for: .normal)
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        
        return button
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNotificationCenter.delegate = self

        deleteAllAlarms()
        loadData()
        print("더미 데이터: ", dummyData)
        configureLayout()
        
        requestNotificationAuthorization()
        sendNotification(seconds: 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "알람"
        createDummyData()
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        
        userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    func sendNotification(seconds: Double) {
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "스크럼"
        notificationContent.body = "일어나세요! 스크럼 시간입니다!"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            } else {
                print("프린트 문 ㅋ.ㅋ")
                let storyboard = UIStoryboard(name: "GameVC", bundle: nil)
                if let gameVC = storyboard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController {
                    DispatchQueue.main.async {
//                        Thread.sleep(forTimeInterval: 12.0)
//                        self.navigationController?.pushViewController(gameVC, animated: true)
                    }
                }
            }
        }
    }
    
    // MARK: Dummy Data
    func createDummyData() {
        let shared = AlarmManager.shared
        shared.createData(title: "스크럼 하기", days: "MON", time: "09:00 AM", isAble: true, repeating: true)
        shared.createData(title: "밥 먹기", days: "TUE WED", time: "14:00 AM", isAble: true, repeating: true)
        shared.createData(title: "운동 하기", days: "NO REPEAT", time: "20:30 AM", isAble: true, repeating: false)
        
        if let alarms = shared.getAllAlarms() {
            for alarm in alarms {
                let title = alarm.value(forKey: "title") as! String
                let days = alarm.value(forKey: "days") as! String
                let time = alarm.value(forKey: "time") as! String
                let isAble = alarm.value(forKey: "isAble") as! Bool
                let repeating = alarm.value(forKey: "repeating") as! Bool

                let alarmInstance = Alarms(title: title, days: days, time: time, isAble: isAble, repeating: repeating)
                dummyData.append(alarmInstance)
            }
        }
    }


    func loadData() {
        if let alarms = AlarmManager.shared.getAllAlarms() {
            for alarm in alarms {
                let title = alarm.value(forKey: "title") as! String
                let days = alarm.value(forKey: "days") as! String
                let time = alarm.value(forKey: "time") as! String
                let isAble = alarm.value(forKey: "isAble") as! Bool
                let repeating = alarm.value(forKey: "repeating") as! Bool

                let alarmInstance = Alarms(title: title, days: days, time: time, isAble: isAble, repeating: repeating)
                dummyData.append(alarmInstance)
            }
        }
    }

    func deleteAllAlarms() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alarm")

        do {
            let alarms = try context.fetch(fetchRequest)
            for alarm in alarms {
                if let alarmObject = alarm as? NSManagedObject {
                    context.delete(alarmObject)
                }
            }

            try context.save()
        } catch {
            print("모든 알람 데이터를 삭제할 수 없습니다. 오류: \(error)")
        }
    }

    
    // MARK: Layout configuration
    private func configureLayout() {
        view.addSubview(alarmList)
        view.addSubview(addButton)
        
        alarmList.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            alarmList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            alarmList.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            alarmList.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            alarmList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: addButtonSize),
            addButton.widthAnchor.constraint(equalToConstant: addButtonSize)
        ])
    }
    
    @objc func addButtonAction() {
        let nextVC = UINavigationController(rootViewController: AddAlarmVC())
        self.present(nextVC, animated: true)
        
        DispatchQueue.main.async {
            self.alarmList.reloadData()
        }
    }
}

// MARK: TableView Delegate, DataSource Settings
extension AlarmVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return mustData.count
        } else {
            return dummyData.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Must"
        } else {
            return "Do"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let sectionHeader = view as! UITableViewHeaderFooterView
        sectionHeader.textLabel?.font = .boldSystemFont(ofSize: 20)
        sectionHeader.textLabel?.textColor = .darkGray
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmVC.alarmTableViewIdentifier, for: indexPath) as! AlarmTableViewCell
        
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = UIColor(hexCode: "B8C0FF")
        
        if indexPath.section == 0 {
            let alarm = mustData[indexPath.row]
            cell.title.text = alarm.title
            cell.day.text = alarm.days
            cell.time.text = alarm.time
            cell.alarmSwitch.isEnabled = alarm.isAble
        } else if indexPath.section == 1 {
            let alarm = dummyData[indexPath.row]
            cell.title.text = alarm.title
            cell.day.text = alarm.days
            cell.time.text = alarm.time
            cell.alarmSwitch.isEnabled = alarm.isAble
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
}

extension AlarmVC: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}
