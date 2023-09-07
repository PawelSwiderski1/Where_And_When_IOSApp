//
//  MapLocation.swift
//  TimeGuessr
//
//  Created by Pawel Swiderski on 13/07/2023.
//

import Foundation

import MapKit

struct MapLocation: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
