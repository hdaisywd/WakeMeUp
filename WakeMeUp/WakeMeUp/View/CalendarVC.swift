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
    fileprivate var datesWithCat = ["20231001"]

    
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
        super.viewDidLoad()
        // 유저 디폴트로 완료한 날짜 불러오기
        if let items = userdata.array(forKey: "completeDate") as? [String] {
            datesWithCat  = items
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
       

    
    // 셀 선택 색상
//    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
//
//        let imageDateFormatter = DateFormatter()
//        imageDateFormatter.dateFormat = "yyyyMMdd"
//
//
//        switch imageDateFormatter.string(from: date) {
//        case "20231013":
//            return #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
//        case "20231023":
//            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        case "20231024":
//            return #colorLiteral(red: 0.999460876, green: 0.8386494517, blue: 0.9997813106, alpha: 1)
//        default:
//            return appearance.selectionColor
//        }
//    }

}


