//
//  GoogleMapsStruct.swift
//  mapApp
//
//  Created by user on 5/25/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

import Foundation
import CoreLocation

struct GoogleMapsPlaceMarkService: Decodable {
    var results: [result]?
    struct result: Decodable {
        var geometry: geometry?
        
        struct geometry: Decodable {
            var location: locations?
            
            struct locations: Decodable{
                var lat: Double?
                var lng: Double?
            }
        }
        
        var name: String?
        var place_id: String?
        var vicinity: String?
        
       
    }
    var error_message: String?
           
}



struct GoogleMapsPlaceMark: MapsModelAccess {
    
    var Name: String?
    
    var placeName: String?
    
    var longitude: CLLocationDegrees?
    
    var latitude: CLLocationDegrees?
    
    
    static var shared = [GoogleMapsPlaceMark]()
    var lat: [Double] = []
    var lng: [Double] = []
    var name: [String] = []
    var vicinity: [String] = []
    var place_id: [String] = []
    var error_message: [String] = []
    
}

extension GoogleMapsPlaceMark {
    
    init(from service: GoogleMapsPlaceMarkService) {
        
        //self.init()
        
        guard let Results = service.results else {
            return
        }
        
        
        
        for Result in Results {
            //var temp = GoogleMapsPlaceMark()
                
            
            name.append(Result.name ?? "")
            place_id.append(Result.place_id ?? "")
            vicinity.append(Result.vicinity ?? "")
            
            guard let Geometry = Result.geometry  else {
                return
            }
            
            
                
                guard let Location = Geometry.location  else {
                    return
                }
                
                    lng.append(Location.lng ?? 0)
                    lat.append(Location.lat ?? 0)
            
//            GoogleMapsPlaceMark.shared.append(temp)
        }
        
        error_message.append(service.error_message ?? "")
        
    }
}
