//
//  GameManager.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 23/07/2023.
//

import Foundation
import MapKit

class GameManager: ObservableObject {
    var round: Int = 0
    var score: Int = 0
    @Published var photos = [Photo?](repeating: nil, count: 5)
    @Published var rootId = UUID()
    @Published var isRunning = false
    @Published var playAgain = false
    
    var results = [RoundSummary?](repeating: nil, count: 5)
    
    var guesses: [MKPointAnnotation]{
        
        var guesses = [MKPointAnnotation](repeating:MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 50, longitude: 60)), count:5)
        for index in (0...round - 1){
            if results[index] != nil{
                guesses[index] = results[index]!.guessedLocation
            }
        }
        return guesses
    }
    var correctLocations: [MKPointAnnotation]{
        var correctLocations = [MKPointAnnotation](repeating:MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 20, longitude: 40)), count:5)
        for index in (0...4){
            let correctLocation = MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: photos[index]!.location["lat"]!, longitude: photos[index]!.location["lng"]!))
        
            correctLocations[index] = correctLocation
        }
        return correctLocations
    }
    
   
    

    func reset() {
        round = 0
        score = 0
        photos = [Photo?](repeating: nil, count: 5)
    }
}


class RoundSummary {
    var distanceScore: Int
    var yearScore: Int
    var totalScore: Int{
        return distanceScore + yearScore
    }
    var guessedLocation: MKPointAnnotation
    var guessedYear: Int
    
    init(distanceScore: Int, yearScore: Int, guessedLocation: MKPointAnnotation, guessedYear: Int) {
        self.distanceScore = distanceScore
        self.yearScore = yearScore
        self.guessedLocation = guessedLocation
        self.guessedYear = guessedYear
    }
}
