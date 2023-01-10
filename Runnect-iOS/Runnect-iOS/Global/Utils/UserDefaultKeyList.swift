//
//  UserDefaultKeyList.swift
//  Runnect-iOS
//
//  Created by sejin on 2022/12/29.
//

import Foundation

struct UserDefaultKeyList {
    struct Auth {
        @UserDefaultWrapper<Bool>(key: "didSignIn") public static var didSignIn
    }
}
