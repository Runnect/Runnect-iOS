//
//  ImageLiterals.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/01.
//

import UIKit
import NMapsMap

enum ImageLiterals {
    // icon
    static var icArrowBack: UIImage { .load(named: "ic_arrow_back") }
    static var icArrowMaximize: UIImage { .load(named: "ic_arrow_maximize") }
    static var icArrowPageback: UIImage { .load(named: "ic_arrow_pageback") }
    static var icArrowRight: UIImage { .load(named: "ic_arrow_right") }
    static var icCancel: UIImage { .load(named: "ic_cancel") }
    static var icCourseDiscoverFill: UIImage { .load(named: "ic_course_discove_fill") }
    static var icCourseDiscover: UIImage { .load(named: "ic_course_discover") }
    static var icCourseDrawFill: UIImage { .load(named: "ic_course_draw_fill") }
    static var icCourseDraw: UIImage { .load(named: "ic_course_draw") }
    static var icDistance: UIImage { .load(named: "ic_distance") }
    static var icEdit: UIImage { .load(named: "ic_edit") }
    static var icHeartFill: UIImage { .load(named: "ic_heart_fill") }
    static var icHeart: UIImage { .load(named: "ic_heart") }
    static var icMapDeparture: UIImage { .load(named: "ic_map_departure") }
    static var icMapLocation: UIImage { .load(named: "ic_map_location") }
    static var icMapPoint: UIImage { .load(named: "ic_map_point") }
    static var icMapStart: UIImage { .load(named: "ic_map_start") }
    static var icMypageFill: UIImage { .load(named: "ic_mypage_fill") }
    static var icMypage: UIImage { .load(named: "ic_mypage") }
    static var icPlus: UIImage { .load(named: "ic_plus") }
    static var icSearch: UIImage { .load(named: "ic_search") }
    static var icStar: UIImage { .load(named: "ic_star") }
    static var icStar2: UIImage { .load(named: "ic_star2") }
    static var icStorageFill: UIImage { .load(named: "ic_storage_fill") }
    static var icStorage: UIImage { .load(named: "ic_storage") }
    static var icTime: UIImage { .load(named: "ic_time") }
    static var icLocationPoint: UIImage { .load(named: "ic_location_point") }
    static var icAlert: UIImage { .load(named: "ic_alert") }
    static var icLocationOverlay: UIImage { .load(named: "ic_location_overlay") }

    // img
    static var imgBackground: UIImage { .load(named: "img_background") }
    static var imgLogo: UIImage { .load(named: "img_logo") }
    static var imgPaper: UIImage { .load(named: "img_paper") }
    static var imgPerson: UIImage { .load(named: "img_person") }
    static var imgStampC1: UIImage { .load(named: "img_stamp_c1") }
    static var imgStampC2: UIImage { .load(named: "img_stamp_c2") }
    static var imgStampC3: UIImage { .load(named: "img_stamp_c3") }
    static var imgStampP1: UIImage { .load(named: "img_stamp_p1") }
    static var imgStampP2: UIImage { .load(named: "img_stamp_p2") }
    static var imgStampP3: UIImage { .load(named: "img_stamp_p3") }
    static var imgStampR1: UIImage { .load(named: "img_stamp_r1") }
    static var imgStampR2: UIImage { .load(named: "img_stamp_r2") }
    static var imgStampR3: UIImage { .load(named: "img_stamp_r3") }
    static var imgStampS1: UIImage { .load(named: "img_stamp_s1") }
    static var imgStampS2: UIImage { .load(named: "img_stamp_s2") }
    static var imgStampS3: UIImage { .load(named: "img_stamp_s3") }
    static var imgStamp: UIImage { .load(named: "img_stamp") }
    static var imgStorage: UIImage { .load(named: "img_storage") }
    static var imgLock: UIImage { .load(named: "img_lock") }
    static var imgTelescope: UIImage { .load(named: "img_telescope") }
}

extension UIImage {
    static func load(named imageName: String) -> UIImage {
        guard let image = UIImage(named: imageName, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = imageName
        return image
    }
    
    func resize(to size: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
        return image
    }
}
