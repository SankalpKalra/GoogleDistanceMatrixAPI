//
//  APIController.swift
//  DistanceMatrixAPI
//
//  Created by Appinventiv on 23/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation

class APIController{
   
    func getLatLng(src:String,dest:String,user:@escaping (GooglePlacesAPIModel)->Void,failure:@escaping (String)->Void){
        var source = src
        source = source.replacingOccurrences(of: " ", with: "+")
        var destination = dest
        destination = destination.replacingOccurrences(of: " ", with: "+")
        
        let placesApiSrcUrl = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(source)&key=AIzaSyAIrAqx2jxYilueXxLB6pseTrdDgNYLf5o"
        let placesApiDestUrl = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(destination)&key=AIzaSyAIrAqx2jxYilueXxLB6pseTrdDgNYLf5o"
        
        
        NetworkController().placesApi(url: placesApiSrcUrl, success: { (jsonData) in
            user(GooglePlacesAPIModel.init(json:jsonData))
        }) { (fail) in
            failure(fail)
        }
        NetworkController().placesApi(url: placesApiDestUrl, success: { (jsonData) in
            user(GooglePlacesAPIModel.init(json:jsonData))
        }) { (fail) in
            failure(fail)
        }
        
        
    }
    
    
    
    
    func getData(src:String,dest:String,modes:String,user:@escaping (DistanceMatrixJSONModel)->Void,failure:@escaping (String)->Void){
        var source = src
        source = source.replacingOccurrences(of: " ", with: "+")
        var destination = dest
        destination = destination.replacingOccurrences(of: " ", with: "+")
        let mode = modes
//        let distanceUrl = "https://maps.googleapis.com/maps/api/distancematrix/json?units=km&origins=\(source)&destinations=\(destination)&key=AIzaSyBUxnBqrbfm3lOhup_mNUpwMqm7PTNfiZ8"
       
        let modeUrl = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=\(source)&destinations=\(destination)&mode=\(mode)&language=en&key=AIzaSyA1U1i0i69_ASHg2S8B_r5MtxAHSYh8dL8"
        
        NetworkController().createSession(url: modeUrl, success: { (jsonData) in
            user(DistanceMatrixJSONModel.init(json:jsonData))
        }) { (fail) in
            failure(fail)
        }
        
    }
}
