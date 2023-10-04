//
//  TimerRingtoneTalbeViewController.swift
//
//  Created by 장가겸 on 10/2/23.
//

import UIKit

class TimerRingtoneTableViewController: UIViewController {
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

    let sounds: [String] = ["공상음", "녹차", "놀이시간", "물결"]
    var selectedSoundFromTimerViewController: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(TimerRingtoneTableViewCell.self, forCellReuseIdentifier: "TimerRingtoneTableViewCell")
        setupUI()
    }

    func setupUI() {
        view.backgroundColor = UIColor(named: "ModalColor")
        view.addSubview(tableView)
        view.addSubview(navigationBar)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

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
}

extension TimerRingtoneTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sounds.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimerRingtoneTableViewCell", for: indexPath) as? TimerRingtoneTableViewCell else { return UITableViewCell() }
        let soundName = sounds[indexPath.row]
        cell.soundLabel.text = soundName
        cell.accessoryType = .none
        cell.tintColor = .systemOrange

//        if(soundName == selectedSoundFromTimerViewController!){
//            cell.accessoryType = .checkmark
//        }

        return cell
    }
}

extension TimerRingtoneTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
