//
//  TimerRingtoneTableViewCell.swift
//  AudioTest
//
//  Created by 장가겸 on 10/6/23.
//

import UIKit

class TimerRingtoneTableViewCell: UITableViewCell {
    let identifier = "TimerRingtoneTableViewCell"

    let soundLabel: UILabel = {
        let label = UILabel()
        label.text = "-----"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setConstraint()
    }

    private func setConstraint() {
        contentView.addSubview(soundLabel)

        NSLayoutConstraint.activate([
            soundLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            soundLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            soundLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraint()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
        setConstraint()
    }
}
