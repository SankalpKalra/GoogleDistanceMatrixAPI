//
//  ViewController.swift
//  DistanceMatrixAPI
//
//  Created by Appinventiv on 23/03/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit
import GoogleMaps
//import MapKit
class ViewController: UIViewController,UISearchBarDelegate{
    
    var source = ""
    var destination = ""
    var lat = 28.6052208
    var lng = 77.3626015
    var mode = ""
    var location = ""
    
    
    @IBOutlet weak var destinationTextField: UITextField!
    @IBOutlet weak var sourceTextField: UITextField!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var downView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var getDirectionOutlet: UIButton!
    @IBOutlet weak var searchBtnOutlet: UIButton!
    
    @IBOutlet weak var downBar: UIView!
    
    @IBOutlet weak var distanceTF: UILabel!
    @IBOutlet weak var timeTF: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //    let regionRadius: CLLocationDistance = 400
    //    var locationManager = CLLocationManager()
    
    var mapView:GMSMapView!
    var camera:GMSCameraPosition!
    var marker:GMSMarker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.downBar.alpha=0
        createMapView(lat: lat, lng: lng)
        bringViewsToFront()
    }
    
    func bringViewsToFront(){
        view.bringSubview(toFront: searchBar)
        view.bringSubview(toFront: topView)
        view.bringSubview(toFront: searchBtnOutlet)
        view.bringSubview(toFront: getDirectionOutlet)
        view.bringSubview(toFront: downBar)
        view.bringSubview(toFront: stackView)
    }
    
    func createMapView(lat:Double,lng:Double){
        self.camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 13.0)
        let frame = CGRect(x:0, y:0, width: view.bounds.width, height: view.bounds.height)
        self.mapView = GMSMapView.map(withFrame:frame, camera: camera)
        self.view.addSubview(mapView)
        self.marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        marker.title = "Appinventiv"
        marker.snippet = "Noida"
        marker.map = mapView
    }
    
    @IBAction func searchBtnTapped(_ sender: UIButton) {
        self.location=self.searchBar.text!
        APIController().getCurrentLoc(location: self.location, user: { (currentLocation) in
            print(currentLocation.status)
            DispatchQueue.main.async {
                if currentLocation.status == "OK"{
                    self.lat = currentLocation.results[0].geometry.location.lat
                    self.lng = currentLocation.results[0].geometry.location.lng
                    
                    self.mapView.animate(toLocation: CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng))
                    self.marker.position = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
                    UIView.animate(withDuration: 1) {
                        self.downBar.transform = .identity
                        self.searchBtnOutlet.transform = .identity
                        self.getDirectionOutlet.transform = .identity
                        self.downBar.alpha=0
                    }
                }
                else{
                    self.distanceTF.textColor = UIColor.red
                    self.distanceTF.text = "(Enter Valid City Name)"
                    UIView.animate(withDuration: 1) {
                        self.downBar.transform = CGAffineTransform(translationX: 0, y: -70)
                        self.searchBtnOutlet.transform = CGAffineTransform(translationX: 0, y: -70)
                        self.getDirectionOutlet.transform = CGAffineTransform(translationX: 0, y: -70)
                        self.downBar.alpha=1
                    }
                }
            }
        }) { (fail) in
            print(fail)
        }
        UIView.animate(withDuration: 1) {
            self.downBar.transform = .identity
            self.topView.transform = .identity
            self.searchBar.transform = .identity
            self.searchBtnOutlet.transform = .identity
            self.getDirectionOutlet.transform = .identity
        }
    }
    @IBAction func getDirectionsBtnTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 1) {
            self.topView.transform = CGAffineTransform(translationX: 0, y: 120)
            self.searchBar.transform = CGAffineTransform(translationX: 0, y: -70)
            self.downBar.transform = .identity
            self.searchBtnOutlet.transform = .identity
            self.getDirectionOutlet.transform = .identity
            self.downBar.alpha=0
        }
    }
    
    @IBAction func getSourceDestinationDetails(_ sender: UIButton) {
        self.source = self.sourceTextField.text!
        self.destination = self.destinationTextField.text!
        self.getLatLng()
        self.getDistanceTime()
        UIView.animate(withDuration: 1) {
            self.searchBtnOutlet.transform = CGAffineTransform(translationX: 0, y: -70)
            self.getDirectionOutlet.transform = CGAffineTransform(translationX: 0, y: -70)
            self.downBar.transform = CGAffineTransform(translationX: 0, y: -70)
            self.downBar.alpha=1
        }
        
    }
    @IBAction func driveBtnTappedAction(_ sender: UIButton) {
        mode = "driving"
        self.getDistanceTime()
    }
    @IBAction func twoWheelerBtnTapped(_ sender: UIButton) {
        mode = "cycling"
        self.getDistanceTime()
        
    }
    @IBAction func walkingBtnTapped(_ sender: UIButton) {
        mode = "walking"
        self.getDistanceTime()
    }
    @IBAction func busBtnTapped(_ sender: UIButton) {
        mode = "driving"
        self.getDistanceTime()
    }
    func getLatLng(){
        APIController().getLatLng(src: source, dest: destination, user: { (place) in
            DispatchQueue.main.async {
                if place.status == "OK"{
                    self.lat = place.results[0].geometry.location.lat
                    self.lng = place.results[0].geometry.location.lng
                    self.mapView.animate(toLocation: CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng))
                    self.marker.position = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lng)
                }
                else{
                    self.distanceTF.textColor = UIColor.red
                    self.distanceTF.text = "(Enter Valid City Name)"
                    
                }
            }
        }){ (fail) in
            print(fail)
        }
    }
    
    func getDistanceTime(){
        APIController().getData(src:source,dest:destination,modes:mode,user: { (distance) in
            DispatchQueue.main.async {
                
                if distance.status == "OK"{
                    if let time = distance.rows![0].elements![0].duration?.text{
                        self.timeTF.text = time
                    }
                    if let text = distance.rows![0].elements![0].distance?.text{
                        self.distanceTF.text = "(\(text))"
                    }
                }
                else{
                    self.distanceTF.textColor = UIColor.red
                    self.distanceTF.text = "(Please Enter Valid City Name)"
                }
            }
        }) { (fail) in
            print(fail)
        }
    }
    
}

//extension ViewController:CLLocationManagerDelegate,MKMapViewDelegate{
//
//    func myLoc(lat:Double,lng:Double){
//        mapView.delegate = self
//        locationManager.delegate = self
//        centerMapOnLocation(location: CLLocation(latitude: lat, longitude: lng))
//        if (CLLocationManager.locationServicesEnabled()) {
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestAlwaysAuthorization()
//            locationManager.requestWhenInUseAuthorization()
//        }
//        DispatchQueue.main.async {
//            if CLLocationManager.locationServicesEnabled() {
//                self.locationManager.startUpdatingLocation()
//            }
//        }
//    }
//    func centerMapOnLocation(location: CLLocation)
//    {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
//                                                                  regionRadius*2, regionRadius*2)
//        mapView.setRegion(coordinateRegion, animated: true)
//    }
//
//}

