//
//  PreviewProvider.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 18/07/2023.
//

import Foundation
import SwiftUI
import MapKit

extension PreviewProvider{
    static var previewPhotos : [Photo]{
        let photo1 = Photo(url: "https://photos-cdn.historypin.org/services/thumb/phid/502/dim/1000x1000/c/1482269432", dateTaken: "10 July 1956", location: ["lat": 55.862434, "lng": -4.265033], caption: "This is caption", description: "This is description")
        let photo2 = Photo(url: "https://photos-cdn.historypin.org/services/thumb/phid/502/dim/1000x1000/c/1482269432", dateTaken: "10 July 1956", location: ["lat": 0.862434, "lng": -4.265033], caption: "This is caption", description: "This is description")
        let photo3 = Photo(url: "https://photos-cdn.historypin.org/services/thumb/phid/502/dim/1000x1000/c/1482269432", dateTaken: "10 July 1956", location: ["lat": 23.862434, "lng": -56.265033], caption: "This is caption", description: "This is description")
        let photo4 = Photo(url: "https://photos-cdn.historypin.org/services/thumb/phid/502/dim/1000x1000/c/1482269432", dateTaken: "10 July 1956", location: ["lat": 55.862434, "lng": 15.265033], caption: "This is caption", description: "This is description")
        let photo5 = Photo(url: "https://photos-cdn.historypin.org/services/thumb/phid/502/dim/1000x1000/c/1482269432", dateTaken: "10 July 1956", location: ["lat": 20.862434, "lng": 54.265033], caption: "This is caption", description: "This is description")
        let photos = [photo1,photo2,photo3,photo4,photo5]
        return photos
    }
    
    static var previewMapState: MapState{
        let mapState = MapState()
        mapState.guess = MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 50, longitude: 20))
        return mapState
    }
    
    static var previewGameManager: GameManager{
        let gameManager = GameManager()
        gameManager.round = 5
        gameManager.photos = previewPhotos
        
        let result1 = RoundSummary(distanceScore: 3000, yearScore: 3500, guessedLocation: MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 50, longitude: 20)), guessedYear: 1970)
        let result2 = RoundSummary(distanceScore: 3000, yearScore: 3500, guessedLocation: MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 30, longitude: 20)), guessedYear: 1970)
        let result3 = RoundSummary(distanceScore: 3000, yearScore: 3500, guessedLocation: MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 15)), guessedYear: 1970)
        let result4 = RoundSummary(distanceScore: 3000, yearScore: 3500, guessedLocation: MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: -60, longitude: 80)), guessedYear: 1970)
        let result5 = RoundSummary(distanceScore: 3000, yearScore: 3500, guessedLocation: MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 110, longitude: 50)), guessedYear: 1970)

        gameManager.results = [result1,result2,result3,result4,result5]
        
        return gameManager
    }
    
    static var guesses: [MKPointAnnotation]{
        return [MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 50, longitude: 20)), MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 30, longitude: 20)), MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 15)), MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: -60, longitude: 80)), MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 100, longitude: 50))]
    }
    
    static var correctLocations: [MKPointAnnotation]{
        return [MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 43, longitude: 56)), MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: -50, longitude: -47)), MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 67)), MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: -72, longitude: -15)), MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 7, longitude: 22))]
    }
    
    
}
