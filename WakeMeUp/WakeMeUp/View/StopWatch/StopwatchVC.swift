import Foundation
import UIKit

class StopwatchVC: UIViewController {
    
// MARK: - 필요속성
    var timer = Timer()
    let stopwatchView = StopwatchView()
    var isRunning = false
    var testDate:Date?

// MARK: - 생성자
    override func viewDidLoad() {
        super.viewDidLoad()
        view = stopwatchView
        setupAction()
    }
    
// MARK: - 로직설정
    // MARK: - 버튼액션 추가
    func setupAction() {
        stopwatchView.startAndPuaseButton.addTarget(self, action: #selector(startAndPuaseButtonTapped), for: .touchUpInside)
        stopwatchView.lapAndResetButton.addTarget(self, action: #selector(lapAndResetButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - 시작, 정지 설정
    @objc func startAndPuaseButtonTapped() {
        if !isRunning {
            stopwatchView.animateForegroundLayer()
            stopwatchView.animatePulseLayer()
            stopwatchView.startAndPuaseButton.setImage(MyButton.stopIcon, for: .normal)
            stopwatchView.lapAndResetButton.setImage(MyButton.lapIcon, for: .normal)
            testDate = Date()
            timer = Timer.scheduledTimer(timeInterval: 1.0 / 60.0 , target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
            isRunning = true
        } else {
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
            isRunning = false
        }
    }
    
    // MARK: - 타이머 로직
    @objc func timerCounter() {
        guard let myTestDate = testDate else { return }
        let currentTime = Date().timeIntervalSince(myTestDate)
        let timeDouble = Double(currentTime) * 100
        let timeTrunc = trunc(timeDouble)
        let timeInt = Int(timeTrunc)
        let time = secondsToHoursMinutesSeconds(seconds: timeInt)
        makeTimeString(minutes: time.0, seconds: time.1, tenMiliSecond: time.2)
    }
    
    // MARK: - 랩, 재설정 설정
    @objc func lapAndResetButtonTapped() {
        if isRunning {
            
        }
    }
    
    // MARK: - 진행시간 변환
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return ((seconds / 6000), ((seconds % 6000) / 100), ((seconds % 6000) % 100))
    }
    
    func makeTimeString(minutes: Int, seconds: Int, tenMiliSecond: Int) {
        stopwatchView.minLabel.text = String(format: "%02d", minutes)
        stopwatchView.secLabel.text = String(format: "%02d", seconds)
        stopwatchView.nanoSecLabel.text = String(format: "%02d", tenMiliSecond)
    }
    
}
