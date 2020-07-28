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
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func newCollectionPressed(_ sender: Any) {
    }
    
}
