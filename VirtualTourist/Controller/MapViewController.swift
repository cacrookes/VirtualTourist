//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Christopher Crookes on 2020-07-27.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {

    var pins = [Pin]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // print(FlickrClient.Endpoints.getPhotosByCoordinates(35.6762, 139.6503, 10, 1).stringValue)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(dropPin(gestureRecognizer:)))
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        mapView.delegate = self
        
        loadPins()
        setUpMap()
    }
    
    // MARK: - Manage Map View
    
    func createAnnotation(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        mapView.addAnnotation(annotation)
    }
    
    func setUpMap() {
        for pin in pins{
            createAnnotation(latitude: pin.latitude, longitude: pin.longitude)
        }
    }
    
    @objc func dropPin(gestureRecognizer: UILongPressGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        createAnnotation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        let newPin = Pin(context: self.context)
        newPin.latitude = coordinates.latitude
        newPin.longitude = coordinates.longitude
        self.pins.append(newPin)
        self.savePins()
    }
    
    // MARK: - Data Handling Methods
    
    func savePins() {
        do {
            try context.save()
        } catch {
            print("Error saving pin: \(error)")
        }
    }
    
    func loadPins() {
        let request: NSFetchRequest<Pin> = Pin.fetchRequest()
        do {
            pins = try context.fetch(request)
        } catch {
            print("Error loading pins: \(error)")
        }
    }
   
    // MARK: - MKMapView Delegate functions.
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation?.coordinate.latitude)
    }
    
    

}

