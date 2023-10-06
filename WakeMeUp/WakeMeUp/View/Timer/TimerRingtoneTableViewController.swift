//
//  TimerRingtoneTalbeViewController.swift
//
//  Created by 장가겸 on 10/2/23.
//

import AVFoundation
import UIKit

protocol TestDelegate: AnyObject {
    func test(music: String, alarmSound: String)
}

class TimerRingtoneTableViewController: UIViewController {
    weak var Delegate: TestDelegate?
    var audioPlayer: AVAudioPlayer?
    private var soundList: [String] = ["Charlie-Puth-I-Dont-Think-That-I-Like-Her", "Chainsaw-Man-Opening", "GODS-ft.-NewJeans-뉴진스-League-of-Legends-2023", "iPhone-Alarm-Original", "iPhone-14-Original"]
    var selectedSoundFromTimerViewController: String? = "기본음"
    var translateSoundName: String = "기본음"
    var sound: String = "iPhone-Alarm-Original"
    let tableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()

    let navigationBar: UINavigationBar = {
        let navigationBar = UINavigationBar()
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupController()
    }

    func setupUI() {
        view.addSubview(tableView)
        view.addSubview(navigationBar)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.register(TimerRingtoneTableViewCell.self, forCellReuseIdentifier: "TimerRingtoneTableViewCell")
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 0

        let leftBarButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        let rightBarButton = UIBarButtonItem(title: "설정", style: .plain, target: self, action: #selector(settingButtonTapped))
        let navItem = UINavigationItem(title: "타이머 울릴 시")
        navItem.leftBarButtonItem = leftBarButton
        navItem.rightBarButtonItem = rightBarButton
        leftBarButton.tintColor = .systemOrange
        rightBarButton.tintColor = .systemOrange
        navigationBar.setItems([navItem], animated: true)
    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }

    @objc func settingButtonTapped() {
        Delegate?.test(music: sound, alarmSound: translateSoundName)
        dismiss(animated: true)
    }

    func setupController() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    public func translateSoundNameToKorean(text: String) -> String {
        switch text {
        case "Charlie-Puth-I-Dont-Think-That-I-Like-Her":
            return "I Dont Think That I Like Her"
        case "Chainsaw-Man-Opening":
            return "킥 백"
        case "GODS-ft.-NewJeans-뉴진스-League-of-Legends-2023":
            return "GODS"
        case "iPhone-Alarm-Original":
            return "기본음"
        case "iPhone-14-Original":
            return "아이폰 14 기본음"
        default:
            return ""
        }
    }

    public func translateSoundName(text: String) -> String {
        switch text {
        case "I Dont Think That I Like Her":
            return "Charlie-Puth-I-Dont-Think-That-I-Like-Her"
        case "킥 백":
            return "Chainsaw-Man-Opening"
        case "GODS":
            return "GODS-ft.-NewJeans-뉴진스-League-of-Legends-2023"
        case "기본음":
            return "iPhone-Alarm-Original"
        case "아이폰 14 기본음":
            return "iPhone-14-Original"
        default:
            return ""
        }
    }
}

extension TimerRingtoneTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return soundList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimerRingtoneTableViewCell", for: indexPath) as? TimerRingtoneTableViewCell else { return UITableViewCell() }
        let soundName = translateSoundNameToKorean(text: soundList[indexPath.row])
        cell.soundLabel.text = soundName
        cell.accessoryType = .none
        cell.tintColor = .systemOrange

        if soundName == selectedSoundFromTimerViewController {
            cell.accessoryType = .checkmark
        }
        return cell
    }
}

extension TimerRingtoneTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let label = tableView.visibleCells[indexPath.row] as? TimerRingtoneTableViewCell else {
            return
        }

        switch indexPath.row {
        case 0:
            sound = soundList[0]
            translateSoundName = translateSoundNameToKorean(text: sound)
        case 1:
            sound = soundList[1]
            translateSoundName = translateSoundNameToKorean(text: sound)
        case 2:
            sound = soundList[2]
            translateSoundName = translateSoundNameToKorean(text: sound)
        case 3:
            sound = soundList[3]
            translateSoundName = translateSoundNameToKorean(text: sound)
        case 4:
            sound = soundList[4]
            translateSoundName = translateSoundNameToKorean(text: sound)
        default:
            sound = soundList[3]
            translateSoundName = translateSoundNameToKorean(text: sound)
        }

        let url = Bundle.main.url(forResource: translateSoundName(text: label.soundLabel.text!), withExtension: "mp3")
        if let url = url {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print(error)
            }
        }

        let _ = tableView.visibleCells.map { cell in
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                return
            }
        }

        tableView.visibleCells[indexPath.row].accessoryType = .checkmark

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
