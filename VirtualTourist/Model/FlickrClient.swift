//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Christopher Crookes on 2020-07-27.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

class FlickrClient {

    enum Endpoints {
        static let base = "http://api.flickr.com/services/rest/?format=json"

        static let params = [
            "api_key=\(Keys.flickrApiKey)",
            "format=json",
            "method=flickr.photos.search",
            "radius=10",
            "per_page=20"
        ].joined(separator: "&")
        
        case getPhotosByCoordinates(Double, Double, Int)

        var stringValue: String {
            switch self {

            case .getPhotosByCoordinates(let latitude, let longitude, let pageNum):
                return Endpoints.base + Endpoints.params + "&lat=\(latitude)&lon=\(longitude)&page=\(pageNum)"
            }
        }

        var url: URL {
            return URL(string: stringValue)!
        }
    }
}
