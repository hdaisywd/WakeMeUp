import UIKit

class StopwatchLapTimeCell: UITableViewCell {

    var lapCounter: Int? {
        didSet {
            guard let lapCounter = lapCounter else { return }
            lapLabel.text = "Lap \(lapCounter)"
        }
    }
    
    let lapLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(hexCode: "595959")
        label.font = .boldSystemFont(ofSize: 20)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let horizontalSpacing: CGFloat = 25
        let verticalSpacing: CGFloat = 0
        
        var contentViewFrame = contentView.frame
        
        contentViewFrame.origin.x += horizontalSpacing
        contentViewFrame.size.width -= horizontalSpacing * 2
        contentViewFrame.origin.y += verticalSpacing
        contentViewFrame.size.height -= verticalSpacing * 2
        
        contentView.frame = contentViewFrame
    }
}
