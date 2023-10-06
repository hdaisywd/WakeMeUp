//
//  TimerRingtoneTalbeViewController.swift
//
//  Created by 장가겸 on 10/2/23.
//

import AVFoundation
import UIKit

class TimerRingtoneTableViewController: UIViewController {
    var audioPlayer: AVAudioPlayer?
    private var soundList: [String] = ["forest", "Chainsaw-Man-Opening", "Howls-Moving-Castle", "iPhone-Alarm-Original", "sky"]
    let selectedSoundFromTimerViewController: String? = "기본음"
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
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
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
        tableView.layer.cornerRadius = 10

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
        dismiss(animated: true)
    }

    func setupController() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    public func translateSoundNameToKorean(text: String) -> String {
        switch text {
        case "forest":
            return "숲소리"
        case "Chainsaw-Man-Opening":
            return "킥 백"
        case "Howls-Moving-Castle":
            return "하울의 움직이는 성"
        case "iPhone-Alarm-Original":
            return "기본음"
        case "sky":
            return "사건의 지평선"
        default:
            return ""
        }
    }

    public func translateSoundName(text: String) -> String {
        switch text {
        case "숲소리":
            return "forest"
        case "킥 백":
            return "Chainsaw-Man-Opening"
        case "하울의 움직이는 성":
            return "Howls-Moving-Castle"
        case "기본음":
            return "iPhone-Alarm-Original"
        case "사건의 지평선":
            return "sky"
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

        if soundName == selectedSoundFromTimerViewController! {
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

        tableView.visibleCells[indexPath.row].accessoryType = .checkmark

        let url = Bundle.main.url(forResource: translateSoundName(text: label.soundLabel.text!), withExtension: "mp3")
        print(label.soundLabel.text)
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
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
