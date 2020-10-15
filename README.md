# Udacity iOS Assignment: Virtual Tourist

## Purpose

The purpose of this assignment is to practice using the following technologies:
- Using Grand Central Dispatch to handle asynchronous requests.
- Interacting with a remote API
- Working with Map Views
- Working with Core Data


## Set-up requirements

This assignment utilizes the Flickr API. In order to run this project, you will need to sign up for a Flickr account and get your own Flickr API key. For information on how to get your API key, refer to Flickr's API documentation:
- https://www.flickr.com/services/api/

Once you have your API key, you will need to add a file named `Keys.swift` to this project's `VirtualTourist` directory. The contents of the file should look like:
```swift
import Foundation

struct Keys {
    static let flickrApiKey = "<Enter your Flickr API Key Here>"
}
```
Replace `<Enter your Flickr API Key Here>` with your own Flickr developer API key.

## How to use

1. When you launch the app, you will see a full screen map view. If you long press at any location on the screen, a pin will be dropped.
2. Click on a dropped pin to go to the photos page. On the photos page you will see 20 random images from the area around the dropped pin. 
  - The first time you click on a pin, these images will be downloaded from Flickr. 
  - You will see placeholder images as the images are asynchronously downloaded. 
  - The images, along with their coordinates, will be stored using Core Data. The next time you visit this pin, the images will be pulled from storage rather than downloaded.
  - Click on `New Collection` at the bottom of the page to replace the photos with 20 different photos.
  - Click on an image to delete it.
