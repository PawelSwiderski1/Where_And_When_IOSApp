//
//  ResultMapView.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 24/07/2023.
//

import SwiftUI
import MapKit

struct ResultMapView: UIViewControllerRepresentable {
    var guess: MKPointAnnotation
    var correctLocation: MKPointAnnotation
    
    func makeUIViewController(context: Context) -> ResultMapViewController {
        let viewController = UIStoryboard(name: "ResultMapViewStoryboard", bundle: Bundle.main).instantiateViewController(identifier: "ResultMapViewStoryboard") as! ResultMapViewController
        
        viewController.guess = guess
        viewController.correctLocation = correctLocation
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ResultMapViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
    }
    
        
    }
    
    

struct ResultMapView_Previews: PreviewProvider {
    static var previews: some View {
        ResultMapView(guess: previewMapState.guess!, correctLocation: MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude: 51, longitude: 0))).ignoresSafeArea(.all)
    }
}
