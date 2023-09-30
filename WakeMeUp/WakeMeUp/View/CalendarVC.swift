//
//  CalendarVC.swift
//  WakeMeUp
//
//  Created by Daisy Hong on 2023/09/26.
//

import Foundation
import UIKit

class CalendarVC: UIViewController {
    var currentDate: Date = Date() // 현재 날짜를 저장하는 변수

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Calendar"
        view.backgroundColor = .white

        createCalendarView()
    }

    func createCalendarView() {
        // 월별 캘린더를 표시할 레이블 생성
        let monthLabel = UILabel()
        monthLabel.textAlignment = .center
        view.addSubview(monthLabel)

        // 월별 캘린더 레이블의 제약 조건 설정
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        monthLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        monthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        monthLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        // 월별 캘린더를 표시할 뷰 생성
        let calendarView = UIView()
        view.addSubview(calendarView)

        // 월별 캘린더 뷰의 제약 조건 설정
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 16).isActive = true
        calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true

       
        let calendar = Calendar.current
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMMM yyyy"
        monthLabel.text = monthFormatter.string(from: currentDate)

        let daysInMonth = calendar.range(of: .day, in: .month, for: currentDate)!
        let numDays = daysInMonth.count
        let dayWidth = calendarView.frame.width / 7.0
        let dayHeight: CGFloat = 40.0

        for day in 1...numDays {
            let x = CGFloat((day - 1) % 7) * dayWidth
            let y = CGFloat((day - 1) / 7) * dayHeight
            let dayLabel = UILabel(frame: CGRect(x: x, y: y, width: dayWidth, height: dayHeight))
            dayLabel.textAlignment = .center
            dayLabel.text = "\(day)"
            calendarView.addSubview(dayLabel)
        }
    }
}
