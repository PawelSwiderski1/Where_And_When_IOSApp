//
//  GameSummaryMapView.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 07/08/2023.
//

import SwiftUI
import MapKit

struct GameSummaryMapView: UIViewControllerRepresentable {
    var guesses: [MKPointAnnotation]
    var correctLocations: [MKPointAnnotation]
    
    func makeUIViewController(context: Context) -> GameSummaryMapViewController {
        let viewController = UIStoryboard(name: "GameSummaryMapViewStoryboard", bundle: Bundle.main).instantiateViewController(identifier: "GameSummaryVC") as! GameSummaryMapViewController
        viewController.guesses = guesses
        viewController.correctLocations = correctLocations
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: GameSummaryMapViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
    
        
    }
    
    

struct GameSummaryMapView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        GameSummaryMapView(guesses: guesses, correctLocations: correctLocations).ignoresSafeArea(.all)
    }
}
