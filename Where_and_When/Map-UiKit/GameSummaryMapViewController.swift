//
//  GameSummaryMapViewController.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 07/08/2023.
//

import Foundation
import UIKit
import MapKit

class GameSummaryMapViewController: UIViewController, MKMapViewDelegate{
    @IBOutlet weak var myMap: MKMapView!
    var guesses: [MKPointAnnotation]?
    var correctLocations: [MKPointAnnotation]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMap.delegate = self
        
        myMap.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30, longitude: 20), span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180)), animated: true)
        
        
        let failGuess = MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude:0, longitude:0))
        let failCorrectLocation = MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude:20, longitude:-20))
        
        myMap.addAnnotations(guesses ?? [MKPointAnnotation](repeating: failGuess, count: 5))
        myMap.addAnnotations(correctLocations ?? [MKPointAnnotation](repeating: failCorrectLocation, count: 5))
        
        for index in (0...guesses!.count - 1){
            if let guess = guesses?[index], let correctLocation = correctLocations?[index]{
                let line = MKPolyline(coordinates: [guess.coordinate, correctLocation.coordinate] , count: 2)
                myMap.addOverlay(line)
            }
            
        }
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if containsAnnoatation(annotation as! MKPointAnnotation, guesses) {
            if let customAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "guessCustomAnnotation") as? GuessMarkerAnnotationView {
                customAnnotationView.annotation = annotation
                return customAnnotationView
            } else {
                let customAnnotationView = GuessMarkerAnnotationView(annotation: annotation, reuseIdentifier: "guessCustomAnnotation")
                customAnnotationView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                return customAnnotationView
            }
        } else if containsAnnoatation(annotation as! MKPointAnnotation, correctLocations) {
            if let customAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "correctCustomAnnotation") as? CorrectLocationMarkerAnnotationView {
                customAnnotationView.annotation = annotation
                return customAnnotationView
            } else {
                let customAnnotationView = CorrectLocationMarkerAnnotationView(annotation: annotation, reuseIdentifier: "correctCustomAnnotation")
                customAnnotationView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                return customAnnotationView
            }
        } else {
            return nil
        }
       }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let lineRenderer = MKPolylineRenderer(polyline: polyline)
                lineRenderer.strokeColor = .black
                lineRenderer.lineWidth = 1.0
                lineRenderer.lineDashPattern = [5]
                return lineRenderer
            }
            print("Something wrong...")
            return MKOverlayRenderer()
        }
    
    
   }

func containsAnnoatation(_ annotation: MKPointAnnotation, _ array: [MKAnnotation]?) -> Bool{
    if let array = array{
        for i in (0...array.count - 1) {
            if (array[i] === annotation) {
                return true
            }
        }
        
        return false
    }
    return false
}
    
