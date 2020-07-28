//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Christopher Crookes on 2020-07-27.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

class FlickrClient {
    static let apiKey = Keys.flickrApiKey
    
    enum Endpoints {
        static let base = "http://api.flickr.com/services/rest/?format=json"
        static let apiKeyParam = "&api_key=\(FlickrClient.apiKey)"
        
        case getPhotosByCoordinates(Double, Double, Int, Int)
        
        var stringValue: String {
            switch self {
                
            case .getPhotosByCoordinates(let latitude, let longitude, let radiusInKM, let pageNum):
                return Endpoints.base + "&method=flickr.photos.search" + Endpoints.apiKeyParam + "&lat=\(latitude)&lon=\(longitude)&radius=\(radiusInKM)&per_page=20&page=\(pageNum)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
}
