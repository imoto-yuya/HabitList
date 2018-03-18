//
//  TimeManager.swift
//  HabitList
//
//  Created by Yuya Imoto on 2018/03/17.
//  Copyright © 2018年 Yuya Imoto. All rights reserved.
//

import Foundation

class TimeManager {

    enum Week :Int {
        case Sunday = 1     // 日曜日
        case Monday = 2     // 月曜日
        case Tuesday = 3    // 火曜日
        case Wednesday = 4  // 水曜日
        case Thursday = 5   // 木曜日
        case Friday = 6     // 金曜日
        case Saturday = 7   // 土曜日
    }

    func nextFireDate() -> Date {
        let date = Date()
        let calendar = Calendar.current

        let components = calendar.dateComponents([.year, .month, .day, .weekday, .hour, .minute, .second], from: date)
        let weekday = components.weekday  // 1が日曜
        let hour = components.hour

        let fireWeekday = Week.Wednesday.rawValue
        var interval: TimeInterval
        if (weekday! >= fireWeekday && hour! >= 12) {
            interval = Double(60 * 60 * 24 * ((7 + fireWeekday) - weekday!))
        } else {
            interval = Double(60 * 60 * 24 * (fireWeekday - weekday!))
        }

        let nextDate = date.addingTimeInterval(interval)
        var fireDateComponents = calendar.dateComponents([.year, .month, .day, .weekday, .hour, .minute, .second], from: nextDate)
        fireDateComponents.hour = 12
        fireDateComponents.minute = 0
        fireDateComponents.second = 0

        //return calendar.dateFromComponents(fireDateComponents)!
        return calendar.date(from: fireDateComponents)!
    }
}
