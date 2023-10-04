//
//  CircularProgressView.swift
//  BezierPatchTest
//
//  Created by 장가겸 on 9/27/23.
//

import UIKit

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
    private let backgroundLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let animationName = "progressAnimation"
    private var timer: Timer?
    private var remainingSeconds: TimeInterval? {
        didSet {
            guard let remainingSeconds = self.remainingSeconds else { return }
            if remainingSeconds < 3600 {
                self.timeLabel.text = String(format: "%02d:%02d", Int(remainingSeconds).minute, Int(remainingSeconds).seconds)
            } else {
                self.timeLabel.text = String(format: "%02d:%02d:%02d", Int(remainingSeconds).hour, Int(remainingSeconds).minute, Int(remainingSeconds).seconds)
                self.timeLabel.font = .systemFont(ofSize: 58)
            }
        }
    }

    private var circularPath: UIBezierPath {
        UIBezierPath(
            arcCenter: CGPoint(x: self.frame.size.width / 2.0, y: self.frame.size.height / 2.0),
            radius: 120,
            startAngle: -CGFloat.pi / 360 * CGFloat.pi - CGFloat.pi / 2,
            endAngle: CGFloat(-Double.pi / 2),
            clockwise: false
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundLayer.path = self.circularPath.cgPath
        self.backgroundLayer.fillColor = UIColor(red: 0.72, green: 0.75, blue: 1.00, alpha: 1.00).cgColor
        self.backgroundLayer.lineCap = .round
        self.backgroundLayer.lineWidth = 10.0
        self.backgroundLayer.strokeEnd = 1.0 // 0 ~1사이의 값 (0이면 안채워져 있고, 1이면 다 채워져 있는 것)
        self.backgroundLayer.strokeColor = UIColor(red: 1.00, green: 0.84, blue: 1.00, alpha: 1.00).cgColor
        self.layer.addSublayer(self.backgroundLayer)

        self.progressLayer.path = self.circularPath.cgPath
        self.progressLayer.fillColor = UIColor(red: 0.72, green: 0.75, blue: 1.00, alpha: 1.00).cgColor
        self.progressLayer.lineCap = .round
        self.progressLayer.lineWidth = 10.0
        self.progressLayer.strokeEnd = 0
        self.progressLayer.strokeColor = UIColor(red: 1.00, green: 0.84, blue: 1.00, alpha: 1.00).cgColor
        self.layer.addSublayer(self.progressLayer)
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

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.backgroundLayer.path = self.circularPath.cgPath
        self.progressLayer.path = self.circularPath.cgPath
    }

    func start(duration: TimeInterval) {
        self.remainingSeconds = duration

        // timer
        self.timer?.invalidate()
        let startDate = Date()
        self.timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { [weak self] _ in
                let remainingSeconds = duration - round(abs(startDate.timeIntervalSinceNow))
                guard remainingSeconds >= 1 else {
                    self?.stop()
                    self?.delegate?.timeupView()
                    return
                }
                self?.remainingSeconds = remainingSeconds
            }
        )
        // animation
        self.progressLayer.removeAnimation(forKey: self.animationName)
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        strokeStart
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .removed
        circularProgressAnimation.isRemovedOnCompletion = false
        self.progressLayer.add(circularProgressAnimation, forKey: self.animationName)
    }

    func stop() {
        self.timer?.invalidate()
        self.progressLayer.removeAnimation(forKey: self.animationName)
//        self.remainingSeconds = 0
    }

    func pause() {
        self.timer?.invalidate()
        print(self.remainingSeconds)
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
