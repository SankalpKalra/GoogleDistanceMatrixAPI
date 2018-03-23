//
//  ViewController.swift
//  DistanceMatrixAPI
//
//  Created by Appinventiv on 23/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController{
    
    var source = ""
    var destination = ""
    var lat = 0.0
    var lng = 0.0
    var mode = ""
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var sourceTextField: UITextField!
    
  
    @IBOutlet weak var downBar: UIView!
    @IBOutlet weak var distanceTF: UILabel!
    @IBOutlet weak var timeTF: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var homeLocation = CLLocation(latitude:28.6059694, longitude:77.3536476)
    let regionRadius: CLLocationDistance = 400
    var locationManager = CLLocationManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myLoc()
        //self.downBar.alpha=0
    }
    
   
    @IBAction func getSourceDestinationDetails(_ sender: UIButton) {
        self.source = self.sourceTextField.text!
        self.destination = self.destinationTextField.text!
        self.getLatLng()
        self.getDistanceTime()
        UIView.animate(withDuration: 1) {
            //self.downBar.alpha=1
            self.downBar.transform = CGAffineTransform(translationX: 0, y: -100)
        }
       
    }
    @IBAction func driveBtnTappedAction(_ sender: UIButton) {
        mode = "driving"
        print("driving")
        self.getDistanceTime()
    }
    @IBAction func twoWheelerBtnTapped(_ sender: UIButton) {
        mode = "cycling"
        print("cycling")
        self.getDistanceTime()
        
    }
    @IBAction func walkingBtnTapped(_ sender: UIButton) {
        mode = "walking"
        print("walking")
        self.getDistanceTime()
    }
    @IBAction func busBtnTapped(_ sender: UIButton) {
        mode = "driving"
        print("driving")
        self.getDistanceTime()
    }
    func getLatLng(){
        APIController().getLatLng(src: source, dest: destination, user: { (place) in
            DispatchQueue.main.async {
                self.lat = place.results[0].geometry.location.lat
                self.lng = place.results[0].geometry.location.lng
                print(self.lat)
                print(self.lng)
                self.homeLocation = CLLocation(latitude:self.lat, longitude:self.lng)
            }
            }) { (fail) in
                print(fail)
        }
    }
    
    func getDistanceTime(){
        APIController().getData(src:source,dest:destination,modes:mode,user: { (distance) in
            
            
            DispatchQueue.main.async {
                if let time = distance.rows![0].elements![0].duration?.text{
                self.timeTF.text = time
                }
                if let text = distance.rows![0].elements![0].distance?.text{
                self.distanceTF.text = "(\(text))"
                }
               
            }

        }) { (fail) in
            print(fail)
        }
    }
    
}

extension ViewController:CLLocationManagerDelegate,MKMapViewDelegate{
    func myLoc(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        mapView.showsUserLocation = true
        centerMapOnLocation(location: homeLocation)
        //Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius*2, regionRadius*2)
        mapView.setRegion(coordinateRegion, animated: true)
    }
// not in use
//    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
//
//        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
//        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
//
//        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
//        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
//
//        let sourceAnnotation = MKPointAnnotation()
//
//        if let location = sourcePlacemark.location {
//            sourceAnnotation.coordinate = location.coordinate
//        }
//
//        let destinationAnnotation = MKPointAnnotation()
//
//        if let location = destinationPlacemark.location {
//            destinationAnnotation.coordinate = location.coordinate
//        }
//
//        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
//
//        let directionRequest = MKDirectionsRequest()
//        directionRequest.source = sourceMapItem
//        directionRequest.destination = destinationMapItem
//        directionRequest.transportType = .automobile
//
//        // Calculate the direction
//        let directions = MKDirections(request: directionRequest)
//
//        directions.calculate {
//            (response, error) -> Void in
//
//            guard let response = response else {
//                if let error = error {
//                    print("Error: \(error)")
//                }
//
//                return
//            }
//
//            let route = response.routes[0]
//
//            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
//
//            let rect = route.polyline.boundingMapRect
//            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
//        }
//    }
//
//    // MARK: - MKMapViewDelegate
//
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//
//        let renderer = MKPolylineRenderer(overlay: overlay)
//
//        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
//
//        renderer.lineWidth = 5.0
//
//        return renderer
//    }
}
