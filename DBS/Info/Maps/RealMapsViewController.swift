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

enum TransportType{
    case Walking
    case PublicTransport
    case Car
    
}

class RealMapsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, TwicketSegmentedControlDelegate{
    func didSelect(_ segmentIndex: Int) {
        
    }
    
    
    let MapView = MKMapView()
    
    let SchoolLocation = CLLocationCoordinate2DMake(22.322924, 114.174229)
    
    let EffectView = UIVisualEffectView()
    let SettingsView = UIView()
    
    let SettingsLabel = UILabel()
    var MapType = UISegmentedControl()
    var TravelType = UISegmentedControl()
    let DoneButton = UIButton()
    
    var DoneTapGesture = UIGestureRecognizer()
    
    let BackgroundButton = UIButton()
    
    var MapTypeString = "MapTypeString"
    var TravelTypeString = "TravelTypeString"
    
    var StackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Maps"
        self.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        var MapTypeNo = 0
        
        if let x = UserDefaults.standard.object(forKey: TravelTypeString) as? Int{
            MapTypeNo = x
        }
        
        
        SetupMaps(TravelType: MapTypeNo)
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
        SettingsLabel.frame = C GRect(x: self.SettingsView.center.x - self.SettingsLabel.frame.width / 2, y:  SettingsView.frame.height * 0.15, width: 100, height: 100)
        SettingsLabel.text = "Maps Settings"
        SettingsLabel.textColor = UIColor.darkText
        SettingsLabel.font = UIFont.init(name: "Helvetica Light", size: 26)
    
        SettingsLabel.sizeToFit()
        SettingsLabel.frame.origin = CGPoint(x: (self.SettingsView.frame.width - self.SettingsLabel.frame.width) / 2, y:  SettingsView.frame.height * 0.1)
        
        SettingsLabel.layer.zPosition = SettingsView.layer.zPosition * 10
        
        //Map Type Seg Con
        MapType = UISegmentedControl(items: ["Map", "Transit", "Satellite"])
        MapType.frame = CGRect(x:  (self.MapType.frame.width - self.MapType.frame.width) / 2 + self.SettingsView.frame.width * 0.1, y: SettingsView.frame.height * 0.35, width: SettingsView.frame.width * 0.8, height: SettingsView.frame.height * 0.15)
        //MapType.setSegmentItems(["Map", "Transport", "Satellite"])
//        MapType.setTitle("Map", forSegmentAt: 0)
//        MapType.setTitle("Transport", forSegmentAt: 1)
//        MapType.setTitle("Satellite", forSegmentAt: 2)
        //MapType.delegate = self
        //MapType.addTarget(self, action: #selector(MapTypeChanged), for: .touchUpInside)
        MapType.addTarget(self, action: #selector(MapTypeChanged), for: .valueChanged)
        MapType.selectedSegmentIndex = 0
        MapType.tag = 20
        
        //Travel Type Seg Con
        TravelType = UISegmentedControl(items: ["Drive", "Walk", "Transport"])
        TravelType.frame = CGRect(x: (self.MapType.frame.width - self.MapType.frame.width) / 2 + self.SettingsView.frame.width * 0.1, y: SettingsView.frame.height * 0.6, width: SettingsView.frame.width * 0.8, height: SettingsView.frame.height * 0.15)
//        TravelType.setTitle("Drive", forSegmentAt: 0)
//        TravelType.setTitle("Walk", forSegmentAt: 1)
//        TravelType.setTitle("Transport", forSegmentAt: 2)
        //TravelType.delegate = self
        //TravelType.addTarget(self, action: #selector(TravelTypeChanged), for: .touchUpInside)
        TravelType.addTarget(self, action: #selector(TravelTypeChanged), for: .valueChanged)
        
        var MapTypeNo = 0
        
        if let x = UserDefaults.standard.object(forKey: TravelTypeString) as? Int{
            MapTypeNo = x
        }
        
        TravelType.selectedSegmentIndex = MapTypeNo
        
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
        
        
        //self.view.removeGestureRecognizer(DoneTapGesture)
        print("did end settings")
        
        UIView.animate(withDuration: 0.3, animations: {
            self.SettingsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.SettingsView.alpha = 0
            
            
        }) { (success:Bool) in
            self.EffectView.removeFromSuperview()
            self.SettingsView.removeFromSuperview()
            self.SettingsLabel.removeFromSuperview()
            self.MapType.removeFromSuperview()
            self.TravelType.removeFromSuperview()
            self.DoneButton.removeFromSuperview()
            self.BackgroundButton.removeFromSuperview()
        }
    }
    
    func BackToUserLocation(){
        MapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
    }
    
    func MapTypeChanged(){
        print("maptype")
        if MapType.selectedSegmentIndex == 0{
            MapView.mapType = .standard
            MapView.showsBuildings = false
            
        }else if MapType.selectedSegmentIndex == 1{
            self.openMapInTransitMode()
        }else if MapType.selectedSegmentIndex == 2{
            self.displayInFlyoverMode()
        }
        
        
    }
    
    func TravelTypeChanged(){
        
//        if TravelType.selectedSegmentIndex == 0{
//            directionRequest.transportType = .automobile
//        }else if TravelType.selectedSegmentIndex == 1{
//            directionRequest.transportType = .walking
//        }else if TravelType.selectedSegmentIndex == 2{
//            directionRequest.transportType = .transit
//        }
        //self.MapView.removeFromSuperview()
        
        
        SetupMaps(TravelType: TravelType.selectedSegmentIndex)
        
        UserDefaults.standard.set(TravelType.selectedSegmentIndex, forKey: TravelTypeString)
        
        
    }
    
    func SetupMaps(TravelType: Int){
        let LocationManager = CLLocationManager()
        MapView.frame = view.frame
        MapView.tag = 1
        
        var hasSubview = false
        for i in self.view.subviews{
            if i == MapView{
                hasSubview = true
            }
        }
        if !hasSubview{
            self.view.addSubview(MapView)
        }
        
        MapView.delegate = self as! MKMapViewDelegate
        MapView.showsUserLocation = true
        
        
        
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
            
            if TravelType == 0{
                directionRequest.transportType = .automobile
            }else if TravelType == 1{
                directionRequest.transportType = .walking
            }else if TravelType == 2{
                directionRequest.transportType = .transit
            }
            
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
                self.MapView.add(route.polyline, level: .aboveRoads)
                
                let rekt = route.polyline.boundingMapRect
                self.MapView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
                
            })
        }
        
        
        let pin = CustomPin(coordinate: SchoolLocation, title: "Diocesan Boys' School", subtitle: "Hong Kong")
        MapView.centerCoordinate = pin.coordinate
        MapView.addAnnotation(pin)
        
        //Properties
        MapView.showsCompass = true
        MapView.showsTraffic = true
        MapView.showsScale = true
        
        
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
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        var MapTypeNo = 0
        
        if let x = UserDefaults.standard.object(forKey: TravelTypeString) as? Int{
            MapTypeNo = x
        }
        
        SetupMaps(TravelType: MapTypeNo)
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if case .authorizedWhenInUse = status {
            manager.requestLocation()
        }
    }
    
    func displayInFlyoverMode() {
            MapView.mapType = .satelliteFlyover
            MapView.showsBuildings = true
            let location = SchoolLocation
            let altitude: CLLocationDistance  = 500
            let heading: CLLocationDirection = 90
            let pitch = CGFloat(45)
            //let camera = MKMapCamera(lookingAtCenterCoordinate: location, fromDistance: altitude, pitch: pitch, heading: heading)
            let camera = MKMapCamera(lookingAtCenter: location, fromDistance: altitude, pitch: pitch, heading: heading)
            MapView.setCamera(camera, animated: true)
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
