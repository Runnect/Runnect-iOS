//
//  UserDefaultKeyList.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/29.
//

import Foundation

struct UserDefaultKeyList {
    struct Auth {
        @UserDefaultWrapper<String>(key: "deviceId") public static var deviceId
    }
}
