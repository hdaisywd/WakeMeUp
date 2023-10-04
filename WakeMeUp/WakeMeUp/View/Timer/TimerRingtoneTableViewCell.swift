//
//  TimerRingtoneTableViewCell.swift
//  BezierPatchTest
//
//  Created by 장가겸 on 10/2/23.
//

import UIKit

class TimerRingtoneTableViewCell: UITableViewCell {
    let identifier = "TimerRingtoneTableViewCell"

    let soundLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setConstraint()
    }

    private func setConstraint() {
        contentView.addSubview(soundLabel)

        NSLayoutConstraint.activate([
            soundLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            soundLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }

    func setupUI() {
        backgroundColor = UIColor(named: "ModalSettingTableViewColor")
        soundLabel.textColor = .white
    }
}
