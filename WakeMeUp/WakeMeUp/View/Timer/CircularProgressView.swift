//
//  CircularProgressView.swift
//  BezierPatchTest
//
//  Created by 장가겸 on 9/27/23.
//

import UIKit
import UserNotifications

protocol CircularProgressViewDelegate {
    func timeupView()
}

class CircularProgressView: UIView {
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "360s"
        label.font = .systemFont(ofSize: 62)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var delegate: CircularProgressViewDelegate?
    let userNotificationCenter = UNUserNotificationCenter.current()
    var notificationId = ""
    var sound: String = "iPhone-Alarm-Original"
    private var lineWidth: CGFloat = 15.0 { didSet { updatePaths() } }
    private let animationName = "progressAnimation"
    private var timer: Timer?
    private var duration: CFTimeInterval?
    private var pauseTime: CFTimeInterval?
    private var fromValue: CFTimeInterval = 0.0
    private(set) var isRunning = false
    private var elapsed: CFTimeInterval = 0
    private var startTime: CFTimeInterval!
    private var remainingSeconds: TimeInterval?

    private let pulseLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = MyColor.timer1.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }()

    private let backgroundLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = MyColor.timer1.cgColor
        shapeLayer.fillColor = MyColor.stopWatchColor.cgColor
        return shapeLayer
    }()

    private let progressLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = MyColor.timer2.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        return shapeLayer
    }()

    private var stopSeconds: CFTimeInterval = 0

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        self.addSubview(self.timeLabel)
        NSLayoutConstraint.activate([
            self.timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
    }

    deinit {
        self.timer?.invalidate()
        self.timer = nil
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        updatePaths()
    }

    override public func prepareForInterfaceBuilder() {
        self.progressLayer.strokeEnd = 0
    }

    func start(duration: TimeInterval) {
        self.remainingSeconds = duration
        setTimeLabel(duration: duration)
        self.duration = duration
        self.pauseTime = duration
        self.reset()
        self.resume()
        animatePulseLayer()
    }

    func setTimeLabel(duration: TimeInterval) {
        guard let remainingSeconds = self.remainingSeconds else { return }
        if remainingSeconds < 3600 {
            self.timeLabel.text = String(format: "%02d:%02d", Int(duration).minute, Int(duration).seconds)
        } else {
            self.timeLabel.text = String(format: "%02d:%02d:%02d", Int(duration).hour, Int(duration).minute, Int(duration).seconds)
            self.timeLabel.font = .systemFont(ofSize: 58)
        }
    }

    func stop() {
        self.timer?.invalidate()
        self.progressLayer.removeAnimation(forKey: self.animationName)
    }

    func pause() {
        self.timer?.invalidate()
        guard
            let presentation = progressLayer.presentation()
        else {
            return
        }
        var date = Date()
        self.elapsed += CACurrentMediaTime() - self.startTime
        var a: CFTimeInterval = CACurrentMediaTime() - self.startTime
        self.fromValue += a
        self.pauseTime! -= self.elapsed
        self.remainingSeconds = self.pauseTime!
        self.setTimeLabel(duration: self.remainingSeconds!)
        self.progressLayer.strokeEnd = presentation.strokeEnd
        self.progressLayer.removeAnimation(forKey: self.animationName)
        self.pulseLayer.removeAnimation(forKey: "pulseAnimation")
    }

    func resume() {
        guard !self.isRunning else { return }
        self.isRunning = true
        self.startTime = CACurrentMediaTime()
        var date = Date()
        self.elapsed = 0
        self.timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { [weak self] _ in
                guard let self = self else { return
                }
                let remainingSeconds = self.pauseTime! - round(abs(date.timeIntervalSinceNow))
                self.setTimeLabel(duration: remainingSeconds)
                guard remainingSeconds >= 0 else {
                    self.sendNotification()
                    self.stop()
                    self.delegate?.timeupView()
                    return
                }
            }
        )
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = self.fromValue / self.duration!
        animation.toValue = 1
        animation.duration = self.duration! - self.fromValue
        animation.delegate = self
        self.progressLayer.strokeEnd = 1
        self.progressLayer.add(animation, forKey: self.animationName)
        animatePulseLayer()
    }

    func reset() {
        self.isRunning = false
        self.progressLayer.removeAnimation(forKey: self.animationName)
        self.progressLayer.strokeEnd = 0
        self.elapsed = 0
        self.fromValue = 0
    }
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)

        self.userNotificationCenter.requestAuthorization(options: authOptions) { _, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }

    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "시계"
        notificationContent.body = "타이머"
        notificationContent.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(self.sound).mp3"))
        notificationContent.badge = 1
        self.notificationId = "Timer"
        let request = UNNotificationRequest(identifier: "Timer",
                                            content: notificationContent, trigger: nil)

        self.userNotificationCenter.add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }

    func removeNotification(identifier: String) {
        let notification = UNUserNotificationCenter.current()
        notification.removePendingNotificationRequests(withIdentifiers: [identifier])
        print(identifier)
    }
}

extension Int {
    var hour: Int {
        self / 3600
    }

    var minute: Int {
        (self % 3600) / 60
    }

    var seconds: Int {
        self % 60
    }
}

extension CircularProgressView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.isRunning = false
    }
}

extension CircularProgressView {
    func configure() {
        layer.addSublayer(self.pulseLayer)
        layer.addSublayer(self.backgroundLayer)
        layer.addSublayer(self.progressLayer)
    }

    func updatePaths() {
        self.pulseLayer.frame = self.bounds
        self.backgroundLayer.frame = self.bounds
        self.progressLayer.frame = self.bounds

        let startAngle = CGFloat(-Double.pi / 2)
        let endAngle = CGFloat(3 * Double.pi / 2)

        let centerPoint = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        let circularPath = UIBezierPath(arcCenter: centerPoint,
                                        radius: self.bounds.height * 1.3,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: true)

        self.backgroundLayer.lineWidth = self.lineWidth
        self.progressLayer.lineWidth = self.lineWidth - 7
        self.pulseLayer.lineWidth = self.lineWidth

        self.pulseLayer.path = circularPath.cgPath
        self.backgroundLayer.path = circularPath.cgPath
        self.progressLayer.path = circularPath.cgPath
    }

    func animatePulseLayer() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.fromValue = 1
        pulseAnimation.toValue = 1.2
        pulseAnimation.repeatCount = HUGE

        let pulseOpacityAnimation = CABasicAnimation(keyPath: "opacity")
        pulseOpacityAnimation.fromValue = 1.0
        pulseOpacityAnimation.toValue = 0.0
        pulseOpacityAnimation.repeatCount = HUGE

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [pulseAnimation, pulseOpacityAnimation]
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animationGroup.duration = 1.3
        animationGroup.repeatCount = Float.infinity

        self.pulseLayer.add(animationGroup, forKey: "pulseAnimation")
    }
}
