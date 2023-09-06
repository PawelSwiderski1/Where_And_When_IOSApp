//
//  MapView.swift
//  TimeGuessr
//
//  Created by Pawel Swiderski on 12/07/2023.
//

import SwiftUI
import MapKit

struct MapView: UIViewControllerRepresentable {
    @Binding var didGuess: Bool
    @ObservedObject var mapState: MapState

    
   
    
    func makeUIViewController(context: Context) -> MapViewController {
        let viewController = UIStoryboard(name: "MapViewStoryboard", bundle: Bundle.main).instantiateViewController(identifier: "MapViewVC") as! MapViewController
        //_ = viewController.view
        viewController.mapState = mapState
        
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        // Updates the state of the specified view controller with new information from SwiftUI.
        //        uiViewController.myMap.setRegion(mapRegion, animated: true)
        uiViewController.mapState = mapState
        if mapState.shouldReset{
            uiViewController.myMap.removeAnnotations(uiViewController.myMap.annotations)
            uiViewController.myMap.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30, longitude: 20), span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180))
            mapState.shouldReset = false
        }

    }
    
        func makeCoordinator() -> CoordinatorTest {
                return CoordinatorTest(self)
            }
    }
    
    class CoordinatorTest: NSObject, MapViewControllerDelegate {
            var parent: MapView
    
            init(_ parent: MapView) {
                self.parent = parent
            }
        
      
        func didChangeRegion(region: MKCoordinateRegion) {
            parent.mapState.mapRegion = region
        }
         
        func didGuess(didGuess: Bool){
            parent.didGuess = didGuess
        }
    }
    
    
struct MapViewTest_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack{
            MapView(didGuess: .constant(false), mapState: MapState())
           
        }  .ignoresSafeArea(.all)

      
    }
}

