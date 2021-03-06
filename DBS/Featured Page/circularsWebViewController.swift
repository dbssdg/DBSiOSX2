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

class circularsWebViewController: UIViewController, UIWebViewDelegate, TwicketSegmentedControlDelegate {
    
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
                //                var temp = "http\(arr[i])"
                //                temp = temp.decodeUrl()
                arr[i] = "http\(arr[i])".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
                arr[i] = arr[i].replacingOccurrences(of: "%25", with: "%")
                arr[i] = arr[i].replacingOccurrences(of: "%3A", with: ":")
                arr[i] = arr[i].replacingOccurrences(of: "%2F", with: "/")
                arr[i] = arr[i].replacingOccurrences(of: "+", with: "%20")
                //                for j in temp {
                //                    if j == " " || j == "+" {
                //                        arr[i] += "%20"
                //                    } else if j == "‐" {
                //                        arr[i] += "%E2%80%90"
                //                    } else if j == "#" {
                //                        arr[i] += "%23"
                //                    } else {
                //                        arr[i] += "\(j)"
                //                    }
                //                }
            }
            print(arr)
        } else {
            let networkAlert = UIAlertController(title: "ERROR", message: "Please check your network availability.", preferredStyle: .alert)
            networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(networkAlert, animated: true)
        }
        
        circularWebView.scalesPageToFit = true
        circularWebView.delegate = self
        setUpSegmentedControl()
        didSelect(0)
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.shareCircular))
        self.navigationItem.rightBarButtonItem = shareButton
        
        if senderIsNews {
            self.title = "Attachment"
            senderIsNews = false
        }
        
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
    
    let spinner = UIActivityIndicatorView()
    func webViewDidStartLoad(_ webView: UIWebView) {
        spinner.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        spinner.activityIndicatorViewStyle = .white
        spinner.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        spinner.backgroundColor = UIColor.gray
        spinner.layer.cornerRadius = 10
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        spinner.layer.zPosition = 100000
        self.view.addSubview(spinner)
        webView.isUserInteractionEnabled = false
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        spinner.stopAnimating()
        webView.isUserInteractionEnabled = true
    }
    
    func shareCircular() {
        let activityViewController = UIActivityViewController(
            activityItems: [URL(string: arr[selectedSegment-1])!], applicationActivities: nil)
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
        if arr.count != 0 {
            for i in 1...arr.count {
                titles += ["#\(i)"]
            }
        }
        var frame = CGRect(x: 0 , y: self.view.frame.height - 40, width: self.view.frame.width, height: 40)
        if UIDevice().userInterfaceIdiom == .phone && (UIScreen.main.nativeBounds.height >= 2436 || UIScreen.main.nativeBounds.height == 1792) {
            frame = CGRect(x: 0 , y: self.view.frame.height - 55, width: self.view.frame.width, height: 40)
        }
        let segmentedControl = TwicketSegmentedControl(frame: frame)
        segmentedControl.setSegmentItems(titles)
        segmentedControl.delegate = self
        segmentedControl.tag = 1
        if titles.count > 1 {
            view.addSubview(segmentedControl)
        } else {
            circularWebView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 40).isActive = false
            circularWebView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
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


