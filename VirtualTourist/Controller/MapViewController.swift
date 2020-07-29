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
    
    let container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    // MARK: - IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
  
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(dropPin(gestureRecognizer:)))
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        mapView.delegate = self
        
        loadPins()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpMap()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveMapSettings()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Identifiers.mapToPhotosSegue {
            let annotation = mapView.selectedAnnotations.first
            let controller = segue.destination as! PhotoAlbumViewController
            
            // find the pin object corresponding to the annotation by comparing coordinates
            for pin in pins{
                if pin.longitude == annotation?.coordinate.longitude && pin.latitude == annotation?.coordinate.latitude {
                    controller.pin = pin
                    break
                }
            }
            controller.container = container
        }
    }
    
    // MARK: - Manage Map View
    
    func createAnnotation(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        mapView.addAnnotation(annotation)
    }
    
    func setUpMap() {
        // add pins to map
        for pin in pins{
            createAnnotation(latitude: pin.latitude, longitude: pin.longitude)
        }
        
        // retrieve user's previous map settings if they exist, and apply them to the current mapView
        guard let latitude = UserDefaults.standard.value(forKey: K.UserDefaultValues.latitude) as? Double else { return }
        guard let longitude = UserDefaults.standard.value(forKey: K.UserDefaultValues.longitude) as? Double else { return }
        guard let latitudeDelta = UserDefaults.standard.value(forKey: K.UserDefaultValues.latitudeDelta) as? CLLocationDegrees else { return }
        guard let longitudeDelta = UserDefaults.standard.value(forKey: K.UserDefaultValues.longitudeDelta) as? CLLocationDegrees else { return }

        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
        mapView.setRegion(region, animated: true)
    }
    
    func saveMapSettings() {
        // get current map settings
        let currentRegion = mapView.region
                
        //print("\(currentRegionSpan.latitudeDelta) - \(currentRegionSpan.latitudeDelta)")
        // set user defaults
        UserDefaults.standard.set(currentRegion.center.latitude, forKey: K.UserDefaultValues.latitude)
        UserDefaults.standard.set(currentRegion.center.longitude, forKey: K.UserDefaultValues.longitude)
        UserDefaults.standard.set(currentRegion.span.latitudeDelta, forKey: K.UserDefaultValues.latitudeDelta)
        UserDefaults.standard.set(currentRegion.span.longitudeDelta, forKey: K.UserDefaultValues.longitudeDelta)
    }
    
    @objc func dropPin(gestureRecognizer: UILongPressGestureRecognizer){
        let touchPoint = gestureRecognizer.location(in: mapView)
        let coordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        createAnnotation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        
        let newPin = Pin(context: self.container.viewContext)
        newPin.latitude = coordinates.latitude
        newPin.longitude = coordinates.longitude
        self.pins.append(newPin)
        self.savePins()
    }
    
    // MARK: - Data Handling Methods
    
    func savePins() {
        do {
            try container.viewContext.save()
        } catch {
            print("Error saving pin: \(error)")
        }
    }
    
    func loadPins() {
        let request: NSFetchRequest<Pin> = Pin.fetchRequest()
        do {
            pins = try container.viewContext.fetch(request)
        } catch {
            print("Error loading pins: \(error)")
        }
    }
   
    // MARK: - MKMapView Delegate functions.
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: K.Identifiers.mapToPhotosSegue, sender: self)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        saveMapSettings()
    }


}

