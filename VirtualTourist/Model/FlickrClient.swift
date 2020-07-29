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
        static let base = "http://api.flickr.com/services/rest/?"

        static let params = [
            "api_key=\(Keys.flickrApiKey)",
            "format=json",
            "method=flickr.photos.search",
            "radius=10",
            "per_page=20",
            "extras=url_m"
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
    
    class func getPhotos(forLatitude latitude: Double,
                         forLongitude longitude: Double,
                         forPageNumber pageNum: Int,
                         completion: @escaping (FlickrSearchResponse?, Error?) -> Void){
        let url = Endpoints.getPhotosByCoordinates(latitude, longitude, pageNum).url
        let task = URLSession.shared.dataTask(with: url) { (data, responese, error) in
            guard let safeData = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            let newData = safeData.subdata(in: 14..<safeData.count).dropLast()
            do {
                let searchResponse = try decoder.decode(FlickrSearchResponse.self, from: newData)
                DispatchQueue.main.async {
                    completion(searchResponse, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
