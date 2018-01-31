//
//  LinksViewController.swift
//  DBS
//
//  Created by SDG on 3/10/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit
import TwicketSegmentedControl
import MapKit
import MessageUI

class LinksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TwicketSegmentedControlDelegate {
    
    var selectedSegment = 0
    
    let linkSection = ["Links"]
    let contactSections = ["Address", "Phone", "Fax", "Email"]
    let stepsSections = ["Weekdays", "Saturdays", "Sundays"]
    
    let links = ["DBS Homepage", "eClass", "qClass", "DBS Facebook", "Boarding School", "Software Development Group", "SDG Facebook"]
    let hyperlinks = ["www.dbs.edu.hk", "eclass.dbs.edu.hk", "qclass.dbs.edu.hk", "zh-hk.facebook.com/hkdbs", "sites.google.com/site/dbsboarding/", "cl.dbs.edu.hk", "www.facebook.com/DBSSDG"]
    
    let address = ["131 Argyle Street, Mong Kok, Kowloon"]
    let phone = ["2711 5191", "2711 5192"]
    let fax = ["2761 1026"]
    let email = ["dbsadmin@dbs.edu.hk"]
    
    let weekdays = ["7:00 am ~ 9:00 am", "12:30 pm ~ 2:00 pm", "2:45 pm ~ 6:30 pm"]
    let saturdays = ["7:30 am ~ 1:30 pm"]
    let sundays = ["7:30 am ~ 12:30 pm", "Closed on Sundays and public holidays.", "Closed on school holidays.", "Please use the Argyle Street entrance."]
    
    var sectionData : [Int: [String]] = [:]
    
    @IBOutlet weak var linksTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSegmentedControl()
        
        linksTable.dataSource = self
        linksTable.delegate = self
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        sectionData = [0: links]
        self.title = "Links"
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func didSelect(_ segmentIndex: Int) {
        selectedSegment = segmentIndex
        switch selectedSegment {
        case 0:
            sectionData = [0: links]
            self.title = "Links"
        case 1:
            sectionData = [0: address, 1: phone, 2: fax, 3: email]
            self.title = "Contact"
        case 2:
            sectionData = [0: weekdays, 1: saturdays, 2: sundays]
            self.title = "Steps Opening Hours"
        default: break
        }
        linksTable.reloadData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (sectionData[section]?.count)!
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch selectedSegment {
        case 0:
            return linkSection[section]
        case 1:
            return contactSections[section]
        case 2:
            return stepsSections[section]
        default: break
        }
        return nil
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "linksCell")! as UITableViewCell
        cell.textLabel?.text = sectionData[indexPath.section]?[indexPath.row]
        if selectedSegment == 2 {
            cell.selectionStyle = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch selectedSegment {
        case 0:
            if let url = NSURL(string: "http://\(hyperlinks[indexPath.row])/") {
                UIApplication.shared.openURL(url as URL)
            }
        case 1:
            contactSelected(indexPath.section, indexPath.row)
        default: break
        }
    }
    func setUpSegmentedControl() {
        let titles = ["Links", "Contact", "Steps"]
        let frame = CGRect(x: 0, y: self.view.frame.height * 0.8, width: self.view.frame.width, height: 40)
        let segmentedControl = TwicketSegmentedControl(frame: frame)
        segmentedControl.setSegmentItems(titles)
        segmentedControl.delegate = self as? TwicketSegmentedControlDelegate
        view.addSubview(segmentedControl)
    }
    func contactSelected(_ section: Int, _ row: Int) {
        switch section {
        case 0:
            let latitude: CLLocationDegrees = 22.323583
            let longitude: CLLocationDegrees = 114.174227
            
            let regionDistance:CLLocationDistance = 10000
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
            ]
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "Diocesan Boys' School"
            mapItem.openInMaps(launchOptions: options)
            
        case 1:
            if let url = URL(string: "tel://\(phone[row])"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) { UIApplication.shared.open(url) }
                else { UIApplication.shared.openURL(url) }
            }
            
        case 2:
            if let url = URL(string: "tel://\(fax[row])"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) { UIApplication.shared.open(url) }
                else { UIApplication.shared.openURL(url) }
            }
            
        case 3:
            if !MFMailComposeViewController.canSendMail() {
                let cannotSendAlert = UIAlertController(title: "Mail services are not available.", message: "", preferredStyle: .alert)
                cannotSendAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(cannotSendAlert, animated: true)
            } else {
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self as! MFMailComposeViewControllerDelegate
                composeVC.setToRecipients(["address@example.com"])
                composeVC.setSubject("Hello!")
                composeVC.setMessageBody("Hello from California!", isHTML: false)
                self.present(composeVC, animated: true, completion: nil)
            }
            
        default: break
        }
    }
    /* func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    } */
    
}
    


