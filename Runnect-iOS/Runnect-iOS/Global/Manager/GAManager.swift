//
//  GAManager.swift
//  Runnect-iOS
//
//  Created by 이명진 on 12/24/23.
//

import UIKit

import FirebaseAnalytics

final class GAManager {
    static let shared = GAManager()
    
    private init() {}
    
    enum EventType {
        case screen(screenName: String)
        
        var eventName: String {
            switch self {
            case .screen:
                return "screen"
            }
        }
        
        var parameters: [String: Any]? {
            switch self {
            case .screen(let screenName):
                ["screen": screenName]
            }
        }
    }
    
    func logEvent(eventType: EventType) {
        Analytics.logEvent(eventType.eventName, parameters: eventType.parameters)
        print("언제 찍히는거지?")
    }
    
}
