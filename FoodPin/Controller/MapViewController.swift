//
//  MapViewController.swift
//  FoodPin
//
//  Created by pangborn on 7/12/20.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet var mapView:MKMapView!
    
    //var restaurant = Restaurant()
    var restaurant: RestaurantMO!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        
        mapView.delegate = self
        
        // Convert address to coordinate and annotate it on map
        let geoCoder = CLGeocoder()
        //geoCoder.geocodeAddressString(restaurant.location, completionHandler: { placemarks, error in
        //new because of CoreData
        geoCoder.geocodeAddressString(restaurant.location ?? "", completionHandler: { placemarks, error in
        
            if let error = error {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                // Get the first placemark
                let placemark = placemarks[0]
                // Add annotation
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    // Display the annotation
                    self.mapView.showAnnotations([annotation], animated: true)
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        })
    }
    
    //this is happening since we implement MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyMarker"
        if annotation.isKind(of: MKUserLocation.self) {
        return nil
        }
        // Reuse the annotation if possible
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        //cmd ctrl space to do emoticon
        annotationView?.glyphText = "🍑 "
        annotationView?.markerTintColor = UIColor.orange
        
        return annotationView
    }


}
