//
//  DepartureLocationModel.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/06.
//

import Foundation

struct DepartureLocationModel {
    let departureName: String
    let departureAddress: String
    let latitude: String
    let longitude: String
    
    var region: String {
        departureAddress.split(separator: " ").map {String($0)}[0]
    }
    
    var city: String {
        departureAddress.split(separator: " ").map {String($0)}[1]
    }
}
