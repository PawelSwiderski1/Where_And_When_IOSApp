//
//  ResultMapViewContoller.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 24/07/2023.
//

import Foundation
import UIKit
import MapKit

class ResultMapViewController: UIViewController, MKMapViewDelegate{
    @IBOutlet weak var myMap: MKMapView!
    var guess: MKPointAnnotation?
    var correctLocation: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMap.delegate = self
        
        setMapRegion()
        
        let guess = guess ?? MKPointAnnotation(__coordinate: CLLocationCoordinate2D(latitude:51, longitude:0))
        
        myMap.addAnnotation(guess)
        myMap.addAnnotation(correctLocation!)
        
        let annotations:[CLLocationCoordinate2D] = [guess.coordinate, correctLocation!.coordinate]
        
        let line = MKPolyline(coordinates: annotations, count: annotations.count)
        myMap.addOverlay(line)
    }
    
    func setMapRegion(){
        let aspectRatio = myMap.frame.width / myMap.frame.height
                    
        let desiredLatitudeDelta = min(abs((guess!.coordinate.latitude) -  correctLocation!.coordinate.latitude) * 20.0, 180.0)
        
        let desiredLongitudeDelta = min(desiredLatitudeDelta * CLLocationDegrees(aspectRatio), 180.0)
        
        let span = MKCoordinateSpan(latitudeDelta: desiredLatitudeDelta, longitudeDelta: desiredLongitudeDelta)
        
        let region = MKCoordinateRegion(center: correctLocation!.coordinate, span: span)
        
        myMap.setRegion(region, animated: false)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
           if annotation is MKUserLocation {
               return nil
           }
           
           if annotation === guess {
               if let customAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "guessCustomAnnotation") as? GuessMarkerAnnotationView {
                   customAnnotationView.annotation = annotation
                   return customAnnotationView
               } else {
                   let customAnnotationView = GuessMarkerAnnotationView(annotation: annotation, reuseIdentifier: "guessCustomAnnotation")
                   customAnnotationView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                   return customAnnotationView
               }
           } else if annotation === correctLocation {
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
