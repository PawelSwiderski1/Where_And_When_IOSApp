//
//  CustomAnnotationView.swift
//  Where_and_When
//
//  Created by Pawel Swiderski on 23/07/2023.
//

import Foundation
import MapKit

class GuessMarkerAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.image = UIImage(named: "GuessMarkerImage") // Replace "custom_marker_image" with the name of your custom marker image
        self.canShowCallout = false // Optional: Set this to true if you want a callout to be displayed when the annotation is tapped
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        self.transform = CGAffineTransform.identity
    }
}

class CorrectLocationMarkerAnnotationView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.image = UIImage(named: "CorrectLocationImage") // Replace "custom_marker_image" with the name of your custom marker image
        self.canShowCallout = false // Optional: Set this to true if you want a callout to be displayed when the annotation is tapped
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        self.transform = CGAffineTransform.identity
    }
}
