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
}
