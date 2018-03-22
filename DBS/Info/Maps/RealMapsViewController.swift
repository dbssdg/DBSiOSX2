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

    override func viewDidLoad() {
        super.viewDidLoad()

        print("realmaps")
        
        self.title = "Maps"
        self.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        UISetup()
        SetupMaps()
    }
    
    func GoToCampus(){
        performSegue(withIdentifier: "MapsToCampus", sender: self)
    }
    
    func UISetup(){
        let ToImage = UIBarButtonItem(title: "Campus Map", style: .plain, target: self, action: #selector(GoToCampus))
        
        self.navigationItem.rightBarButtonItems = [ToImage]
    }

    
    
    func SetupMaps(){
        let LocationManager = CLLocationManager()
        
        let mapKitView = MKMapView(frame: self.view.frame)
        
        mapKitView.delegate = self as! MKMapViewDelegate
        mapKitView.showsUserLocation = true
        
        LocationManager.requestAlwaysAuthorization()
        LocationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            LocationManager.delegate = self as! CLLocationManagerDelegate
            LocationManager.desiredAccuracy = kCLLocationAccuracyBest
            LocationManager.startUpdatingLocation()
        }
        
        let sourceCoordinates = LocationManager.location?.coordinate
        let destCoordinates = CLLocationCoordinate2DMake(22.322924, 114.174229)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates!)
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
                
                if let error = error{
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

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}
