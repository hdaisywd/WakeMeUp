import UIKit

class StopwatchView: UIView {
    
    // MARK: - 화면비율에 맞춰서 시계글씨 크기조절
    private let textSizeOfwidthSize: CGFloat = {
        switch UIScreen.main.bounds.width {
        case 400...:
            return 57
        case 380...:
            return 53
        case 370...:
            return 43
        default:
            return 30
        }
    }()
    
    private let spaceOfwidthSize: CGFloat = {
        switch UIScreen.main.bounds.height {
        case 800...:
            return -6
        case 600...:
            return 0
        default:
            return 0
        }
    }()
    
    private let watchDiameter = UIScreen.main.bounds.height/3
    private let buttonDiameter = UIScreen.main.bounds.width/6
    
    // MARK: - stopwatchView
    let stopwatchView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - 바운스 레이어, 외곽 레이어, 인디게이터 레이어
    private let pulseLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 15
        layer.strokeColor = MyColor.pulseColor.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    private let backgroundLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 15
        layer.strokeColor = MyColor.pulseColor.cgColor
        layer.fillColor = MyColor.stopWatchColor.cgColor
        return layer
    }()
    
    let indicatorLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = MyColor.indicatorColor.cgColor
        layer.lineWidth = 8
        layer.fillColor = UIColor.clear.cgColor
        layer.lineCap = .round
        return layer
    }()
    
    // MARK: - 진행시간 텍스트, 시간단위 텍스트
    
    lazy var minLabel = UILabel.makeTimeLabel("00", .center, textSizeOfwidthSize, .white)
    lazy var secLabel = UILabel.makeTimeLabel("00", .center, textSizeOfwidthSize, .white)
    lazy var nanoSecLabel = UILabel.makeTimeLabel("00", .center, textSizeOfwidthSize, .white)
    private lazy var dotminLabel = UILabel.makeTimeLabel(".", .center, textSizeOfwidthSize, .white)
    private lazy var ColonLabel: UILabel = {
        let label = UILabel.makeTimeLabel(":", .center, textSizeOfwidthSize, .white)
        let attributedText = NSMutableAttributedString(string: ":")
        let baselineOffset: CGFloat = 3
        attributedText.addAttribute(NSAttributedString.Key.baselineOffset, value: baselineOffset, range: NSRange(location: 0, length: attributedText.length))
        label.attributedText = attributedText
        return label
    }()
    
    lazy var timeLabelSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [minLabel, ColonLabel, secLabel, dotminLabel, nanoSecLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .clear
        sv.spacing = spaceOfwidthSize
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    private lazy var hourTitleLabel = UILabel.makeTimeTitleLabel("min", 15)
    private lazy var minTitleLabel = UILabel.makeTimeTitleLabel("sec", 15)
    private lazy var secondTitleLabel = UILabel.makeTimeTitleLabel("10 ms", 15)
    
    private lazy var timeTitleLabelSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [hourTitleLabel, minTitleLabel, secondTitleLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .clear
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .fill
        return sv
    }()
    
    // MARK: - 동작버튼
    let startAndPuaseButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setImage(MyButton.playIcon, for: .normal)
        bt.setBackgroundImage(UIImage.image(withColor: MyColor.stopWatchColor), for: .highlighted)
        bt.tintColor = .white
        return bt
    }()
    
    let lapAndResetButton: UIButton = {
        let bt = UIButton()
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.setImage(MyButton.resetIcon, for: .normal)
        bt.setBackgroundImage(UIImage.image(withColor: MyColor.stopWatchColor), for: .highlighted)
        bt.imageEdgeInsets.right = 3
        bt.tintColor = .white
        
        return bt
    }()
    
    // MARK: - 랩 테이블
    let lapTable: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.indicatorStyle = .black
        table.bounces = false
        return table
    }()
    
    // MARK: - 생성자
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        print(UIScreen.main.bounds.height)
        autoLayout()
        loadLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 뷰 그리기 (layer 및 버튼 바운드 처리)
    override func draw(_ rect: CGRect) {
        setupButton()
        super.layoutSubviews()
        
        self.pulseLayer.frame = self.stopwatchView.bounds
        self.backgroundLayer.frame = self.stopwatchView.bounds
        self.indicatorLayer.frame = self.stopwatchView.bounds
        
        let startAngle = CGFloat(-Double.pi / 2)
        let endAngle = CGFloat(3 * Double.pi / 2)
        
        let centerPoint = CGPoint(x: self.stopwatchView.bounds.width / 2, y: self.stopwatchView.bounds.height / 2)
        let circularPath = UIBezierPath(arcCenter: centerPoint,
                                        radius: self.stopwatchView.bounds.height/2,
                                        startAngle: startAngle,
                                        endAngle: endAngle,
                                        clockwise: true)
        
        self.pulseLayer.path = circularPath.cgPath
        self.backgroundLayer.path = circularPath.cgPath
        self.indicatorLayer.path = circularPath.cgPath
    }
    
    private func setupButton() {
        let buttons = [startAndPuaseButton, lapAndResetButton]
        buttons.forEach { bt in
            bt.clipsToBounds = true
            bt.layer.cornerRadius = bt.frame.height/2
            bt.backgroundColor = MyColor.pulseColor
        }
    }
    
    // MARK: - 바운스 레이어, 외곽 레이어 추가하기 (인디게이터 레이어 처음부터 표시X)
    private func loadLayers() {
        self.stopwatchView.layer.addSublayer(self.pulseLayer)
        self.stopwatchView.layer.addSublayer(self.backgroundLayer)
    }
    
    // MARK: - 인디게이터 애니메이션
    func animateForegroundLayer() {
        let totalAnimation: CGFloat = 1.5
        let subAnimationDuration: CGFloat = 1.125
        let startAnimationDelay: CGFloat = totalAnimation - subAnimationDuration
        
        let startAnimation = CABasicAnimation(keyPath: "strokeStart")
        startAnimation.beginTime = startAnimationDelay
        startAnimation.fromValue = 0
        startAnimation.toValue = 1
        startAnimation.duration = subAnimationDuration
        startAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let endAnimation = CABasicAnimation(keyPath: "strokeEnd")
        endAnimation.beginTime = 0
        endAnimation.fromValue = 0
        endAnimation.toValue = 1
        endAnimation.duration = subAnimationDuration
        endAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [startAnimation, endAnimation]
        animationGroup.duration = 1.5
        animationGroup.repeatCount = .infinity
        self.indicatorLayer.add(animationGroup, forKey: "Loading_Stroke")
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = CGFloat.pi * 2
        rotationAnimation.duration = 5
        rotationAnimation.repeatCount = .infinity
        self.indicatorLayer.add(rotationAnimation, forKey: "Loading_Rotation")
        self.stopwatchView.layer.addSublayer(self.indicatorLayer)
    }
    
    // MARK: - 바운스 애니메이션
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
        
        pulseLayer.add(animationGroup, forKey: "pulseAnimation")
    }
    
    
    // MARK: - 레이아웃 설정
    private func autoLayout() {
        addSubview(stopwatchView)
        addSubview(startAndPuaseButton)
        addSubview(lapAndResetButton)
        addSubview(timeLabelSV)
        addSubview(timeTitleLabelSV)
        addSubview(lapTable)
        
        NSLayoutConstraint.activate([
            
            stopwatchView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            stopwatchView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stopwatchView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stopwatchView.heightAnchor.constraint(equalToConstant: watchDiameter),
            
            timeLabelSV.centerXAnchor.constraint(equalTo: stopwatchView.centerXAnchor),
            timeLabelSV.centerYAnchor.constraint(equalTo: stopwatchView.centerYAnchor),
            
            minLabel.widthAnchor.constraint(equalToConstant: watchDiameter/3 - 18),
            secLabel.widthAnchor.constraint(equalToConstant: watchDiameter/3 - 18),
            nanoSecLabel.widthAnchor.constraint(equalToConstant: watchDiameter/3 - 18),
            
            timeTitleLabelSV.topAnchor.constraint(equalTo: timeLabelSV.bottomAnchor),
            timeTitleLabelSV.centerXAnchor.constraint(equalTo: timeLabelSV.centerXAnchor),
            timeTitleLabelSV.leadingAnchor.constraint(equalTo: timeLabelSV.leadingAnchor),
            timeTitleLabelSV.trailingAnchor.constraint(equalTo: timeLabelSV.trailingAnchor),
            
            startAndPuaseButton.topAnchor.constraint(equalTo: stopwatchView.bottomAnchor, constant: -20),
            startAndPuaseButton.trailingAnchor.constraint(equalTo: stopwatchView.trailingAnchor, constant: -25),
            startAndPuaseButton.widthAnchor.constraint(equalToConstant: buttonDiameter),
            startAndPuaseButton.heightAnchor.constraint(equalToConstant: buttonDiameter),
            
            lapAndResetButton.topAnchor.constraint(equalTo: stopwatchView.bottomAnchor, constant: -20),
            lapAndResetButton.leadingAnchor.constraint(equalTo: stopwatchView.leadingAnchor, constant: 25),
            lapAndResetButton.widthAnchor.constraint(equalToConstant: buttonDiameter),
            lapAndResetButton.heightAnchor.constraint(equalToConstant: buttonDiameter),
            
            lapTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            lapTable.trailingAnchor.constraint(equalTo: trailingAnchor),
            lapTable.topAnchor.constraint(equalTo: startAndPuaseButton.bottomAnchor, constant: 10),
            lapTable.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
