//
//  DistanceMatrixJSONModel.swift
//  DistanceMatrixAPI
//
//  Created by Appinventiv on 23/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation

struct DistanceMatrixJSONModel{
    var destination_addresses: [String]?
    var origin_addresses: [String]?
    var rows:[Rows]?
    var status:String?
    init(json:[String:Any]){
        destination_addresses = json["destination_addresses"] as? [String] ?? []
        origin_addresses = json["origin_addresses"] as? [String] ?? []
        let row = json["rows"] as? [[String:Any]] ?? []
        rows = row.map({Rows.init(json: $0)})
        status = json["status"] as? String ?? ""
    }
    
}

struct Rows{
    var elements:[Elements]?
    init(json:[String:Any]){
        let element = json["elements"] as? [[String:Any]] ?? []
        elements = element.map({Elements.init(json: $0)})
    }
}

struct Elements{
    var distance:Distance?
    var duration:Duration?
    var status : String?
    init(json:[String:Any]){
        let dis = json["distance"] as? [String:Any] ?? [:]
        distance = Distance.init(json: dis)
        let dur = json["duration"] as? [String:Any] ?? [:]
        duration = Duration.init(json: dur)
        status = json["status"] as? String ?? ""
    }
    
}

struct Distance{
    var text: String?
    var value: Int?
    init(json:[String:Any]){
        text = json["text"] as? String ?? ""
        value = json["value"] as? Int ?? 0
    }
}

struct Duration{
    var text: String?
    var value: Int?
    init(json:[String:Any]){
        text = json["text"] as? String ?? ""
        value = json["value"] as? Int ?? 0
    }
}
