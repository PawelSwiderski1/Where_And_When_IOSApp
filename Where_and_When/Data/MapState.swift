//
//  MapState.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 22/07/2023.
//

import Foundation
import MapKit


class MapState: ObservableObject {
    @Published var guess: MKPointAnnotation? {
        didSet{
            if guess == nil {
            }
        }
    }
    @Published var mapRegion: MKCoordinateRegion?
    @Published var shouldReset: Bool = false
    
    func reset(){
        guess = nil
        mapRegion = nil
        shouldReset = true
    }
}
