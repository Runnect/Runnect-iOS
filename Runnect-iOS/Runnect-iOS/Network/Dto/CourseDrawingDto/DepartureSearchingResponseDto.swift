//
//  DepartureSearchingResponseDto.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/06.
//

import Foundation

// MARK: - DepartureSearchingResponseDto

struct DepartureSearchingResponseDto: Codable {
    let documents: [KakaoAddressResult]
}

// MARK: - KakaoAddressResult

struct KakaoAddressResult: Codable {
    let addressName, categoryGroupCode, categoryGroupName, categoryName: String
    let distance, id, phone, placeName: String
    let placeURL: String
    let roadAddressName, latitude, longitude: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
        case longitude = "x"
        case latitude = "y"
    }
    
    func toDepartureLocationModel() -> DepartureLocationModel {
        return DepartureLocationModel(departureName: self.placeName, departureAddress: self.addressName, latitude: self.latitude, longitude: self.longitude)
    }
}
