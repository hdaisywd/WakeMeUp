//
//  StopwatchLapTimeCell.swift
//  WakeMeUp
//
//  Created by Macbook on 10/4/23.
//

import UIKit

class StopwatchLapTimeCell: UITableViewCell {

    var lapNumber: Int? {
        didSet {
            guard let lapNumber = lapNumber else { return }
            lapLabel.text = "Lap \(lapNumber)"
        }
    }
    
    let lapLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hexCode: "595959")
        label.font = .boldSystemFont(ofSize: 20)//.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var minLabel = UILabel.makeTimeLabel("00", .center, 20, .black)
    lazy var secLabel = UILabel.makeTimeLabel("00", .center, 20, .black)
    lazy var nanoSecLabel = UILabel.makeTimeLabel("00", .left, 20, .black)
    lazy var dotminLabel = UILabel.makeTimeLabel(".", .center, 20, .black)
    lazy var ColonLabel = UILabel.makeTimeLabel(":", .center, 20, .black)
    
    lazy var timeLabelSV: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [minLabel, ColonLabel, secLabel, dotminLabel, nanoSecLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .clear
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        autoLayout()
        setupFont()
//        setupRadius()
//        backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func autoLayout() {
        contentView.addSubview(lapLabel)
        contentView.addSubview(timeLabelSV)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            lapLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            lapLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
            timeLabelSV.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabelSV.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            minLabel.widthAnchor.constraint(equalToConstant: 27),
            secLabel.widthAnchor.constraint(equalToConstant: 27),
            nanoSecLabel.widthAnchor.constraint(equalToConstant: 27),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func setupFont() {
        lazy var timeLabel = [minLabel,secLabel,nanoSecLabel,dotminLabel,ColonLabel]
        timeLabel.forEach { $0.font = .boldSystemFont(ofSize: 20)}
    }
    
//    func setupRadius() {
//        contentView.clipsToBounds = true
//        contentView.layer.cornerRadius = 10
//    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        let horizontalSpacing: CGFloat = 20 // 좌우 간격
//        let verticalSpacing: CGFloat = 5    // 상하 간격
//        
//        // 셀의 컨텐츠 뷰 프레임을 가져옵니다.
//        var contentViewFrame = contentView.frame
//        
//        // 각종 간격을 적용합니다.
//        contentViewFrame.origin.x += horizontalSpacing
//        contentViewFrame.size.width -= horizontalSpacing * 2 // 양쪽으로 동일한 간격을 적용
//        contentViewFrame.origin.y += verticalSpacing
//        contentViewFrame.size.height -= verticalSpacing * 2 // 상하로 동일한 간격을 적용
//        
//        // 컨텐츠 뷰의 프레임을 조정합니다.
//        contentView.frame = contentViewFrame
//    }
    
}
