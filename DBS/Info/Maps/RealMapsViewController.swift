//
//  RealMapsViewController.swift
//  DBS
//
//  Created by SDG on 21/3/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit
import MapKit
import TwicketSegmentedControl

class RealMapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, TwicketSegmentedControlDelegate{
    func didSelect(_ segmentIndex: Int) {
        
    }
    
    
    
    let mapKitView = MKMapView()
    
    let SchoolLocation = CLLocationCoordinate2DMake(22.322924, 114.174229)
    
    let EffectView = UIVisualEffectView()
    let SettingsView = UIView()
    
    let SettingsLabel = UILabel()
    let MapType = TwicketSegmentedControl()
    let TravelType = TwicketSegmentedControl()
    let DoneButton = UIButton()
    
    var DoneTapGesture = UIGestureRecognizer()
    
    let BackgroundButton = UIButton()
    
    var MapTypeSeg = 0
    var TravelTypeSeg = 0
    
    var StackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        //Settings Button
        let SettingsButton = UIButton(frame: CGRect(x: self.view.frame.width * 0.85, y: self.view.frame.height * 0.2, width: self.view.frame.width / 8, height: self.view.frame.width / 8))
        
        var tintableImage = #imageLiteral(resourceName: "Info").withRenderingMode(.alwaysTemplate)
        SettingsButton.setImage(tintableImage, for: .normal)
        SettingsButton.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        SettingsButton.round(corners: [.topRight, .topLeft], radius: SettingsButton.frame.height * 0.2)
        SettingsButton.layer.zPosition = 100
//        SettingsButton.layer.borderWidth = 1
//        SettingsButton.layer.borderColor = UIColor.darkGray.cgColor
        
        SettingsButton.addTarget(self, action: #selector(Settings), for: .touchUpInside)
        
        self.view.addSubview(SettingsButton)
        
        //Location Button
        let LocationButton = UIButton(frame: CGRect(x: SettingsButton.frame.origin.x, y: SettingsButton.frame.origin.y + SettingsButton.frame.height, width: SettingsButton.frame.width, height: SettingsButton.frame.width))
        tintableImage = #imageLiteral(resourceName: "LocationArrow").withRenderingMode(.alwaysTemplate)
        LocationButton.setImage(tintableImage, for: .normal)
        LocationButton.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        LocationButton.round(corners: [.bottomRight, .bottomLeft], radius: LocationButton.frame.height * 0.2)
        LocationButton.layer.zPosition = SettingsButton.layer.zPosition
        
        LocationButton.addTarget(self, action: #selector(BackToUserLocation), for: .touchUpInside)
//        LocationButton.layer.borderWidth = 1
//        LocationButton.layer.borderColor = UIColor.darkGray.cgColor
        
        self.view.addSubview(LocationButton)
        
       
        //Visual Effect View
        EffectView.effect = UIBlurEffect(style: .light)
        EffectView.frame = self.view.frame
        EffectView.layer.zPosition = 1000
        
        //Settings View
        SettingsView.center = self.view.center
        SettingsView.frame.size = CGSize(width: self.view.frame.width * 0.85, height: self.view.frame.height / 3)
        SettingsView.layer.cornerRadius = SettingsView.frame.height * 0.1
        SettingsView.backgroundColor = UIColor.white
        SettingsView.layer.zPosition = 10000
        
        //Settings Label
        SettingsLabel.frame = CGRect(x: self.SettingsView.center.x - self.SettingsLabel.frame.width / 2, y:  SettingsView.frame.height * 0.15, width: 100, height: 100)
        SettingsLabel.text = "Maps Settings"
        SettingsLabel.textColor = UIColor.darkText
        SettingsLabel.font = UIFont.init(name: "Helvetica Light", size: 26)
    
        SettingsLabel.sizeToFit()
        SettingsLabel.frame.origin = CGPoint(x: (self.SettingsView.frame.width - self.SettingsLabel.frame.width) / 2, y:  SettingsView.frame.height * 0.1)
        
        SettingsLabel.layer.zPosition = SettingsView.layer.zPosition * 10
        
        //Map Type Seg Con
        MapType.frame = CGRect(x: (self.MapType.frame.width - self.MapType.frame.width) / 2, y: SettingsView.frame.height * 0.3, width: SettingsView.frame.width, height: SettingsView.frame.height * 0.1)
        MapType.setSegmentItems(["Map", "Transport", "Satellite"])
        MapType.delegate = self
        MapType.addTarget(self, action: #selector(MapTypeChanged(_:)), for: .touchUpInside)
        MapType.addTarget(self, action: #selector(MapTypeChanged(_:)), for: .valueChanged)
        MapType.tag = 20
        
        //Travel Type Seg Con
        TravelType.frame = CGRect(x: (self.MapType.frame.width - self.MapType.frame.width) / 2, y: SettingsView.frame.height * 0.6, width: SettingsView.frame.width, height: SettingsView.frame.height * 0.1)
        TravelType.setSegmentItems(["Drive", "Walk", "Transport"])
        TravelType.delegate = self
        TravelType.addTarget(self, action: #selector(TravelTypeChanged(_:)), for: .touchUpInside)
        TravelType.addTarget(self, action: #selector(TravelTypeChanged(_:)), for: .valueChanged)
        TravelType.tag = 30
        
        //Done Button
        DoneButton.frame = CGRect(x: (self.DoneButton.frame.width - self.DoneButton.frame.width) / 2, y: SettingsView.frame.height * 0.8, width: SettingsView.frame.width, height: SettingsView.frame.height * 0.2)
        DoneButton.setTitle("Done", for: .normal)
        DoneButton.setTitleColor(self.view.tintColor!, for: .normal)
        
        DoneButton.addTarget(self, action: #selector(EndSettings), for: .touchUpInside)
        DoneButton.layer.zPosition = SettingsLabel.layer.zPosition
        
        //background Button
        BackgroundButton.frame = self.view.frame
        BackgroundButton.layer.zPosition = SettingsView.layer.zPosition - 1
        BackgroundButton.addTarget(self, action: #selector(handleTapGesture), for: .touchUpOutside)
        
        //Stack
//        StackView = UIStackView(arrangedSubviews: [SettingsButton, LocationButton])
//        StackView.axis = .vertical
//        StackView.translatesAutoresizingMaskIntoConstraints = false
//        StackView.dropShadow()
//        self.view.addSubview(StackView)
        
    }

    
    func Settings(){
        self.view.addSubview(EffectView)
        self.view.addSubview(SettingsView)
        //self.view.addSubview(BackgroundButton)
        
        
        SettingsView.addSubview(SettingsLabel)
        SettingsView.addSubview(MapType)
        SettingsView.addSubview(TravelType)
        SettingsView.addSubview(DoneButton)
        //SettingsView.addGestureRecognizer(DoneTapGesture)
        
        //DoneTapGesture.addTarget(self, action: #selector(handleTapGesture(_:)))
        if let GR = DoneButton.gestureRecognizers{
            DoneTapGesture.require(toFail: GR[0])
        }
        
        SettingsView.center = self.view.center
        
        SettingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        SettingsView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.SettingsView.alpha = 1
            self.SettingsView.transform = CGAffineTransform.identity
            
        }
        
        print("set", SettingsLabel.center.x, "view", self.view.center.x)
    }
    
    func EndSettings(){
        EffectView.removeFromSuperview()
        SettingsView.removeFromSuperview()
        SettingsLabel.removeFromSuperview()
        MapType.removeFromSuperview()
        TravelType.removeFromSuperview()
        DoneButton.removeFromSuperview()
        BackgroundButton.removeFromSuperview()
        
        //self.view.removeGestureRecognizer(DoneTapGesture)
        print("did end settings")
    }
    
    func BackToUserLocation(){
        mapKitView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
    }
    
    func MapTypeChanged(_ sender: TwicketSegmentedControl){
        print("maptype")
        
        
    }
    
    func TravelTypeChanged(_ sender: TwicketSegmentedControl){
        print("travek typeq")
    }
    
    func SetupMaps(){
        let LocationManager = CLLocationManager()
        mapKitView.frame = view.frame
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
                self.mapKitView.add(route.polyline, level: .aboveRoads)
                
                let rekt = route.polyline.boundingMapRect
                self.mapKitView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
                
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
    
//    func handleTapGesture(_ gestureRecognizer: UIGestureRecognizer) {
//        let location = gestureRecognizer.location(in: self.view)
//        print(location)
//        if !SettingsView.frame.contains(location){
//            EndSettings()
//        }
//    }
    func handleTapGesture() {
        print("handle")
        EndSettings()
    }
    
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if case .authorizedWhenInUse = status {
            manager.requestLocation()
        }
    }
    
    func displayInFlyoverMode() {
            mapKitView.mapType = .satelliteFlyover
            mapKitView.showsBuildings = true
            let location = SchoolLocation
            let altitude: CLLocationDistance  = 500
            let heading: CLLocationDirection = 90
            let pitch = CGFloat(45)
            //let camera = MKMapCamera(lookingAtCenterCoordinate: location, fromDistance: altitude, pitch: pitch, heading: heading)
            let camera = MKMapCamera(lookingAtCenter: location, fromDistance: altitude, pitch: pitch, heading: heading)
            mapKitView.setCamera(camera, animated: true)
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
            LocationManager.delegate = self
            LocationManager.desiredAccuracy = kCLLocationAccuracyBest
            LocationManager.startUpdatingLocation()
        }
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
 
    func didSelect(_ segmentIndex: Int, _ sender: TwicketSegmentedControl) {
        if sender.tag == 20{
            print("selected")
        }
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

extension CALayer{
    func roundCorners(corners: UIRectCorner, radius: CGFloat, viewBounds: CGRect) {
        
        let maskPath = UIBezierPath(roundedRect: viewBounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        mask = shape
    }
}

extension UIView {
    func round(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func dropShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
}
