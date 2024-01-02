//
//  Event.swift
//  Runnect-iOS
//
//  Created by 이명진 on 1/2/24.
//

import Foundation

struct Event {
    struct View {
        static let viewHome = "view_home" // 앱 실행
    }
    
    struct Button {
        
        // 로그인
        
        static let clickAppleLogin = "click_apple_login"
        static let clickKaKaoLogin = "click_kakao_login"
        
        
        // 탭바
        
        static let clickCourseDrawingTabBar = "click_course_drawing_tab_bar"
        static let clickStorageTabBar = "click_storage_tab_bar"
        static let clickCourseDiscoveryTabBar = "click_course_discovery_tab_bar"
        static let clickMyPageTabBar = "click_my_page_tab_bar"
        
        
        // 코스 그리기
        
        static let clickCourseDrawing = "click_course_drawing"
        static let clickCurrentLocate = "click_current_locate"
        static let clickMapLocate = "click_map_locate"
        static let clickStoredAfterCourseComplete = "click_stored_after_course_complete"
        static let clickRunAfterCourseComplete = "click_run_after_course_complete"
        
        
        // 러닝 트래킹
        
        static let clickBackRunningTracking = "click_back_running_tracking"
        static let clickStoreRunningTracking = "click_store_running_tracking"
        
        
        /// 코스 발견
        
        static let clickDate = "click_date_sort"
        static let clickScrap = "click_scrap_sort"
        static let clickUploadButton = "click_upload_button"
        static let clickTrySearchCourse = "click_try_search_course"
        static let clickTryBanner = "click_try_banner"
        static let clickSearchCourse = "click_search_course"
        static let clickCourseDetail = "click_course_detail"
        static let clickShare = "click_share"
        static let clickUserProfile = "click_user_profile"
        static let clickScrapPageStartCourse = "click_scrap_page_start_course"
        static let clickUploadCourse = "click_upload_course"

        
        /// 보관함
    }
}
