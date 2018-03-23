//
//  RealMapsViewController.swift
//  DBS
//
//  Created by SDG on 21/3/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit
import MapKit

class RealMapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let SchoolLocation = CLLocationCoordinate2DMake(22.322924, 114.174229)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        print("realmaps")
        
        self.title = "Maps"
        self.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        SetupMaps()
        UISetup()
        
    }
    
    func GoToCampus(){
        performSegue(withIdentifier: "MapsToCampus", sender: self)
    }
    
    func UISetup(){
        let ToImage = UIBarButtonItem(title: "Campus Map", style: .plain, target: self, action: #selector(GoToCampus))
        
        self.navigationItem.rightBarButtonItems = [ToImage]
        
        let SettingsButton = UIButton(frame: CGRect(x: self.view.frame.width * 0.85, y: self.view.frame.height * 0.2, width: self.view.frame.width / 8, height: self.view.frame.width / 8))
        /*
        SettingsButton.frame.size.height = self.view.frame.width * 0.2
        SettingsButton.frame.size.width = SettingsButton.frame.height
        SettingsButton.frame.origin.x = self.view.frame.width * 0.7
        SettingsButton.frame.origin.y = self.view.frame.height * 0.2
 */
        let tintableImage = #imageLiteral(resourceName: "Info").withRenderingMode(.alwaysTemplate)
        SettingsButton.setImage(tintableImage, for: .normal)
        SettingsButton.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        
        SettingsButton.layer.cornerRadius = SettingsButton.frame.height * 0.2
        
        self.view.addSubview(SettingsButton)
       
    }

    
    func Settings(){
        
    }
    
    
    func SetupMaps(){
        let LocationManager = CLLocationManager()
        
        
        let mapKitView = MKMapView(frame: view.frame)
        mapKitView.tag = 1
        
        self.view.addSubview(mapKitView)
        
        mapKitView.delegate = self as! MKMapViewDelegate
        mapKitView.showsUserLocation = true
        
        LocationManager.requestAlwaysAuthorization()
        LocationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            LocationManager.delegate = self as! CLLocationManagerDelegate
            LocationManager.desiredAccuracy = kCLLocationAccuracyBest
            LocationManager.startUpdatingLocation()
        }
        
        if let sourceCoordinates = LocationManager.location?.coordinate{
            let destCoordinates = SchoolLocation
            
            let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates)
            let destPlacemark = MKPlacemark(coordinate: destCoordinates)
            
            let sourceItem = MKMapItem(placemark: sourcePlacemark)
            let destItem = MKMapItem(placemark: destPlacemark)
            
            let directionRequest = MKDirectionsRequest()
            directionRequest.source = sourceItem
            directionRequest.destination = destItem
            /*
            switch Transport{
            case .Walking:
                directionRequest.transportType = .walking
            case .PublicTransport:
                directionRequest.transportType = .transit
            case .Car:
                directionRequest.transportType = .automobile
            default:
                directionRequest.transportType = .automobile
            }
     */
            
            let directions = MKDirections(request: directionRequest)
            
            directions .calculate(completionHandler: {
                response, error in
                
                guard let response = response else{
                    
                    if error != nil{
                        print("Error")
                    }
                    return
                }
                
                let route = response.routes[0]
                mapKitView.add(route.polyline, level: .aboveRoads)
                
                let rekt = route.polyline.boundingMapRect
                mapKitView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
                
            })
        }
        
        
        let pin = CustomPin(coordinate: SchoolLocation, title: "Diocesan Boys' School", subtitle: "Hong Kong")
        mapKitView.centerCoordinate = pin.coordinate
        mapKitView.addAnnotation(pin)
        
        //Properties
        mapKitView.showsCompass = true
        mapKitView.showsTraffic = true
        mapKitView.showsScale = true
        
        
        //displayInFlyoverMode()
        //openMapInTransitMode()
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if case .authorizedWhenInUse = status {
            manager.requestLocation()
        }
    }
    
    func displayInFlyoverMode() {
        if let x = self.view.viewWithTag(1){
            let mapkit = x as! MKMapView
            mapkit.mapType = .satelliteFlyover
            mapkit.showsBuildings = true
            let location = SchoolLocation
            let altitude: CLLocationDistance  = 500
            let heading: CLLocationDirection = 90
            let pitch = CGFloat(45)
            //let camera = MKMapCamera(lookingAtCenterCoordinate: location, fromDistance: altitude, pitch: pitch, heading: heading)
            let camera = MKMapCamera(lookingAtCenter: location, fromDistance: altitude, pitch: pitch, heading: heading)
            mapkit.setCamera(camera, animated: true)
        }
    }
    
    func openMapInTransitMode() {
        let startLocation = SchoolLocation
        let startPlacemark = MKPlacemark(coordinate: startLocation, addressDictionary: nil)
        let start = MKMapItem(placemark: startPlacemark)
        let destinationLocation = SchoolLocation
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        let destination = MKMapItem(placemark: destinationPlacemark)
        let options = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeTransit]
        MKMapItem.openMaps(with: [start, destination], launchOptions: options)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        let LocationManager = CLLocationManager()
        
        LocationManager.requestAlwaysAuthorization()
        LocationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            LocationManager.delegate = self as! CLLocationManagerDelegate
            LocationManager.desiredAccuracy = kCLLocationAccuracyBest
            LocationManager.startUpdatingLocation()
        }
        
        if let location = LocationManager.location?.coordinate{
            //mapView.centerCoordinate = location
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        print("pin")
        /*
        let pin = CustomPin(coordinate: userLocation.coordinate, title: "Apps Foundation", subtitle: "London")
        if let x = self.view.viewWithTag(1){
            let mapkit = x as! MKMapView
            mapkit.centerCoordinate = pin.coordinate
            mapkit.addAnnotation(pin)
        }
 */
        //mapView.centerCoordinate = userLocation.coordinate
    }
    
    /*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("pin")
        let pin = CustomPin(coordinate: locations.last!.coordinate, title: "Apps Foundation", subtitle: "London")
        if let x = self.view.viewWithTag(1){
            let mapkit = x as! MKMapView
            mapkit.centerCoordinate = pin.coordinate
            mapkit.addAnnotation(pin)
        }
    }
 */
    /*
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        let coordinates = CLLocationCoordinate2D(latitude: 22.322924, longitude: 114.174229)
        let pin = CustomPin(coordinate: coordinates, title: "United Kingdom", subtitle: "London")
        if let x = self.view.viewWithTag(1){
            
            let mapView = x as! MKMapView
            mapView.centerCoordinate = coordinates
            mapView.addAnnotation(pin)
        }
    }
 */
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        /*
        let coordinates = CLLocationCoordinate2D(latitude: 22.322924, longitude: 114.174229)
        let pin = CustomPin(coordinate: coordinates, title: "United Kingdom", subtitle: "London")
        if let x = self.view.viewWithTag(1){
            
            let mapView = x as! MKMapView
            mapView.centerCoordinate = coordinates
            mapView.addAnnotation(pin)
        }
 */
    }

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.init(red: 62.0/255.0, green: 151/255, blue: 250/255, alpha: 1)
        renderer.lineWidth = 8.0
        return renderer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}


class CustomPin : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
