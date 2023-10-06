//
//  CalendarVC.swift
//  WakeMeUp
//
//  Created by Daisy Hong on 2023/09/26.
//

import UIKit
import FSCalendar
import SnapKit


class CalendarVC: UIViewController {
    let userdata = UserDefaults.standard
    // 현재 캘린더가 보여주고 있는 Page 트래킹
    lazy var currentPage = calendarView.currentPage
    fileprivate var datesWithCat = ["20231003","20231005","20231006"]
    var calendarResultContent = UILabel()

    
    private lazy var calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        
        // 첫 열을 월요일로 설정
        calendar.firstWeekday = 2
        // week 또는 month 가능
        calendar.scope = .month
        
        calendar.appearance.titleWeekendColor = .red
        
        
        
        calendar.scrollEnabled = false
        calendar.locale = Locale(identifier: "ko_KR")
        
        // 현재 달의 날짜들만 표기하도록 설정
        calendar.placeholderType = .none
        
        // 헤더뷰 설정
                calendar.headerHeight = 55
        calendar.appearance.headerDateFormat = "YYYY년 M월"
        calendar.appearance.headerTitleColor = .black
        
        // 요일 UI 설정
        calendar.appearance.weekdayTextColor = .black
        
        // 날짜 UI 설정
        calendar.appearance.titleTodayColor = .black
        
        calendar.appearance.todayColor = .white
                
        // 일요일 라벨의 textColor를 red로 설정
        calendar.calendarWeekdayView.weekdayLabels.last!.textColor = .red
        // 토요일 라벨 파란색으로
        calendar.calendarWeekdayView.weekdayLabels[5].textColor = .blue
        
        calendar.scrollEnabled = true
        calendar.scrollDirection = .horizontal
        
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        
        return calendar
    }()
    
    override func viewDidLoad() {
        self.view.addSubview(calendarResultContent)
        super.viewDidLoad()
        
        let safeArea = view.safeAreaLayoutGuide
        
        
        calendarResultContent.translatesAutoresizingMaskIntoConstraints = false

        calendarResultContent.text = ""
        calendarResultContent.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30).isActive = true
        calendarResultContent.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 10).isActive = true
        calendarResultContent.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: 10).isActive = true
        calendarResultContent.textColor = .black
        calendarResultContent.font = .boldSystemFont(ofSize: 30)
        calendarResultContent.textAlignment = .center
        
        // 유저 디폴트로 완료한 날짜 불러오기
        if let items = userdata.array(forKey: "completeDate") as? [String] {
            datesWithCat  = items
        }
        let imageDateFormatter = DateFormatter()
        imageDateFormatter.dateFormat = "yyyyMMdd"
        
        
        if(imageDateFormatter.string(from: Date()) == datesWithCat.last!){
            
            if((Int(datesWithCat[datesWithCat.count - 1])! - Int(datesWithCat[datesWithCat.count - 2])!) == 1){
                
                var i = datesWithCat.count - 2
                var compleDateCount = 1
                var arrayComparison = Int(datesWithCat[datesWithCat.count - 1])!
                print(arrayComparison, Int(datesWithCat[i])!)
                while 0 <= i {
                    if((arrayComparison - Int(datesWithCat[i])!) == 1){
                        arrayComparison = Int(datesWithCat[i])!
                        compleDateCount += 1
                        print("반복문", i)
                    }else{
                        calendarResultContent.text = "\(compleDateCount)일 연속 상쾌한 아침 달성!"
                        break
                    }
                    if(i == 0){
                        calendarResultContent.text = "\(compleDateCount)일 연속 상쾌한 아침 달성!"
                        break
                    }
                    i -= 1
                }
            }else{
                calendarResultContent.text = "조금만 더 힘내봐요!"
            }
        }
            
        setUI()
        setLayout()
//        setAction()
        
    }
}

extension CalendarVC {
    private func setUI() {
        view.backgroundColor = .white
    }
    
    private func setLayout() {
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(400)
            make.width.equalTo(356)
        }

    }
  
    // 달 이동 로직
    func moveMonth(next: Bool) {
        var dateComponents = DateComponents()
        dateComponents.month = next ? 1 : -1
        self.currentPage = Calendar.current.date(byAdding: dateComponents, to: self.currentPage)!
        calendarView.setCurrentPage(self.currentPage, animated: true)
    }
}

extension CalendarVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
        self.view.layoutIfNeeded()
    }
   
    
    // 일요일에 해당되는 모든 날짜의 색상 red로 변경
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        
        if Calendar.current.shortWeekdaySymbols[day] == "일" {
            return .systemRed
        }else if Calendar.current.shortWeekdaySymbols[day] == "토"{
            return .systemBlue
            
        }else {
            return .label
        }
    }
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold, scale: .large)
    
        let imageDateFormatter = DateFormatter()
        imageDateFormatter.dateFormat = "yyyyMMdd"
        let dateStr = imageDateFormatter.string(from: date)
        let a = UIImage(systemName: "sun.max", withConfiguration: imageConfig)
        
        return datesWithCat.contains(dateStr) ? a : nil
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {

       
        cell.imageView.tintColor = UIColor(red: 1.00, green: 0.42, blue: 0.21, alpha: 1.00)
       }
       


}
