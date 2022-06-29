//
//  PlaceModal.swift
//  FoursquareClone
//
//  Created by busraguler on 17.06.2022.
//

import Foundation
import UIKit



class PlaceModel{
    
    static let sharedInstance = PlaceModel()  //paylaşılan bir obje
    
    var placeName = ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init() {}//başka hiçbir yerden initialize edilemez
}
