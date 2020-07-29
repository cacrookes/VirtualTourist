//
//  FlickrSearchResponse.swift
//  VirtualTourist
//
//  Created by Christopher Crookes on 2020-07-28.
//  Copyright © 2020 Christopher Crookes. All rights reserved.
//

import Foundation

struct FlickrSearchResponse: Codable {
    struct Photos: Codable {
        let page: Int
        let pages: Int
        let perpage: Int
        let total: String
        let photo: Photo
    }
    struct Photo: Codable {
        let id: String
        let owner: String
        let secrect: String
        let server: String
        let farm: Int
        let title: String
        let ispublic: Int
        let isfriend: Int
        let isfamily: Int
        let url_m: String
        let height_m: Int
        let width_m: Int
    }
    
    let photos: Photos
    let stat: String
    
}

