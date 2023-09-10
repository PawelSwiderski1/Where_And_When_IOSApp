import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, UIGestureRecognizerDelegate, MKMapViewDelegate{
    
    weak var delegate: MapViewControllerDelegate?
    
    @IBOutlet weak var myMap: MKMapView!
    var mapState: MapState?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        myMap.setRegion(mapState?.mapRegion ??  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 30, longitude: 20), span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 180)), animated: true)
        
        myMap.delegate = self
        
        let TapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(gestureRecognizer:)))
        TapGesture.delegate = self
        self.myMap.addGestureRecognizer(TapGesture)
        
        if let guess = mapState?.guess {
                        myMap.addAnnotation(guess)
                    }
    }
    
    

    @objc func handleTapGesture(gestureRecognizer: UITapGestureRecognizer){
        delegate?.didGuess(didGuess: true)
        
        let touchLocation = gestureRecognizer.location(in: myMap)
        let locationCoordinate = myMap.convert(touchLocation, toCoordinateFrom: myMap)
        
        
        if let existingAnnotation = myMap.annotations.first as? MKPointAnnotation {
            myMap.removeAnnotation(existingAnnotation)
        }
        
        let myPin = MKPointAnnotation()
        myPin.coordinate = locationCoordinate
        mapState?.guess = myPin
        
        
        myMap.addAnnotation(myPin)
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        if let customAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "customAnnotation") as? GuessMarkerAnnotationView {
            customAnnotationView.annotation = annotation
            return customAnnotationView
        } else {
            let customAnnotationView = GuessMarkerAnnotationView(annotation: annotation, reuseIdentifier: "customAnnotation")
            customAnnotationView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            return customAnnotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        delegate?.didChangeRegion(region: mapView.region)
        }
}

protocol MapViewControllerDelegate: AnyObject {
    func didChangeRegion(region: MKCoordinateRegion)
    func didGuess(didGuess: Bool)
}
