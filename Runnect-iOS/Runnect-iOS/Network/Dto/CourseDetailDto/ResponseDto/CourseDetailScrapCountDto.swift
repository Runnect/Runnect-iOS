//
//  CourseDetailScrapCountDto.swift
//  Runnect-iOS
//
//  Created by 이명진 on 12/21/23.
//

import Foundation

struct CourseDetailScrapCountDto: Codable {
    let scrapCount: Int
    let publicCourse: Int?
    let scarpTF: Bool?
    /*
     코스 아이디와, 스크랩 TF는 사용 안함, 필요시 사용
     */
}
