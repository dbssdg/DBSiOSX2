//
//  circularsWebViewController.swift
//  DBS
//
//  Created by Ben Lou on 22/12/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit
import WebKit
import TwicketSegmentedControl
import SystemConfiguration

class circularsWebViewController: UIViewController, TwicketSegmentedControlDelegate {

    @IBOutlet weak var circularWebView: UIWebView!
    var selectedSegment = 0
    var arr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if isInternetAvailable() {
            let string = circularViewURL
            arr = string.components(separatedBy: "http")
            arr.removeFirst(2)
            for i in 0..<arr.count {
                var temp = "http\(arr[i])"
                temp = temp.decodeUrl()
                print(temp)
                arr[i] = ""
//                arr[i] = temp.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                for j in temp {
                    if j == " " || j == "+" {
                        arr[i] += "%20"
                    } else if j == "‐" {
                        arr[i] += "%E2%80%90"
                    } else if j == "#" {
                        arr[i] += "%23"
                    } else {
                        arr[i] += "\(j)"
                    }
                }
            }
            print(arr)
        } else {
            let networkAlert = UIAlertController(title: "ERROR", message: "Please check your network availability.", preferredStyle: .alert)
            networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(networkAlert, animated: true)
        }
        
        circularWebView.scalesPageToFit = true
        setUpSegmentedControl()
        didSelect(0)
        
        let shareButton = UIBarButtonItem(image: #imageLiteral(resourceName: "share-arrow"), style: .plain, target: self, action: #selector(self.shareCircular))
        self.navigationItem.rightBarButtonItem = shareButton
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shareCircular() {
        let activityViewController = UIActivityViewController(
            activityItems: [URL(string: circularViewURL)!], applicationActivities: nil)
//
//        // This line is for the popover you need to show in iPad
//        activityViewController.popoverPresentationController?.sourceView = navigationItem.rightBarButtonItem
//        // This line remove the arrow of the popover to show in iPad
//        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        activityViewController.excludedActivityTypes = []
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func didSelect(_ segmentIndex: Int) {
        selectedSegment = segmentIndex+1
        print(arr)
        circularWebView.loadRequest(NSURLRequest(url: NSURL(string: arr[segmentIndex])! as URL) as URLRequest)
    }
    
    func setUpSegmentedControl() {
        var titles = [String]()
        for i in 1...arr.count {
            titles += ["#\(i)"]
        }
        let frame = CGRect(x: self.view.frame.width / 2 - self.view.frame.width * 0.45 , y: self.view.frame.height * 0.93, width: self.view.frame.width * 0.9, height: 40)
        let segmentedControl = TwicketSegmentedControl(frame: frame)
        segmentedControl.setSegmentItems(titles)
        segmentedControl.delegate = self as? TwicketSegmentedControlDelegate
        segmentedControl.tag = 1
        if titles.count > 1 {
            view.addSubview(segmentedControl)
        }
        
    }
    
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


