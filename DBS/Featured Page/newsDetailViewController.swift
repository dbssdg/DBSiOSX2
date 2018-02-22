//
//  newsDetailViewController.swift
//  DBS
//
//  Created by Ben Lou on 23/12/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit
import SystemConfiguration

struct newsDetails : Decodable {
    let title : [String]
    let date : [String]
    let content : [String]
    let id : [String]
    let image : [String?]
}

class newsDetailViewController: UIViewController {

    var news : newsDetails?
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var newsTitle: UILabel!
    @IBOutlet var newsDate: UILabel!
    @IBOutlet var newsImage: UIImageView!
    @IBOutlet var newsContent: UITextView!
    @IBOutlet var previousNews: UIBarButtonItem!
    @IBOutlet var nextNews: UIBarButtonItem!
    
    @IBAction func previousNews(_ sender: Any) {
        newsIndex -= 1
        updateData()
        
    }
    @IBAction func nextNews(_ sender: Any) {
        newsIndex += 1
        updateData()
    }
    
    func updateData() {
        
        let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top - (navigationController?.navigationBar.frame.height)! - 18)
        scrollView.setContentOffset(desiredOffset, animated: false)
        self.title = "\(newsIndex+1) of \(newsTotal)"
        self.newsTitle.text? = self.news!.title[newsIndex]
        
        var newsDate = String(describing: Date(timeIntervalSince1970: Double(self.news!.date[newsIndex])!))
        newsDate.removeLast(15)
        let dateArr = newsDate.split(separator: "-")
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        self.newsDate.text = "\(months[Int(dateArr[1])!-1]) \(Int(dateArr[2])!), \(dateArr[0])"
        
        self.newsImage.image = UIImage(named: "newsImage")
        if self.news!.image[newsIndex] != nil {
            self.getImage("http://www.dbs.edu.hk/datafiles/image/\(self.news!.id[newsIndex])/\(self.news!.image[newsIndex]!)", self.newsImage)
        } else {
            self.getImage("http://www.dbs.edu.hk/datafiles/image/\(self.news!.id[newsIndex])/\(self.news!.image[newsIndex])", self.newsImage)
        }
        
        let htmlData = NSString(string: "\(self.news!.content[newsIndex])").data(using: String.Encoding.unicode.rawValue)
        let attributedString = try! NSAttributedString(data: htmlData!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        self.newsContent.attributedText = attributedString
        self.newsContent.font = UIFont(name: "Helvetica", size: 16)
        
        if newsIndex+1 <= 1 {
            previousNews.tintColor = UIColor.lightGray
            previousNews.isEnabled = false
        } else if newsIndex+1 >= newsTotal {
            nextNews.tintColor = UIColor.lightGray
            nextNews.isEnabled = false
        } else {
            previousNews.tintColor = UIColor.orange
            previousNews.isEnabled = true
            nextNews.tintColor = UIColor.black
            nextNews.isEnabled = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
        scrollView.setContentOffset(desiredOffset, animated: false)
        self.title = "\(newsIndex+1) of \(newsTotal)"
        newsTitle.text = ""
        newsDate.text = ""
        newsImage.image = nil
        newsContent.text = ""
        
        let jsonURL = "http://www.dbs.edu.hk/newsapp.php"
        let url = URL(string: jsonURL)
        let networkAlert = UIAlertController(title: "ERROR", message: "Please check your network availability.", preferredStyle: .alert)
        func backToFeaturedPage(action: UIAlertAction) { navigationController?.popViewController(animated: true) }
        networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: backToFeaturedPage))
        
        if isInternetAvailable() {
            
            let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            spinner.activityIndicatorViewStyle = .gray
            spinner.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
            spinner.startAnimating()
            spinner.hidesWhenStopped = true
            self.view.addSubview(spinner)
            
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                do {
                    let startLoadTime = Date()
                    self.news = try JSONDecoder().decode(newsDetails.self, from: data!)
                    
                    DispatchQueue.main.async {
                        spinner.stopAnimating()
                        print(Date(), startLoadTime)
//                        if self.news == nil {
//                            self.present(networkAlert, animated: true)
//                        } else {
                            self.updateData()
//                        }
                    }
                    
                }
                catch {
                    self.present(networkAlert, animated: true)
                    print("ERROR")
                }
            }.resume()
            
        } else {
            present(networkAlert, animated: true)
        }
        
        if newsIndex+1 <= 1 {
            previousNews.tintColor = UIColor.lightGray
            previousNews.isEnabled = false
        } else if newsIndex+1 >= newsTotal {
            nextNews.tintColor = UIColor.lightGray
            nextNews.isEnabled = false
        } else {
            previousNews.tintColor = UIColor.orange
            previousNews.isEnabled = true
            nextNews.tintColor = UIColor.black
            nextNews.isEnabled = true
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
    
    func getImage(_ urlStringOriginal: String, _ imageView: UIImageView) {
        var urlString = ""
        for i in urlStringOriginal {
            if i == " " { urlString += "%20" }
            else { urlString += "\(i)" }
        }
        let url = URL(string: urlString)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil {
                let image = UIImage(data: data!)
                if image != nil {
                    DispatchQueue.main.async(execute: {
                        imageView.image = image
                    })
                }
            }
        })
        task.resume()
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
