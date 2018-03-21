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

class newsDetailViewController: UIViewController, URLSessionTaskDelegate, URLSessionDataDelegate {

    var news : newsDetails?
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var newsTitle: UILabel!
    @IBOutlet var newsDate: UILabel!
    @IBOutlet var newsImage: UIImageView!
    @IBOutlet var newsContent: UITextView!
    @IBOutlet var previousNews: UIBarButtonItem!
    @IBOutlet var nextNews: UIBarButtonItem!
    
    let sliderView = UIView()
    let slider = UISlider()
    
    @IBAction func previousNews(_ sender: Any) {
        newsIndex -= 1
        updateData()
        
        let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top - (navigationController == nil ? 0 : (navigationController?.navigationBar.frame.height)!) - 18)
        scrollView.setContentOffset(desiredOffset, animated: false)
        
        self.newsImage.image = #imageLiteral(resourceName: "newsImage")
        if self.news!.image[newsIndex] != nil {
            self.getImage("http://www.dbs.edu.hk/datafiles/image/\(self.news!.id[newsIndex])/\(self.news!.image[newsIndex]!)", self.newsImage)
        }
        
    }
    @IBAction func nextNews(_ sender: Any) {
        newsIndex += 1
        updateData()
        
        let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top - (navigationController == nil ? 0 : (navigationController?.navigationBar.frame.height)!) - 18)
        scrollView.setContentOffset(desiredOffset, animated: false)
        
        self.newsImage.image = #imageLiteral(resourceName: "newsImage")
        if self.news!.image[newsIndex] != nil {
            self.getImage("http://www.dbs.edu.hk/datafiles/image/\(self.news!.id[newsIndex])/\(self.news!.image[newsIndex]!)", self.newsImage)
        }
    }
    
    func updateData() {
        
        self.title = "\(newsIndex+1) of \(newsTotal)"
        self.newsTitle.text? = self.news!.title[newsIndex]
        
        var newsDate = String(describing: Date(timeIntervalSince1970: Double(self.news!.date[newsIndex])!))
        newsDate.removeLast(15)
        let dateArr = newsDate.split(separator: "-")
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        self.newsDate.text = "\(months[Int(dateArr[1])!-1]) \(Int(dateArr[2])!), \(dateArr[0])"
        
        let htmlData = NSString(string: "\(self.news!.content[newsIndex])").data(using: String.Encoding.unicode.rawValue)
        let attributedString = try! NSAttributedString(data: htmlData!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        self.newsContent.attributedText = attributedString
        self.newsContent.font = UIFont(name: "Helvetica", size: CGFloat(slider.value))
        
        if newsIndex+1 <= 1 {
            previousNews.tintColor = UIColor.lightGray
            previousNews.isEnabled = false
            nextNews.tintColor = UIColor.black
            nextNews.isEnabled = true
        } else if newsIndex+1 >= newsTotal {
            previousNews.tintColor = UIColor.orange
            previousNews.isEnabled = true
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
            
            if news == nil {
                let request = NSMutableURLRequest(url: url!)
                request.httpMethod = "POST"
                request.addValue("Keep-Alive", forHTTPHeaderField: "Connection")
                
                let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
    //            session.setValue("Keep-Alive", forKey: "Connection")
                
    //            session.uploadTask(with: <#T##URLRequest#>, fromFile: url!, completionHandler: <#T##(Data?, URLResponse?, Error?) -> Void#>)
                
                session.dataTask(with: url!) { (data, response, error) in
                    do {
                        self.news = try JSONDecoder().decode(newsDetails.self, from: data!)
                        DispatchQueue.main.async {
                            spinner.stopAnimating()
    //                        if self.news == nil {
    //                            self.present(networkAlert, animated: true)
    //                        } else {
                                self.updateData()
                                self.newsImage.image = #imageLiteral(resourceName: "newsImage")
                                if self.news!.image[newsIndex] != nil {
                                    self.getImage("http://www.dbs.edu.hk/datafiles/image/\(self.news!.id[newsIndex])/\(self.news!.image[newsIndex]!)", self.newsImage)
                                }
    //                        }
                        }
                        
                    }
                    catch {
                        self.present(networkAlert, animated: true)
                        print(error)
                    }
                }.resume()
            }
        } else {
            present(networkAlert, animated: true)
        
        }
       
        
        previousNews.tintColor = UIColor.lightGray
        previousNews.isEnabled = false
        nextNews.tintColor = UIColor.lightGray
        nextNews.isEnabled = false
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        // Slider Components
        
        let setFontSizeButton = UIBarButtonItem(title: "Aa", style: .plain, target: self, action: #selector(setFontSize))
        self.navigationItem.rightBarButtonItem = setFontSizeButton
        
        sliderView.backgroundColor = UIColor.lightGray
        sliderView.frame = CGRect(x: 8, y: self.view.frame.height, width: self.view.frame.width - 16, height: 50)
        sliderView.layer.cornerRadius = 20
        sliderView.layer.zPosition = 1000
        self.view.addSubview(sliderView)
        
        slider.frame = CGRect(x: self.view.frame.width*0.25, y: 20, width: self.view.frame.width/2, height: 20)
        slider.minimumValue = 9
        slider.maximumValue = 40
        
        if UserDefaults.standard.integer(forKey: "fontSize") != 0 {
            slider.value = Float(UserDefaults.standard.integer(forKey: "fontSize"))
        } else {
            slider.value = 14
        }
        sliderValueChanged(slider)
        
        slider.isContinuous = true
        slider.tintColor = UIColor.blue
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        sliderView.addSubview(slider)
        
        //        let sliderTitle = UILabel()
        //        sliderTitle.frame = CGRect(x: 0, y:0, width: self.view.frame.width, height: 65)
        //        sliderTitle.text = "Adjust Font Size"
        //        sliderTitle.textAlignment = .center
        //        sliderTitle.font = UIFont(name: "Helvetica", size: 30)
        //        sliderView.addSubview(sliderTitle)
        let smallA = UILabel(frame: CGRect(x: self.view.frame.width*0.15, y:0, width: self.view.frame.width/10, height: 50))
        smallA.text = "A"
        smallA.font = UIFont(name: "Helvetica", size: 9)
        sliderView.addSubview(smallA)
        let bigA = UILabel(frame: CGRect(x: self.view.frame.width*0.85, y:0, width: self.view.frame.width/10, height: 50))
        bigA.text = "A"
        bigA.font = UIFont(name: "Helvetica", size: 30)
        sliderView.addSubview(bigA)
        
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
    
    func setFontSize(_ sender: UIBarButtonItem) {
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(finishedSetFontSize(_:)))
        self.navigationItem.rightBarButtonItem = doneButton
        //        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.sliderView.frame.origin.y = self.view.frame.height - (self.tabBarController == nil ? 15: (self.tabBarController?.tabBar.frame.height)!) - 50
        }, completion: nil)
    }
    func finishedSetFontSize(_ sender: UIBarButtonItem) {
        let setFontSizeButton = UIBarButtonItem(title: "Aa", style: .plain, target: self, action: #selector(setFontSize))
        self.navigationItem.rightBarButtonItem = setFontSizeButton
        //        self.view.backgroundColor = UIColor.white
        
        UIView.animate(withDuration: 0.3, animations: {
            self.sliderView.frame.origin.y = self.view.frame.height
        }, completion: nil)
    }
    func sliderValueChanged(_ sender: UISlider) {
        UserDefaults.standard.set(slider.value, forKey: "fontSize")
        if news != nil {
            updateData()
        }
    }
    
    let progressView = UIProgressView()
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("ERROR")
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("Did Send Body Data")
        let uploadProgress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        progressView.frame = CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: 10)
        progressView.center = self.view.center
        progressView.progress = 0
        progressView.progress = uploadProgress
        progressView.layer.borderWidth = 10
        progressView.layer.zPosition = 100000
        progressView.layer.borderColor = UIColor.black as! CGColor
        self.view.addSubview(progressView)
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        print("Did Receive Response")
        progressView.isHidden = true
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
