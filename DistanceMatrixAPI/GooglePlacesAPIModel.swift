//
//  GooglePlacesAPIModel.swift
//  DistanceMatrixAPI
//
//  Created by Appinventiv on 23/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation
struct GooglePlacesAPIModel{
    var html_attributions:[String] = []
    var next_page_token: String = ""
    var results: [Results] = []
    var status: String = ""
    
    init (json : [String:Any]){
        html_attributions = [json["html_attributions"] as? String ?? ""]
        next_page_token = json["next_page_token"] as? String ?? ""
        
        let resultArr = json["results"] as? [[String:Any]] ?? []
        for val in resultArr {
            results.append(Results.init(json:val))
        }
        //        results = resultArr.map({
        //            Results.init(json: $0)
        //        })
        status = json["status"] as? String ?? ""
    }
    
}

struct Results{
    var formatted_address:String = ""
    var geometry : Geometry
    var icon: String = ""
    var id: String = ""
    var name: String = ""
    var opening_hours: OpeningHours
    var photos:[Photos] = []
    var place_id: String = ""
    var rating: NSNumber = -1
    var refrence: String = ""
    var types:[String] = []
    
    init (json: [String:Any]){
        formatted_address = json["formatted_address"] as? String ?? ""
        let geo = json["geometry"] as? [String:Any] ?? [:]
        geometry = Geometry(json: geo)
        icon = json["icon"] as? String ?? ""
        id = json["id"] as? String ?? ""
        name = json["name"] as? String ?? ""
        let opnHour = json["opening_hours"] as? [String:Any] ?? [:]
        opening_hours = OpeningHours(json: opnHour)
        let photoArr = json["photos"] as? [[String:Any]] ?? []
        for val in photoArr{
            photos.append(Photos(json: val))
        }
        place_id = json["place_id"] as? String ?? ""
        rating = json["rating"] as? NSNumber ?? -1
        refrence = json["refrence"] as? String ?? ""
        types = (json["types"] as? [String])!
    }
}

struct Geometry{
    var location: Location
    var viewport: Viewport
    
    init(json:[String:Any]){
        let loc = json["location"] as? [String:Any]
        location = Location(json: loc!)
        let viewPort = json["viewport"] as? [String:Any]
        viewport = Viewport(json: viewPort!)
    }
    
}

struct Location{
    var lat: Double = 0.0
    var lng: Double = 0.0
    
    init (json:[String:Any]){
        lat = json["lat"] as? Double ?? 0.000
        lng = json["lng"] as? Double ?? 0.000
    }
}

struct Viewport{
    var northeast: Location
    var southwest: Location
    
    init (json:[String:Any]){
        let northeastA = json["northeast"] as? [String:Any]
        northeast = Location(json: northeastA!)
        let southwestA = json["southwest"] as? [String:Any]
        southwest = Location(json: southwestA!)
    }
}

struct OpeningHours{
    var open_now: Bool = false
    var weekday_text: [String] = []
    
    init(json:[String:Any]){
        open_now = json["open_now"] as? Bool ?? false
        weekday_text = json["weekday_text"] as? [String] ?? []
    }
    
}

struct Photos{
    var height: Int = 0
    var html_attributions: [String] = []
    var photo_reference: String = ""
    var width:  Int = 0
    
    init (json:[String:Any]){
        height = json["height"] as? Int ?? 0
        html_attributions = json["html_attributions"] as? [String] ?? []
        photo_reference = json["photo_reference"] as? String ?? ""
        width = json["width"] as? Int ?? 0
    }
}
