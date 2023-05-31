//
//  MainModel.swift
//  mapApp
//
//  Created by user on 5/21/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import Foundation
import CoreLocation

protocol ParseDataFromSearch: class {
    func parseData(data: [PlaceMarkForAllMap])
}

struct PlaceMarkForAllMap: MapsModelAccess{
    static var shared = [PlaceMarkForAllMap]()
    var Name: String?
    var placeName: String?
    var longitude: CLLocationDegrees?
    var latitude: CLLocationDegrees?
    var place_id: String?
}

struct PlaceMark {
    
    
    var Name: String?

    var placeName: String?
    
    var coordinates: (lat: Double, lng: Double)?
}


enum TypeOfMaps {

    case MapBox
    case AppleMaps
    case Google
}

enum GoogleCategory {
    // https://developers.google.com/places/web-service/supported_types
    case bus_station
    case cafe
    case restaurant
    case library
    case car_repair
    case other

}
