//
//  TmapAddressSearchingResponseDto.swift
//  Runnect-iOS
//
//  Created by Sojin Lee on 2023/09/26.
//

import Foundation

// MARK: - TmapAddressSearchingResponseDto

struct TmapAddressSearchingResponseDto: Codable {
    let addressInfo: AddressInfo
    
    func toDepartureLocationModel(latitude: Double, longitude: Double) -> DepartureLocationModel {
        let buildingName = self.addressInfo.buildingName.isEmpty ? "주소를 알 수 없는 출발지" : self.addressInfo.buildingName
        
        return DepartureLocationModel(
            departureName: buildingName,
            departureAddress: addressInfo.fullAddress,
            latitude: String(latitude),
            longitude: String(longitude)
        )
    }
}

// MARK: - AddressInfo

struct AddressInfo: Codable {
    let fullAddress, addressType, cityDo, guGun: String
    let eupMyun, adminDong, adminDongCode, legalDong: String
    let legalDongCode, ri, bunji, roadName: String
    let buildingIndex, buildingName, mappingDistance, roadCode: String
    
    enum CodingKeys: String, CodingKey {
        case fullAddress, addressType
        case cityDo = "city_do"
        case guGun = "gu_gun"
        case eupMyun = "eup_myun"
        case adminDong, adminDongCode, legalDong, legalDongCode, ri, bunji, roadName, buildingIndex, buildingName, mappingDistance, roadCode
    }
}
