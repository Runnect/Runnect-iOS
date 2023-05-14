//
//  GoalRewardInfoModel.swift
//  Runnect-iOS
//
//  Created by 몽이 누나 on 2023/01/02.
//

import UIKit

struct GoalRewardInfoModel {
    let stampImg: UIImage
    let stampStandard: String
}

extension GoalRewardInfoModel {
    static var stampNameList: [GoalRewardInfoModel] {
        return [
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampC1, stampStandard: "그린 코스 1개"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampC2, stampStandard: "그린 코스 10개"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampC3, stampStandard: "그린 코스 30개"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampS1, stampStandard: "스크랩 1회"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampS2, stampStandard: "스크랩 20회"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampS3, stampStandard: "스크랩 40회"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampU1, stampStandard: "업로드 1회"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampU2, stampStandard: "업로드 10회"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampU3, stampStandard: "업로드 30회"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampR1, stampStandard: "달리기 1회"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampR2, stampStandard: "달리기 15회"),
        GoalRewardInfoModel(stampImg: ImageLiterals.imgStampR2, stampStandard: "달리기 30회")
    ]
    }
    
    static var stampNameImageDictionary: [String: UIImage] { ["CSPR0": ImageLiterals.imgPerson,
                                                              "c1": ImageLiterals.imgStampC1, "c2": ImageLiterals.imgStampC2, "c3": ImageLiterals.imgStampC3,
                                                              "s1": ImageLiterals.imgStampS1, "s2": ImageLiterals.imgStampS2, "s3": ImageLiterals.imgStampS3,
                                                              "u1": ImageLiterals.imgStampU1, "u2": ImageLiterals.imgStampU2, "u3": ImageLiterals.imgStampU3,
                                                              "r1": ImageLiterals.imgStampR1, "r2": ImageLiterals.imgStampR2, "r3": ImageLiterals.imgStampR3]
        
    }
}
