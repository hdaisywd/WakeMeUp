
import Foundation
import UIKit

class AlarmTableViewCell: UITableViewCell {
    
    lazy var title = {
        let label = UILabel()
        label.text = "Title"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .gray
        
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
        label.font = .boldSystemFont(ofSize: 10)
        label.textColor = .gray
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        cellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("inset ")
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    private func cellLayout() {
        contentView.layer.cornerRadius = 10
        
        contentView.addSubview(title)
        contentView.addSubview(time)
        contentView.addSubview(day)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        day.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
            title.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5),
            title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            
            time.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            time.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            time.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2),
            
            day.leadingAnchor.constraint(equalTo: time.leadingAnchor),
            day.trailingAnchor.constraint(equalTo: time.trailingAnchor),
            day.topAnchor.constraint(equalTo: time.bottomAnchor, constant: 2),
            day.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])
    }
}
