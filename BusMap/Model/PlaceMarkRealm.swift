//
//  PlaceMarkRealm.swift
//  GoogleLogin
//
//  Created by user on 6/23/20.
//  Copyright © 2020 vinova. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

//Mot placeMark co placeid: primaryKey. Khi search: truy cap querycontrol


//Many - to - many
//File: /Users/user/Library/Developer/CoreSimulator/Devices/9F523DA9-BD3D-400C-B843-550FA74D548C/data/Containers/Data

//1 LAtitude = 111 km 

class RecentQuery: Object {
    @objc dynamic var query: String = ""
    @objc dynamic var user: String = ""
    @objc dynamic var timestamp: Date = Date()
  
    func setup(query: String, user: String){
        self.query = query
        self.user = user
    }
}

class queryControl: Object {
    dynamic var placemarks = List<PlaceMarkRealm>()
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var compare = 0.0
    
    @objc dynamic var query = ""
    
    @objc dynamic var compoundKey = ""
    
    override static func primaryKey() -> String? {
        return "compoundKey"
    }
    
    func setup(query: String,latitude : Double,longitude : Double){
        //self.placemarks.first?.query.append(self)
        
        self.query = query
        self.latitude = latitude
        self.longitude = longitude
        self.compoundKey = "\(query)-\(longitude)-\(latitude)"
    }

    func addPlaceMark(placeMark: PlaceMarkRealm){
        placemarks.append(placeMark)
    }
    
    func calculateCompare(a: Double, b: Double){
        //compare = pow((latitude-a),2) - pow((longitude - b),2)
        compare = ( -latitude + a)*( -latitude + a) + (-longitude + b) * (-longitude + b)
    }

}
class PlaceMarkRealm: Object {
    dynamic var query = List<queryControl>()
    
    @objc dynamic var Name: String? = nil
    @objc dynamic var placeName: String? = nil
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    @objc dynamic var place_id: String? = nil
    
    dynamic var owners = LinkingObjects(fromType: queryControl.self, property: "placemarks")
    
    @objc dynamic var compoundKey = ""
    
    override static func primaryKey() -> String? {
        return "place_id"//"compoundKey"
    }
    
    func setup(Name: String?,placeName: String?,latitude : Double,longitude : Double, placeId: String?){
        
        self.Name = Name
        self.placeName = placeName
        self.latitude = latitude
        self.longitude = longitude
        self.place_id = placeId
        //self.compoundKey = compoundKeyValue()
    }
    func addQueryControl(queryControl: queryControl){
        self.query.append(queryControl)
    }

//    func compoundKeyValue() -> String {
//        return "\(query)-\(longitude)-\(latitude)"
//    }


}


//POIS

class POIControl: Object {
    dynamic var placemarks = List<POI>()
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    @objc dynamic var compare = 0.0
    
    @objc dynamic var category = ""
    
    dynamic var query : GoogleCategory = .other
    
    @objc dynamic var compoundKey = ""
    
    override static func primaryKey() -> String? {
        return "compoundKey"
    }
    
    func setup(query: GoogleCategory,latitude : Double,longitude : Double){
        //self.placemarks.first?.query.append(self)
        
        self.query = query
        self.latitude = latitude
        self.longitude = longitude
        queryToCategory()
        self.compoundKey = "\(category)-\(longitude)-\(latitude)"
        
    }
    
    func queryToCategory(){
        switch query {
        case .bus_station:
            category = "bus_station"
        case .cafe:
            category = "cafe"
        case .car_repair:
            category = "car_repair"
        case .library:
            category = "library"
        case .restaurant:
            category = "restaurant"
        case .other:
            category = ""
        }
    }

    func addPOI(POI: POI){
        placemarks.append(POI)
    }
    

}
class POI: Object {
    dynamic var query = List<POIControl>()
    
    @objc dynamic var Name: String? = nil
    @objc dynamic var placeName: String? = nil
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    @objc dynamic var place_id: String? = nil
    
    dynamic var owners = LinkingObjects(fromType: POIControl.self, property: "placemarks")
    
    @objc dynamic var compoundKey = ""
    
    override static func primaryKey() -> String? {
        return "place_id"
    }
    
    func setup(Name: String?,placeName: String?,latitude : Double,longitude : Double, placeId: String?){
        
        self.Name = Name
        self.placeName = placeName
        self.latitude = latitude
        self.longitude = longitude
        self.place_id = placeId
    }
    func addPOIControl(POIControl: POIControl){
        self.query.append(POIControl)
    }


}
