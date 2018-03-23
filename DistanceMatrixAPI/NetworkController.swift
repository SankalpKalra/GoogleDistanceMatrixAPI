//
//  NetworkController.swift
//  DistanceMatrixAPI
//
//  Created by Appinventiv on 23/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import Foundation

class NetworkController{
    
    
    func placesApi(url:String,success:@escaping ([String:Any])->Void,failure:@escaping (String)->Void){
        
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with:request as URLRequest) { (data, response, error) in
            do{
                guard let data = data else { return }
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                success(jsonData as! [String : Any])
                //                let distance = DistanceMatrixJSONModel(json: jsonData as! [String : Any])
                
                if let err = error{
                    failure(err as! String)
                }
                else{
                    if let _ = response{
                        //print(response)
                    }
                }
            }catch {
                print("Serialization Catch Error ")
            }
        }
        dataTask.resume()
    }
    
   
    func createSession(url:String,success:@escaping ([String:Any])->Void,failure:@escaping (String)->Void){

        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with:request as URLRequest) { (data, response, error) in
            do{
            guard let data = data else { return }
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                success(jsonData as! [String : Any])
//                let distance = DistanceMatrixJSONModel(json: jsonData as! [String : Any])

                if let err = error{
                    failure(err as! String)
                }
                else{
                    if let _ = response{
                        //print(response)
                    }
                }
            }catch {
                print("Serialization Catch Error ")
            }
        }
        dataTask.resume()
    }
}
