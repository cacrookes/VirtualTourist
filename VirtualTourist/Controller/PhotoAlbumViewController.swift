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

class PhotoAlbumViewController: UIViewController {

    var container: NSPersistentContainer!
    var pin: Pin!
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        setupMap()
        setupFetchedResultController()
        
        // check if there are photos stored for this pin. If not, grab some.
        if fetchedResultsController.sections?[0].numberOfObjects == 0 {
           fetchPhotos()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setFlowLayout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    
    @IBAction func newCollectionPressed(_ sender: Any) {
    }
    
    func setFlowLayout() {
        let space:CGFloat = 3.0
        
        print("setting flow layout")
        
        // set the dimensions of the cell so we get 3 columns in portrait, or 3 rows in landscape
        let viewWidth = view.frame.size.width
        let viewHeight = view.frame.size.height
        let shortSize = viewWidth < viewHeight ? view.frame.size.width : view.frame.size.height
        let dimension = (shortSize - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    fileprivate func setupFetchedResultController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
                
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: "\(pin.latitude)-\(pin.longitude)-photos")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed.")
        }
    }
    
    func fetchPhotos() {
        FlickrClient.getPhotos(forLatitude: pin.latitude, forLongitude: pin.longitude, forPageNumber: 1) { (flickrSearchResponse, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let response = flickrSearchResponse else { return }
            for photo in response.photos.photo {
                let newPhoto = Photo(context: self.container.viewContext)
                newPhoto.pin = self.pin
                newPhoto.id = Int32(photo.id) ?? 0
                
                if let imageURL = URL(string: photo.url_m){
                    self.downloadImage(atUrl: imageURL) { (imageData) in
                        newPhoto.image = imageData
                        do {
                            try self.container.viewContext.save()
                        } catch {
                            print("Error saving image data: \(error)")
                        }
                    }
                }
                do {
                    try self.container.viewContext.save()
                } catch {
                     print("Error saving photo: \(error)")
                }
            }
        }
    }
    
    func downloadImage(atUrl url: URL, completionHandler handler: @escaping (_ imageData: Data) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            let imageData = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                handler(imageData!)
            }
        }
    }
    
    func setupMap(){
        let coordinates = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
    }
        
}

extension PhotoAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numResults = fetchedResultsController.sections?[section].numberOfObjects ?? 0
        return numResults
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photo = fetchedResultsController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.Identifiers.photoAlbumCollectionViewCell, for: indexPath) as! PhotoAlbumCollectionViewCell
        cell.imageView.image = #imageLiteral(resourceName: "placeholder")
        if let photoImage = photo.image {
            cell.imageView.image = UIImage(data: photoImage)
        }
        return cell
    }
}

extension PhotoAlbumViewController:NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
            break
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
            break
        case .update:
            collectionView.reloadItems(at: [indexPath!])
        case .move:
            collectionView.moveItem(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: collectionView.insertSections(indexSet)
        case .delete: collectionView.deleteSections(indexSet)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        @unknown default:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    
}
