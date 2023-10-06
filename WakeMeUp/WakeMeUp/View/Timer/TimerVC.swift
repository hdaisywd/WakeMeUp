
import Foundation
import UIKit
import UserNotifications

class TimerVC: UIViewController {
    lazy var circularProgressView = CircularProgressView()
    let userNotificationCenter = UNUserNotificationCenter.current()
    var notificationId = ""
    var alarmSound: String? { didSet { ringtoneLabel.text = alarmSound } }
    
    let timeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var timePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor(red: 0.72, green: 0.75, blue: 1.00, alpha: 1.00)
        picker.delegate = self
        picker.dataSource = self
        picker.isHidden = false
        picker.layer.masksToBounds = true
        picker.layer.cornerRadius = 20
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작", for: .normal)
        button.backgroundColor = UIColor(red: 0.72, green: 0.75, blue: 1.00, alpha: 1.00)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 50
        button.isHidden = false
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.blue, for: .highlighted)
        button.addTarget(self, action: #selector(start), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("일시 정지", for: .normal)
        button.backgroundColor = UIColor(red: 0.72, green: 0.75, blue: 1.00, alpha: 1.00)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 50
        button.isHidden = true
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.blue, for: .highlighted)
        button.addTarget(self, action: #selector(pauseAndResumeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.backgroundColor = UIColor(red: 0.72, green: 0.75, blue: 1.00, alpha: 1.00)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 50
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.blue, for: .highlighted)
        button.addTarget(self, action: #selector(stop), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let ringtoneLabel: UILabel = {
        let label = UILabel()
        label.text = "기본음"
        return label
    }()
    
    private let ringtoneTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "\t 벨소리 종료 시 >"
        return label
    }()
    
    private let ringtoneSV: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.backgroundColor = UIColor(red: 0.72, green: 0.75, blue: 1.00, alpha: 1.00)
        stack.layer.masksToBounds = true
        stack.layer.cornerRadius = 10
        stack.spacing = 10
        stack.distribution = .fillProportionally
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alarmSound = "기본음"
        self.circularProgressView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.circularProgressView)
        self.circularProgressView.isHidden = true
        self.ringtoneSV.addArrangedSubview(self.ringtoneTitleLabel)
        self.ringtoneSV.addArrangedSubview(self.ringtoneLabel)
        let tap = UITapGestureRecognizer(target: self, action: #selector(ringtoneLabelTapped))
        ringtoneSV.addGestureRecognizer(tap)
        self.view.addSubview(self.timePicker)
        self.view.addSubview(self.startButton)
        self.view.addSubview(self.stopButton)
        self.view.addSubview(self.cancelButton)
        self.view.addSubview(self.ringtoneSV)
        self.timePicker.setPickerLabelsWith(labels: ["시간", "분", "초"])
        circularProgressView.delegate = self
        
        NSLayoutConstraint.activate([
            self.circularProgressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height / 6),
            self.circularProgressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            self.circularProgressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            self.circularProgressView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 7),
        ])
        NSLayoutConstraint.activate([
            self.timePicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height / 6),
            self.timePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            self.timePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            self.timePicker.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 7),
        ])
        NSLayoutConstraint.activate([
            self.cancelButton.topAnchor.constraint(equalTo: self.circularProgressView.bottomAnchor, constant: UIScreen.main.bounds.height / 12),
            self.cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            self.cancelButton.heightAnchor.constraint(equalToConstant: 100),
            self.cancelButton.widthAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            self.startButton.topAnchor.constraint(equalTo: self.circularProgressView.bottomAnchor, constant: UIScreen.main.bounds.height / 12),
            self.startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            self.startButton.heightAnchor.constraint(equalToConstant: 100),
            self.startButton.widthAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            self.stopButton.topAnchor.constraint(equalTo: self.circularProgressView.bottomAnchor, constant: UIScreen.main.bounds.height / 12),
            self.stopButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            self.stopButton.heightAnchor.constraint(equalToConstant: 100),
            self.stopButton.widthAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            self.ringtoneSV.topAnchor.constraint(equalTo: self.startButton.bottomAnchor, constant: 50),
            self.ringtoneSV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            self.ringtoneSV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            self.ringtoneSV.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    var paused: Bool = false{
        didSet{
            if(paused){
                stopButton.backgroundColor = UIColor(red: 0.72, green: 0.75, blue: 1.00, alpha: 1.00)
                stopButton.setTitleColor(.blue, for: .highlighted)
                stopButton.setTitle("재개", for: .normal)
            }else{
                stopButton.backgroundColor = UIColor(red: 0.72, green: 0.75, blue: 1.00, alpha: 1.00)
                stopButton.setTitleColor(.blue, for: .highlighted)
                stopButton.setTitle("일시 정지", for: .normal)
            }
        }
    }
    
    @objc func start() {
        if getAlertTimeWithTimeInterval() != 0.0 {
            self.circularProgressView.isHidden = false
            self.timePicker.isHidden = true
            self.startButton.isHidden = true
            self.stopButton.isHidden = false
            self.circularProgressView.start(duration: self.getAlertTimeWithTimeInterval())
            self.circularProgressView.alpha = 0
            self.timePicker.alpha = 1
            
            UIView.animate(withDuration: 0.6) { [weak self] in
                self?.timePicker.alpha = 0
                self?.circularProgressView.alpha = 1
            }
        }
    }
    
    @objc func stop() {
        if getAlertTimeWithTimeInterval() != 0.0 {
            self.circularProgressView.stop()
            self.circularProgressView.isHidden = true
            self.timePicker.isHidden = false
            self.startButton.isHidden = false
            self.stopButton.isHidden = true
            paused = false
            self.circularProgressView.alpha = 1
            self.timePicker.alpha = 0
            UIView.animate(withDuration: 0.6) { [weak self] in
                self?.timePicker.alpha = 1
                self?.circularProgressView.alpha = 0
            }
            self.timePicker.selectRow(0, inComponent: 0, animated: false)
            self.timePicker.selectRow(0, inComponent: 1, animated: false)
            self.timePicker.selectRow(0, inComponent: 2, animated: false)
        }
    }
    
    @objc func pauseAndResumeButtonTapped() {
        if paused == false{
            circularProgressView.pause()
            paused = true
        } else {
            circularProgressView.resume()
            paused = false
        }
    }
    
    @objc func pause() {
        circularProgressView.pause()
    }
    
    func getAlertTimeWithTimeInterval() -> TimeInterval {
        let hour = self.timePicker.selectedRow(inComponent: 0)
        let minute = self.timePicker.selectedRow(inComponent: 1)
        let second = self.timePicker.selectedRow(inComponent: 2)
        return TimeInterval(hour * 3600 + minute * 60 + second)
    }
    
    var time: [[Int]] {
        return self.setTime()
    }
    
    func setTime() -> [[Int]] {
        var hour: [Int] = []
        var minuteAndSecond: [Int] = []
        
        for i in 0 ... 23 {
            hour.append(i)
        }
        
        for i in 0 ... 59 {
            minuteAndSecond.append(i)
        }
        
        return [hour, minuteAndSecond, minuteAndSecond]
    }
    
    @objc func ringtoneLabelTapped(_ sender: UITapGestureRecognizer) {
        let vc = TimerRingtoneTableViewController()
        vc.Delegate = self
        vc.selectedSoundFromTimerViewController = alarmSound
        vc.modalPresentationStyle = .popover
        present(vc, animated: true)
        guard let alarmSound = alarmSound else { return alarmSound = "기본음" }
    }
}

extension TimerVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(self.time[component][row])"
        case 1:
            return "\(self.time[component][row])"
        case 2:
            return "\(self.time[component][row])"
        default:
            return nil
        }
    }
}

extension TimerVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.time[component].count
    }
}

extension TimerVC: CircularProgressViewDelegate {
    func timeupView() {
        circularProgressView.isHidden = true
        timePicker.isHidden = false
        startButton.isHidden = false
        stopButton.isHidden = true
        timePicker.alpha = 1
        circularProgressView.alpha = 0
    }
}

extension UIPickerView {
    func setPickerLabelsWith(labels: [String]) {
        let columCount = labels.count
        let fontSize: CGFloat = UIFont.boldSystemFont(ofSize: 13).pointSize + 20

        var labelList: [UILabel] = []
        for index in 0 ..< columCount {
            let label = UILabel()
            label.text = labels[index]
            label.font = .boldSystemFont(ofSize: 13)
            label.textColor = .black
            label.sizeToFit()
            labelList.append(label)
        }

        let pickerWidth: CGFloat = frame.width
        let labelY: CGFloat = (frame.size.height / 2) - (fontSize * 1.9)
        print(labelY)

        for (index, label) in labelList.enumerated() {
            let labelX: CGFloat = (pickerWidth / CGFloat(columCount)) * CGFloat(index + 1) + (fontSize / 2)
            label.frame = CGRect(x: labelX, y: labelY, width: fontSize, height: fontSize)
            addSubview(label)
        }
    }
}

extension TimerVC: TestDelegate {
    func test(music: String, alarmSound: String) {
        circularProgressView.sound = music
        self.alarmSound = alarmSound
    }
}
