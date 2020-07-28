//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Christopher Crookes on 2020-07-28.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegate {

    var container: NSPersistentContainer!
    var coordinates: CLLocationCoordinate2D!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMap()
    }
    
    @IBAction func newCollectionPressed(_ sender: Any) {
    }
    
    func setupMap(){
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
    }
    
    
}
