//
//  CalenderModel.swift
//  SlectableCalender
//
//  Created by Shohei Yokoyama on 2016/09/10.
//  Copyright © 2016年 Shohei. All rights reserved.
//

import UIKit

final class CalenderModel: NSObject {
    private var currentMonthOfDates: [NSDate] = []
    private var currentDate = NSDate()
    private static let daysCountPerWeek = 7
    var cellCount: Int!
    
    private var currentCalendar: NSCalendar {
        return NSCalendar.currentCalendar()
    }
    
    private var firstDateForMonth: NSDate {
        let components = currentCalendar.components([.Year, .Month, .Day], fromDate: currentDate)
        components.day = 1
        return currentCalendar.dateFromComponents(components) ?? NSDate()
    }
    
    var indexForFirstDate: Int {
        return  currentCalendar.ordinalityOfUnit(.Day, inUnit: .WeekOfMonth, forDate: firstDateForMonth) - 1
    }
    
    var indexForLastDate: Int {
        let rangeDays = currentCalendar.rangeOfUnit(.Day, inUnit: .Month, forDate: firstDateForMonth)
        return  rangeDays.length + indexForFirstDate - 1
    }
    
    var headerTitle: String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "M/yyyy"
        let currentMonth = formatter.stringFromDate(currentDate)
        return currentMonth
    }
    
    override init() {
        super.init()
        
        setup()
    }
    
    func conversionDateFormat(indexPath: NSIndexPath) -> String {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "d"
        return formatter.stringFromDate(currentMonthOfDates[indexPath.row])
    }
    
    func displayPreviousMonth() {
        currentMonthOfDates = []
        
        let dateComponents = NSDateComponents()
        dateComponents.month = -1
        currentDate = currentCalendar.dateByAddingComponents(dateComponents, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        setup()
    }
    
    func displayNextMonth() {
        currentMonthOfDates = []
        
        let dateComponents = NSDateComponents()
        dateComponents.month = 1
        currentDate = currentCalendar.dateByAddingComponents(dateComponents, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        setup()
    }
}

// MARK: - Private Methods -

private extension CalenderModel {
    func setup() {
        let weeksRange = currentCalendar.rangeOfUnit(.WeekOfMonth, inUnit: .Month, forDate: firstDateForMonth)
        cellCount = weeksRange.length * CalenderModel.daysCountPerWeek
        
        (0..<cellCount).forEach { index in
            let components = NSDateComponents()
            components.day = index - indexForFirstDate
            let date = currentCalendar.dateByAddingComponents(components, toDate: firstDateForMonth, options: NSCalendarOptions(rawValue: 0)) ?? NSDate()
            currentMonthOfDates.append(date)
        }
    }
}




















