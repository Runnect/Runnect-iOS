//
//  KeychainManager.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/09.
//

import UIKit

struct KeychainManager {
    
    static let shared = KeychainManager()
    
    private let service = Bundle.main.bundleIdentifier
    private let deviceId = "deviceId"
    
    private init() {}
    
    func storeDeviceId() -> Bool {
        guard let service = service else {
            print("Keychain >> addItem Fail with no service")
            return false
        }
        
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                   kSecAttrService: service,
                                         kSecAttrAccount: deviceId,
                                  kSecValueData: setDeviceID().data(using: .utf8, allowLossyConversion: false)!]
        
        // keychain 에 저장을 수행한 결과 값 반환 (true / false)
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            print("")
            print("Keychain >> addItem() : Success Status : \(status)]")
            print("")
            return true
        } else {
            print("")
            print("[Keychain >> addItem() : Fail Status : \(status)]")
            print("")
            return false
        }
    }
    
    func getDeviceId() -> String {
        guard let service = service else {
            print("Keychain >> getDeviceId Fail with no service")
            return ""
        }
        
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword, // 보안 데이터 저장
                                          kSecAttrService: service,
                                          kSecAttrAccount: deviceId,
                                          kSecReturnData: true,
                                          kSecReturnAttributes: true,
                                          kSecMatchLimit: kSecMatchLimitOne]
               
        var dataTypeRef: CFTypeRef?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            guard let existingItem = dataTypeRef as? [String: Any]
            else {
                print("Keychain >> getDeviceID() : Type Check : false")
                return ""
            }
            let deviceData = existingItem[kSecValueData as String] as? Data
            let uuidData = String(data: deviceData!, encoding: .utf8)!
            
            print("Keychain >> getDeviceID() : Success Status : \(status)")
            return uuidData
        } else if status == errSecItemNotFound || status == -25300 {
            print("Keychain >> getDeviceID() : Fail Status : 저장된 데이터가 없습니다")
            return ""
        } else {
            print("Keychain >> getDeviceID() : Fail Status : \(status)")
            return ""
        }
    }
    
    func deleteDeviceID() -> Bool {
        guard let service = self.service
        else {
            print("Keychain >> deleteDeviceID() : Service Check : false")
            return false
        }
        
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                   kSecAttrService: service,
                                   kSecAttrAccount: deviceId]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("Keychain >> deleteDeviceID() : Success Status : \(status)")
            return true
        } else {
            print("Keychain >> deleteDeviceID() : Fail Status : \(status)")
            return false
        }
    }
    
    func setDeviceID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
}
