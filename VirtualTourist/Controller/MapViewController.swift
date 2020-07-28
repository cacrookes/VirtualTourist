//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Christopher Crookes on 2020-07-27.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // print(FlickrClient.Endpoints.getPhotosByCoordinates(35.6762, 139.6503, 10, 1).stringValue)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(dropPin(gestureRecognizer:)))
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        mapView.delegate = self
    }
    
    // https://stackoverflow.com/questions/30858360/adding-a-pin-annotation-to-a-map-view-on-a-long-press-in-swift
    @objc func dropPin(gestureRecognizer: UILongPressGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
    }
   
    // MARK: - MKMapView Delegate functions.
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // print(view.annotation?.coordinate.latitude)
    }
    
    

}

