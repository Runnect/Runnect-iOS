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
}
