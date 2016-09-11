//
//  CalenderModel.swift
//  SlectableCalender
//
//  Created by Shohei Yokoyama on 2016/09/10.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

final class CalenderModel: NSObject {
    private var currentDates: [NSDate] = []
    private var currentDate = NSDate()
    private static let daysCountPerWeek = 7//delete
    static let weeks: [String] = ["日", "月", "火", "水", "木", "金", "土"]
    enum MonthDirection {
        case previous, current, next
    }
    
    private var currentCalendar: NSCalendar {
        return NSCalendar.currentCalendar()
    }
    
    override init() {
        super.init()
        setup()
    }
    
    func stringFromDate(indexPath: NSIndexPath) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "d"
        return formatter.stringFromDate(currentDates[indexPath.row])
    }
    
    func headerTitle(direction: MonthDirection) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "M/yyyy"
        return formatter.stringFromDate(date(monthDirection: direction))
    }
    
    func displayMonth(direction: MonthDirection) {
        currentDates = []
        currentDate = date(monthDirection: direction)
        setup()
    }
    
    func indexForFirstDate(monthDirection direction: MonthDirection) -> Int {
        return  currentCalendar.ordinalityOfUnit(.Day, inUnit: .WeekOfMonth, forDate: firstDateFor(monthDirection: direction)) - 1
    }
    
    func indexForLastDate(monthDirection direction: MonthDirection) -> Int {
        let rangeDays = currentCalendar.rangeOfUnit(.Day, inUnit: .Month, forDate: firstDateFor(monthDirection: direction))
        return  rangeDays.length + indexForFirstDate(monthDirection: direction)  - 1
    }
    
    func cellCount(monthDirection direction: MonthDirection) -> Int {
        let weeksRange = currentCalendar.rangeOfUnit(.WeekOfMonth, inUnit: .Month, forDate: firstDateFor(monthDirection: direction))
        return weeksRange.length * CalenderModel.daysCountPerWeek
    }
}

// MARK: - Private Methods -

private extension CalenderModel {
    func setup() {
        (0..<cellCount(monthDirection: .current)).forEach { index in
            let components = NSDateComponents()
            components.day = index - indexForFirstDate(monthDirection: .current)
            let date = currentCalendar.dateByAddingComponents(components, toDate: firstDateFor(monthDirection: .current), options: NSCalendarOptions(rawValue: 0)) ?? NSDate()
            currentDates.append(date)
        }
    }
    
    func date(monthDirection direction: MonthDirection) -> NSDate {
        let components = NSDateComponents()
        switch direction {
        case .previous: components.month = -1
        case .current:  components.month = 0
        case .next:     components.month = 1
        }
        return currentCalendar.dateByAddingComponents(components, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
    }
    
    func firstDateFor(monthDirection direction: MonthDirection) -> NSDate {
        let components = currentCalendar.components([.Year, .Month, .Day], fromDate: date(monthDirection: direction))
        components.day = 1
        return currentCalendar.dateFromComponents(components)!
    }
}