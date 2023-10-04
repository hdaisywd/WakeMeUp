
import Foundation
import UIKit
import SnapKit

class AddAlarmVC: UIViewController {
    
    // MARK: Property
    private let datepicker = {
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .time
        datepicker.preferredDatePickerStyle = .wheels
        datepicker.locale = Locale(identifier: "en_KR")
        
        return datepicker
    }()
    
    private let totalViewHeight = 50
    private let totalViewWidth = 350
    
    private let labelWidth = 50
    private let viewWidth = 270
    
    private lazy var titleView = {
        let titleView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = "Title"
        titleLabel.textAlignment = .center
        
        let textfield = MyTextfield()
        
        titleView.addSubview(titleLabel)
        titleView.addSubview(textfield)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalTo(titleView.snp.centerY)
            make.width.equalTo(self.labelWidth)
        }
        
        textfield.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(10)
            make.centerY.equalTo(titleView.snp.centerY)
            make.width.equalTo(self.viewWidth)
        }
        
        return titleView
    }()
    
    private lazy var days = {
        let daysView = UIView()
        
        let daysLabel = UILabel()
        daysLabel.text = "Days"
        daysLabel.textAlignment = .center
        
        let selectDays = SelectDaysView()
        
        daysView.addSubview(daysLabel)
        daysView.addSubview(selectDays)
        
        daysLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalTo(daysView.snp.centerY)
            make.width.equalTo(self.labelWidth)
        }
        
        selectDays.snp.makeConstraints { make in
            make.left.equalTo(daysLabel.snp.right).offset(10)
            make.centerY.equalTo(daysView.snp.centerY)
            make.width.equalTo(self.viewWidth)
        }
        
        return daysView
    }()
    
    private lazy var sound = {
        let soundView = UIView()
        
        let soundLabel = UILabel()
        soundLabel.text = "Sound"
        soundLabel.textAlignment = .center
        
        let selectDays = SelectSoundPickerView()
        
        soundView.addSubview(soundLabel)
        soundView.addSubview(selectDays)
        
        soundLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalTo(soundView.snp.centerY)
            make.width.equalTo(self.labelWidth)
        }
        
        selectDays.snp.makeConstraints { make in
            make.left.equalTo(soundLabel.snp.right).offset(10)
            make.centerY.equalTo(soundView.snp.centerY)
            make.width.equalTo(self.viewWidth)
        }
        
        return soundView
    }()
    
    private lazy var game = {
        let gameView = UIView()
        
        let gameLabel = UILabel()
        gameLabel.text = "Game"
        gameLabel.textAlignment = .center
        
        let selectGame = SelectSoundPickerView()
        
        gameView.addSubview(gameLabel)
        gameView.addSubview(selectGame)
        
        gameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalTo(gameView.snp.centerY)
            make.width.equalTo(self.labelWidth)
        }
        
        selectGame.snp.makeConstraints { make in
            make.left.equalTo(gameLabel.snp.right).offset(10)
            make.centerY.equalTo(gameView.snp.centerY)
            make.width.equalTo(self.viewWidth)
        }
        
        return gameView
    }()
    
    private lazy var selectRepeat = {
        let selectRepeat = UIView()
        
        let label = UILabel()
        label.text = "Repeat"
        
        let checkbox = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)
        let image = UIImage(systemName: "checkmark.circle", withConfiguration: imageConfig)
        checkbox.setImage(image, for: .normal)
        
        selectRepeat.addSubview(label)
        selectRepeat.addSubview(checkbox)
        
        label.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalTo(selectRepeat.snp.centerY)
        }
        
        checkbox.snp.makeConstraints { make in
            make.left.equalTo(label.snp.right).offset(5)
            make.centerY.equalTo(selectRepeat.snp.centerY)
        }
        
        return selectRepeat
    }()
    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureLayout()
    }
    
    private func configureNavigationBar() {
        view.backgroundColor = .white
        
        self.navigationItem.title = "Add Alarm"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(hexCode: "0077b6")]
        
        let leftBarItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonAction))
        leftBarItem.tintColor = UIColor(hexCode: "0077b6")
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        let rightBarItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonAction))
        rightBarItem.tintColor = UIColor(hexCode: "0077b6")
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    private func configureLayout() {
        view.addSubview(datepicker)
        view.addSubview(titleView)
        view.addSubview(days)
        view.addSubview(sound)
        view.addSubview(game)
        view.addSubview(selectRepeat)
        
        datepicker.snp.makeConstraints { make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.view.snp.top).offset(100)
        }
        
        titleView.backgroundColor = .red
        titleView.snp.makeConstraints { make in
            make.top.equalTo(datepicker.snp.bottom).offset(30)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(totalViewWidth)
            make.height.equalTo(totalViewHeight)
        }
        
        days.backgroundColor = .red
        days.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(5)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(totalViewWidth)
            make.height.equalTo(totalViewHeight)
        }
        
        sound.backgroundColor = .red
        sound.snp.makeConstraints { make in
            make.top.equalTo(days.snp.bottom).offset(5)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(totalViewWidth)
            make.height.equalTo(totalViewHeight)
        }
        
        game.backgroundColor = .red
        game.snp.makeConstraints { make in
            make.top.equalTo(sound.snp.bottom).offset(5)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(totalViewWidth)
            make.height.equalTo(totalViewHeight)
        }
        
        selectRepeat.backgroundColor = .red
        selectRepeat.snp.makeConstraints { make in
            make.top.equalTo(game.snp.bottom).offset(5)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(totalViewWidth)
            make.height.equalTo(totalViewHeight)
        }
        
        
    }
    
    @objc func cancelButtonAction() {
        
    }
    
    @objc func saveButtonAction() {
        
    }
    
}
