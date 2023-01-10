//
//  RunningModel.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/10.
//

import Foundation

import NMapsMap

struct RunningModel {
    var courseId: Int?
    var publicCourseId: Int?
    var locations: [NMGLatLng]
    var distance: String?
    var pathImage: UIImage?
    var totalTime: Int?
    
    /// HH:MM:SS 형식으로 반환
    func getFormattedTotalTime() -> String? {
        guard let totalTime = self.totalTime else { return nil }
        return RNTimeFormatter.secondsToHHMMSS(seconds: totalTime)
    }
    
    /// mm'ss'' 형식으로 반환
    func getFormattedAveragePage() -> String? {
        guard let distance = distance, let totalTime = self.totalTime else { return nil }
        guard let floatDistance = Float(distance) else { return nil }
        let averagePaceSeconds = round(Float(totalTime) / floatDistance)
        let averagePaceSecondsInt = Int(averagePaceSeconds)
        let formattedAveragePace = "\(averagePaceSecondsInt / 60)'\(averagePaceSecondsInt % 60)''"
        return formattedAveragePace
    }
}
