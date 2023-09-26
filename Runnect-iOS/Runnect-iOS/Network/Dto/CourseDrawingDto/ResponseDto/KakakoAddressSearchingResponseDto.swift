//
//  DepartureAddressSearchingResponseDto.swift
//  Runnect-iOS
//
//  Created by Sojin Lee on 2023/09/26.
//

import Foundation

// MARK: - DepartureAddressSearchingResponseDto
struct KakakoAddressSearchingResponseDto: Codable {
    let meta: Meta
    let documents: [Document]
    
    func toDepartureLocationModel(latitude: Double, longitude: Double) -> DepartureLocationModel {
        let roadName = self.documents[0].roadAddress.buildingName ?? "내가 설정한 출발지"
        
        return DepartureLocationModel(departureName: roadName, departureAddress: self.documents[0].address.addressName, latitude: String(latitude), longitude: String(longitude))
    }
}

// MARK: - Document
struct Document: Codable {
    let roadAddress: RoadAddress
    let address: Address

    enum CodingKeys: String, CodingKey {
        case roadAddress = "road_address"
        case address
    }
}

// MARK: - Address
struct Address: Codable {
    let addressName, region1DepthName, region2DepthName, region3DepthName: String
    let mountainYn, mainAddressNo: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case mountainYn = "mountain_yn"
        case mainAddressNo = "main_address_no"
    }
}

// MARK: - RoadAddress
struct RoadAddress: Codable {
    let addressName, region1DepthName, region2DepthName, region3DepthName: String
    let roadName, undergroundYn, mainBuildingNo, subBuildingNo: String
    let buildingName, zoneNo: String

    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case region1DepthName = "region_1depth_name"
        case region2DepthName = "region_2depth_name"
        case region3DepthName = "region_3depth_name"
        case roadName = "road_name"
        case undergroundYn = "underground_yn"
        case mainBuildingNo = "main_building_no"
        case subBuildingNo = "sub_building_no"
        case buildingName = "building_name"
        case zoneNo = "zone_no"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
    }
}
