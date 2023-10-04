import Foundation
import UIKit

class StopwatchVC: UIViewController {
    
    // MARK: - 필요속성
    let stopwatchView = StopwatchView()
    
    var isRunning = false
    
    var timer = Timer()
    var startTime:Date?
    var durationTime:TimeInterval?
    
    var lapTimer = Timer()
    var startLap:Date?
    var lapDurationTime:TimeInterval?
    var lapHeader: (String, String, String) = ("00","00","00")
    var lapTimes: [(String, String, String)] = []
    var lapInts: [Int] = []
    var lapNumber: Int = 1
    
    // MARK: - 생성자
    override func viewDidLoad() {
        super.viewDidLoad()
        view = stopwatchView
        setupAction()
        setupLapTable()
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
        if isRunning {
            stopwatchView.stopwatchView.layer.sublayers?.forEach { [weak self] layer in
                layer.removeAllAnimations()
                guard let self = self else { return }
                if layer == self.stopwatchView.indicatorLayer {
                    self.stopwatchView.indicatorLayer.removeFromSuperlayer()
                }
            }
            stopwatchView.startAndPuaseButton.setImage(MyButton.playIcon, for: .normal)
            stopwatchView.lapAndResetButton.setImage(MyButton.resetIcon, for: .normal)
            timer.invalidate()
            lapTimer.invalidate()
            durationTime = Date().timeIntervalSince(startTime!)
            lapDurationTime = Date().timeIntervalSince(startLap!)
            startTime = nil
            //            lapDate = nil
            // 정지를 누른 시점에서 현재까지 흘러간 시간 : (Date().timeIntervalSince(startTime!)
            // 다시 시작을 누르면 시작한 시간에 (Date().timeIntervalSince(startTime!)를 빼주면 된다.
            // 그 다음 시작을 누르면 다시 시작을 누른 시점에서 이전에 흘러간 시간을 빼고 계산되기 때문에 시간이 일치한다.
            isRunning = false
        } else {
            startLap = Date()
            startTime = Date()
            if let myDurationTime = durationTime {
                startTime = startTime?.addingTimeInterval(-(myDurationTime-0.025))
                // 0.025를 빼주는 이유? 다시 셋팅이되기까지 약간의 딜레이가 발생
                // 0.025를 빼주지 않으면 멈춘 시간에서 다시 시작할 때 0.02초정도 차이발생
                // 그래서 다시 시작하는 시간에서 0.025정도의 준비시간을 주는 것
            }
            
            if let myLapDurationTime = lapDurationTime {
                startLap = startLap?.addingTimeInterval(-(myLapDurationTime-0.025))
            }
            stopwatchView.animateForegroundLayer()
            stopwatchView.animatePulseLayer()
            stopwatchView.startAndPuaseButton.setImage(MyButton.stopIcon, for: .normal)
            stopwatchView.lapAndResetButton.setImage(MyButton.lapIcon, for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1.0 / 60.0 , target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            lapTimer = Timer.scheduledTimer(timeInterval: 1.0 / 60.0 , target: self, selector: #selector(lapTimerCounter), userInfo: nil, repeats: true)
            isRunning = true
        }
    }
    
    // MARK: - 타이머 로직
    @objc func timerCounter() {
        guard let myStartTime = startTime else { return }
        let currentTime = Date().timeIntervalSince(myStartTime)
        let timeDouble = Double(currentTime) * 100
        let timeTrunc = trunc(timeDouble)
        let timeInt = Int(timeTrunc)
        let time = secondsToHoursMinutesSeconds(seconds: timeInt)
        let makeTime = makeTimeString(minutes: time.0, seconds: time.1, tenMiliSecond: time.2)
        
        stopwatchView.minLabel.text = makeTime.0
        stopwatchView.secLabel.text = makeTime.1
        stopwatchView.nanoSecLabel.text = makeTime.2
        stopwatchView.lapTable.reloadData()
    }
    
    // MARK: - 랩 타이머 로직
    @objc func lapTimerCounter() {
        guard let myStartLap = startLap else { return }
        let currentTime = Date().timeIntervalSince(myStartLap)
        let timeDouble = Double(currentTime) * 100
        let timeTrunc = trunc(timeDouble)
        let timeInt = Int(timeTrunc)
        let time = secondsToHoursMinutesSeconds(seconds: timeInt)
        let makeTime = makeTimeString(minutes: time.0, seconds: time.1, tenMiliSecond: time.2)
        lapHeader = makeTime
    }
    
    // MARK: - 랩, 재설정 설정
    @objc func lapAndResetButtonTapped() {
        if isRunning {
            guard let myStartTime = startLap else { return }
            let currentTime = Date().timeIntervalSince(myStartTime)
            let timeDouble = Double(currentTime) * 100
            let timeTrunc = trunc(timeDouble)
            let timeInt = Int(timeTrunc)
            let time = secondsToHoursMinutesSeconds(seconds: timeInt)
            let makeTime = makeTimeString(minutes: time.0, seconds: time.1, tenMiliSecond: time.2)
            lapInts.insert(timeInt, at: 0)
            lapTimes.insert(makeTime, at: 0)
            lapNumber += 1
            startLap = Date()
        } else {
            lapDurationTime = nil
            durationTime = nil
            lapTimes = []
            lapInts = []
            lapNumber = 1
            stopwatchView.lapTable.reloadData()
            let makeTime = makeTimeString(minutes: 0, seconds: 0, tenMiliSecond: 0)
            stopwatchView.minLabel.text = makeTime.0
            stopwatchView.secLabel.text = makeTime.1
            stopwatchView.nanoSecLabel.text = makeTime.2
            lapHeader = ("00","00","00")
        }
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
            cell.lapNumber = 1
        } else {
            cell.lapNumber = lapNumber-indexPath.row
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
        
        if lapInts.count > 1 {
            guard let largeInterval = lapInts.max(),
                  let largeIndex = lapInts.firstIndex(of: largeInterval),
                  let shortInterval = lapInts.min(),
                  let shortIndex = lapInts.firstIndex(of: shortInterval)
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
