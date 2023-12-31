
import Foundation
import UIKit

class AlarmTableViewCell: UITableViewCell {
    
    // MARK: Property
    lazy var title = {
        let label = UILabel()
        label.text = "Title"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .darkGray
        
        return label
    }()
    
    lazy var time = {
        let label = UILabel()
        label.text = "Time"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        
        return label
    }()
    
    lazy var day = {
        let label = UILabel()
        label.text = "Days"
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .darkGray
        
        return label
    }()
    
    lazy var alarmSwitch = {
        let alarmSwitch = UISwitch()
        alarmSwitch.onTintColor = UIColor(hexCode: "FFD6FF")
        
        return alarmSwitch
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: functions
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    private func cellLayout() {
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        
        contentView.addSubview(title)
        contentView.addSubview(time)
        contentView.addSubview(day)
        contentView.addSubview(alarmSwitch)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        day.translatesAutoresizingMaskIntoConstraints = false
        alarmSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            title.bottomAnchor.constraint(equalTo: time.topAnchor, constant: -2),
            
            time.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            time.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            time.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            time.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            day.leadingAnchor.constraint(equalTo: time.leadingAnchor),
            day.trailingAnchor.constraint(equalTo: time.trailingAnchor),
            day.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 2),
            
            alarmSwitch.centerYAnchor.constraint(equalTo: centerYAnchor),
            alarmSwitch.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10)
        ])
    }
}
