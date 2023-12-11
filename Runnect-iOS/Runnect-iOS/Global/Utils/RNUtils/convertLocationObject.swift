//
//  convertLocationObject.swift
//  Runnect-iOS
//
//  Created by sejin on 2023/01/02.
//

import Foundation
import CoreLocation

import NMapsMap

extension CLLocationCoordinate2D? {
    func toNMGLatLng() -> NMGLatLng {
        return NMGLatLng(lat: self?.latitude ?? 37.52901832956373, lng: self?.longitude ?? 126.9136196847032)
    }
}

extension CLLocationCoordinate2D {
    func toNMGLatLng() -> NMGLatLng {
        return NMGLatLng(lat: self.latitude, lng: self.longitude)
    }
}

extension NMGLatLng {
    func toCLLocation() -> CLLocation {
        return CLLocation(latitude: lat, longitude: lng)
    }
    
    func toRNLocationModel() -> RNLocationModel {
        return RNLocationModel(latitude: self.lat, longitude: self.lng)
    }
}

extension DepartureLocationModel {
    func toNMGLatLng() -> NMGLatLng {
        guard let lat = Double(self.latitude),
                let lng = Double(self.longitude)
        else {
            return NMGLatLng(lat: 37.52901832956373, lng: 126.9136196847032)
        }
        
        return NMGLatLng(lat: lat, lng: lng)
    }
}
