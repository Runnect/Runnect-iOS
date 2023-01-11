//
//  RNTimeFormatter.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/05.
//

import Foundation

class RNTimeFormatter {
    static func secondsToHHMMSS(seconds: Int) -> String {
        let interval = seconds

        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad

        let formattedString = formatter.string(from: TimeInterval(interval))!
        return formattedString
    }
    
    static func getCurrentTimeToString(date: Date) -> String {
        let formatter = DateFormatter()
        
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        
        return formatter.string(from: date)
    }
    
    static func changeDateSplit(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertDate = dateFormatter.date(from: date)
        
        let resultDateFormatter = DateFormatter()
        resultDateFormatter.dateFormat = "yyyy.MM.dd"
        
        return resultDateFormatter.string(from: convertDate!)
    }
}
