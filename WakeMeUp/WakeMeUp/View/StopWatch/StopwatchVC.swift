import Foundation
import UIKit

class StopwatchVC: UIViewController {
    
    // MARK: - 필요속성
    let stopwatchView = StopwatchView()
    let stopwatchManager = stopwatchData.shared
    var timer = Timer()
    var lapTimer = Timer()
    var lapTimes: [(String, String, String)] = []
    var timeHeader: (String, String, String)? {
        didSet {
            guard let timeHeader = timeHeader else { return }
            stopwatchView.minLabel.text = timeHeader.0
            stopwatchView.secLabel.text = timeHeader.1
            stopwatchView.nanoSecLabel.text = timeHeader.2
        }
    }
    var lapHeader: (String, String, String) = ("00","00","00")
    
    // MARK: - 생성자
    override func viewDidLoad() {
        super.viewDidLoad()
        view = stopwatchView
        setupAction()
        setupLapTable()
        stopwatchManager.readData()
        stopwatchManager.readLaps()
        firstSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - 랩 테이블
    func setupLapTable() {
        stopwatchView.lapTable.dataSource = self
        stopwatchView.lapTable.delegate = self
        stopwatchView.lapTable.register(StopwatchLapTimeCell.self, forCellReuseIdentifier: "StopwatchLapTimeCell")
        stopwatchView.lapTable.rowHeight = 50
    }
    
    // MARK: - 버튼액션
    func setupAction() {
        stopwatchView.startAndPuaseButton.addTarget(self, action: #selector(startAndPuaseButtonTapped), for: .touchUpInside)
        stopwatchView.lapAndResetButton.addTarget(self, action: #selector(lapAndResetButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - 시작, 정지 설정
    @objc func startAndPuaseButtonTapped() {
        stopwatchManager.firstRunning = true
        if stopwatchManager.isRunning {
            animationStop()
            setupNonWorkIcon()
            stopwatchStop()
            stopwatchManager.isRunning = false
        } else {
            animationStart()
            setupTime()
            setupLastTime()
            setupWorkIcon()
            stopwatchStart()
            stopwatchManager.isRunning = true
        }
        stopwatchManager.saveData()
    }
    
    func setupTime() {
        stopwatchManager.startTime = Date()
        stopwatchManager.startLap = Date()
    }
    
    func setupLastTime() {
        if let durationTime = stopwatchManager.durationTime {
            stopwatchManager.startTime = stopwatchManager.startTime?.addingTimeInterval(-(durationTime-0.025))
        }
        if let durationLapTime = stopwatchManager.lapDurationTime {
            stopwatchManager.startLap = stopwatchManager.startLap?.addingTimeInterval(-(durationLapTime-0.025))
        }
    }
    
    func animationStart() {
        stopwatchView.animateForegroundLayer()
        stopwatchView.animatePulseLayer()
    }
    
    func animationStop() {
        stopwatchView.stopwatchView.layer.sublayers?.forEach { [weak self] layer in
            layer.removeAllAnimations()
            guard let self = self else { return }
            if layer == self.stopwatchView.indicatorLayer {
                self.stopwatchView.indicatorLayer.removeFromSuperlayer()
            }
        }
    }
    
    func stopwatchStart() {
        timer = Timer.scheduledTimer(timeInterval: 1.0 / 60.0 , target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        lapTimer = Timer.scheduledTimer(timeInterval: 1.0 / 60.0 , target: self, selector: #selector(lapTimerCounter), userInfo: nil, repeats: true)
    }
    
    func stopwatchStop() {
        timer.invalidate()
        lapTimer.invalidate()
        stopwatchManager.durationTime = Date().timeIntervalSince(stopwatchManager.startTime!)
        stopwatchManager.lapDurationTime = Date().timeIntervalSince(stopwatchManager.startLap!)
    }
    
    func setupWorkIcon() {
        stopwatchView.startAndPuaseButton.setImage(MyButton.stopIcon, for: .normal)
        stopwatchView.startAndPuaseButton.setImage(MyButton.stopIcon, for: .highlighted)
        stopwatchView.lapAndResetButton.setImage(MyButton.lapIcon, for: .normal)
        stopwatchView.lapAndResetButton.setImage(MyButton.lapIcon, for: .highlighted)
        stopwatchView.lapAndResetButton.imageEdgeInsets.right = 0
    }
    
    func setupNonWorkIcon() {
        stopwatchView.startAndPuaseButton.setImage(MyButton.playIcon, for: .normal)
        stopwatchView.startAndPuaseButton.setImage(MyButton.playIcon, for: .highlighted)
        stopwatchView.lapAndResetButton.setImage(MyButton.resetIcon, for: .normal)
        stopwatchView.lapAndResetButton.setImage(MyButton.resetIcon, for: .highlighted)
        stopwatchView.lapAndResetButton.imageEdgeInsets.right = 3
    }
    // MARK: - 첫 세팅
    func firstSetup() {
        guard stopwatchManager.firstRunning == true else { return }
        if stopwatchManager.isRunning == true {
            animationStart()
            stopwatchStart()
            setupWorkIcon()
        } else {
            setupNonWorkIcon()
            timeHeader = calculationTime(stopwatchManager.timeInt)
            lapHeader = calculationTime(stopwatchManager.lapInt)
        }
        if stopwatchManager.lapInts.isEmpty != true {
            lapTimes = stopwatchManager.lapInts.map({ timeInt in
                calculationTime(timeInt)
            })
        }
    }
    
    func calculationTimeInt(_ time: Date) -> (Int) {
        let currentTime = Date().timeIntervalSince(time)
        let timeDouble = Double(currentTime) * 100
        let timeTrunc = trunc(timeDouble)
        let timeInt = Int(timeTrunc)
        return timeInt
    }
    
    func calculationTime(_ timeInt: Int) -> (String, String, String) {
        let time = secondsToHoursMinutesSeconds(seconds: timeInt)
        let makeTime = makeTimeString(minutes: time.0, seconds: time.1, tenMiliSecond: time.2)
        return makeTime
    }
    
    // MARK: - 타이머 로직
    @objc func timerCounter() {
        guard let myStartTime = stopwatchManager.startTime else { return }
        stopwatchManager.timeInt = calculationTimeInt(myStartTime)
        timeHeader = calculationTime(stopwatchManager.timeInt)
    }
    
    // MARK: - 랩 타이머 로직
    @objc func lapTimerCounter() {
        guard let myStartLap = stopwatchManager.startLap else { return }
        stopwatchManager.lapInt = calculationTimeInt(myStartLap)
        lapHeader = calculationTime(stopwatchManager.lapInt)
        stopwatchView.lapTable.reloadData()
    }
    
    // MARK: - 랩, 재설정 설정
    @objc func lapAndResetButtonTapped() {
        if stopwatchManager.isRunning {
            guard let myStartLap = stopwatchManager.startLap else { return }
            let timeInt = calculationTimeInt(myStartLap)
            let makeTime = calculationTime(timeInt)
            lapTimes.insert(makeTime, at: 0)
            stopwatchManager.lapInts.insert(timeInt, at: 0)
            stopwatchManager.lapCounter += 1
            stopwatchManager.startLap = Date()
            // 스톱워치 동작함수에 lapTable.reloadData가 들어있음
        } else {
            stopwatchManager.resetData()
            lapTimes = []
            timeHeader = ("00","00","00")
            lapHeader = ("00","00","00")
            stopwatchView.lapTable.reloadData()
        }
        stopwatchManager.saveData()
        stopwatchManager.saveLaps()
    }
    
    // MARK: - 진행시간 변환
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return ((seconds / 6000), ((seconds % 6000) / 100), ((seconds % 6000) % 100))
    }
    
    func makeTimeString(minutes: Int, seconds: Int, tenMiliSecond: Int) -> (String, String, String) {
        let time = (String(format: "%02d", minutes),
                    String(format: "%02d", seconds),
                    String(format: "%02d", tenMiliSecond))
        return time
    }
}

extension StopwatchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + lapTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StopwatchLapTimeCell", for: indexPath) as! StopwatchLapTimeCell
        
        if lapTimes.count == 0 {
            cell.lapCounter = 1
        } else {
            cell.lapCounter = stopwatchManager.lapCounter-indexPath.row
        }
        
        if indexPath.row == 0 {
            cell.minLabel.text = lapHeader.0
            cell.secLabel.text = lapHeader.1
            cell.nanoSecLabel.text = lapHeader.2
        } else {
            cell.minLabel.text = lapTimes[indexPath.row-1].0
            cell.secLabel.text = lapTimes[indexPath.row-1].1
            cell.nanoSecLabel.text = lapTimes[indexPath.row-1].2
        }
        cell.selectionStyle = .none
        return cell
    }
}
extension StopwatchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let lapCell = cell as? StopwatchLapTimeCell else { return }
        let timeLable = [lapCell.minLabel, lapCell.ColonLabel, lapCell.secLabel, lapCell.dotminLabel, lapCell.nanoSecLabel]
        lapCell.backgroundColor = .clear
        timeLable.forEach { $0.textColor = UIColor(hexCode: "595959") }
        
        if stopwatchManager.lapInts.count > 1 {
            guard let largeInterval = stopwatchManager.lapInts.max(),
                  let largeIndex = stopwatchManager.lapInts.firstIndex(of: largeInterval),
                  let shortInterval = stopwatchManager.lapInts.min(),
                  let shortIndex = stopwatchManager.lapInts.firstIndex(of: shortInterval)
            else { return }
            
            if indexPath.row == largeIndex+1 {
                timeLable.forEach { $0.textColor = MyColor.largeLapTime }
            }
            
            if indexPath.row == shortIndex+1 {
                timeLable.forEach { $0.textColor = MyColor.smallLapTime }
            }
        }
    }
}
