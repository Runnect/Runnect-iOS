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
    static var icApple: UIImage { .load(named: "ic_apple") }
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
    static var icKakao: UIImage { .load(named: "ic_kakao") }
    static var icMapDeparture: UIImage { .load(named: "ic_map_departure") }
    static var icMapLocation: UIImage { .load(named: "ic_map_location") }
    static var icMapPoint: UIImage { .load(named: "ic_map_point") }
    static var icMapStart: UIImage { .load(named: "ic_map_start") }
    static var icMypageFill: UIImage { .load(named: "ic_mypage_fill") }
    static var icMypage: UIImage { .load(named: "ic_mypage") }
    static var icPlusButton: UIImage { .load(named: "ic_plus_button") }
    static var icSearch: UIImage { .load(named: "ic_search") }
    static var icStar: UIImage { .load(named: "ic_star") }
    static var icStar2: UIImage { .load(named: "ic_star2") }
    static var icStorageFill: UIImage { .load(named: "ic_storage_fill") }
    static var icStorage: UIImage { .load(named: "ic_storage") }
    static var icTime: UIImage { .load(named: "ic_time") }
    static var icLocationPoint: UIImage { .load(named: "ic_location_point") }
    static var icAlert: UIImage { .load(named: "ic_alert") }
    static var icLocationOverlay: UIImage { .load(named: "ic_location_overlay") }
    static var icLogoCircle: UIImage { .load(named: "ic_logo_circle") }
    static var icMore: UIImage { .load(named: "ic_more") }
    static var icPlus: UIImage { .load(named: "ic_plus") }
    static var icCheck: UIImage { .load(named: "ic_check") }
    static var icCheckFill: UIImage { .load(named: "ic_check_fill") }
    static var icFollowButton: UIImage {.load(named: "ic_follow_button")}
    static var icFollowedButton: UIImage {.load(named: "ic_followed_button")}
    static var icShareButton: UIImage {.load(named: "ic_share")}
    static var icModify: UIImage {.load(named: "ic_modify")}
    static var icRemove: UIImage {.load(named: "ic_remove")}
    
    // img
    static var imgBackground: UIImage { .load(named: "img_background") }
    static var imgLogo: UIImage { .load(named: "img_logo") }
    static var imgPaper: UIImage { .load(named: "img_paper") }
    static var imgPerson: UIImage { .load(named: "img_person") }
    static var imgRecordContainerSelected: UIImage { .load(named: "img_record_container_selected") }
    static var imgRecordContainer: UIImage { .load(named: "img_record_container") }
    static var imgStampC1: UIImage { .load(named: "img_stamp_c1") }
    static var imgStampC2: UIImage { .load(named: "img_stamp_c2") }
    static var imgStampC3: UIImage { .load(named: "img_stamp_c3") }
    static var imgStampU1: UIImage { .load(named: "img_stamp_u1") }
    static var imgStampU2: UIImage { .load(named: "img_stamp_u2") }
    static var imgStampU3: UIImage { .load(named: "img_stamp_u3") }
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
    static var imgSpaceship: UIImage { .load(named: "img_spaceship") }
    static var imgAppIcon: UIImage { .load(named: "img_app_icon") }
    static var imgAd: UIImage { .load(named: "img_ad") }
    static var imgBanner1: UIImage { .load(named: "img_banner1") }
    static var imgBanner2: UIImage { .load(named: "img_banner2") }
    static var imgBanner3: UIImage { .load(named: "img_banner3") }
    static var imgBanner4: UIImage { .load(named: "img_banner4") }
    static var imgAppleLogin: UIImage { .load(named: "img_apple_login")}
    static var imgKakaoLogin: UIImage { .load(named: "img_kakao_login")}
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
