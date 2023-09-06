//
//  ResultMapViewContoller.swift
//  TimeGuessr
//
//  Created by Pawel Swiderski on 24/07/2023.
//

import Foundation
import UIKit
import MapKit

class ResultMapViewController: UIViewController, MKMapViewDelegate{
    @IBOutlet weak var myMap: MKMapView!
    //var mapState: MapState?
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
//        let averageLatitude = ((mapState?.guess!.coordinate.latitude)! + correctLocation!.coordinate.latitude) / 2.0
//        let averageLongitude = ((mapState?.guess!.coordinate.longitude)! + correctLocation!.coordinate.longitude) / 2.0
//        let averageCoordinate = CLLocationCoordinate2D(latitude: averageLatitude, longitude: averageLongitude)
//
        let aspectRatio = myMap.frame.width / myMap.frame.height
                    
        let desiredLatitudeDelta = min(abs((guess!.coordinate.latitude) -  correctLocation!.coordinate.latitude) * 20.0, 180.0)
        
        let desiredLongitudeDelta = min(desiredLatitudeDelta * CLLocationDegrees(aspectRatio), 180.0)
        
        let span = MKCoordinateSpan(latitudeDelta: desiredLatitudeDelta, longitudeDelta: desiredLongitudeDelta)
        print("span: \(span)")
        
        print("Correct locationa \(correctLocation!.coordinate)")
        let region = MKCoordinateRegion(center: correctLocation!.coordinate, span: span)
        
        print("Region \(region)")
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
            //Return an `MKPolylineRenderer` for the `MKPolyline` in the `MKMapViewDelegate`s method
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
