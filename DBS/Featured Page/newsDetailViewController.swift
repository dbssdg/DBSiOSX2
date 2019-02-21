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
    var attachment: [[String]]
}
var senderIsNews = false

class newsDetailViewController: UIViewController, URLSessionTaskDelegate, URLSessionDataDelegate {
    
    var news : newsDetails?
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var newsTitle: UILabel!
    @IBOutlet var newsDate: UILabel!
    @IBOutlet var newsImage: UIImageView!
    @IBOutlet var newsContent: UITextView!
    @IBOutlet var previousNews: UIBarButtonItem!
    @IBOutlet var nextNews: UIBarButtonItem!
    @IBOutlet var attachmentsButton: UIBarButtonItem!
    
    let sliderView = UIView()
    let slider = UISlider()
    
    @IBAction func previousNews(_ sender: Any) {
        newsIndex -= 1
        updateData()
        
        let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top - (navigationController == nil ? 0 : (navigationController?.navigationBar.frame.height)!) - 18)
        scrollView.setContentOffset(desiredOffset, animated: false)
        
        self.newsImage.image = #imageLiteral(resourceName: "newsImage")
        self.newsImage.clipsToBounds = true
        if self.news!.image[newsIndex] != nil {
            self.getImage("https://www.dbs.edu.hk/datafiles/image/\(self.news!.id[newsIndex])/\(self.news!.image[newsIndex]!)", self.newsImage)
        }
        
    }
    @IBAction func nextNews(_ sender: Any) {
        newsIndex += 1
        updateData()
        
        let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top - (navigationController == nil ? 0 : (navigationController?.navigationBar.frame.height)!) - 18)
        scrollView.setContentOffset(desiredOffset, animated: false)
        
        self.newsImage.image = #imageLiteral(resourceName: "newsImage")
        self.newsImage.clipsToBounds = true
        if self.news!.image[newsIndex] != nil {
            self.getImage("https://www.dbs.edu.hk/datafiles/image/\(self.news!.id[newsIndex])/\(self.news!.image[newsIndex]!)", self.newsImage)
        }
    }
    @IBAction func attachments(_ sender: Any) {
        if self.news != nil {
            circularViewURL = "https://www.dbs.edu.hk/"
            for i in self.news!.attachment[newsIndex] {
                circularViewURL += "https://www.dbs.edu.hk/datafiles/attachment/\(self.news!.id[newsIndex])/\(i)"
            }
            //            circularViewURL = "http://abc/http://www.dbs.edu.hk/datafiles/attachment/\(self.news!.id[newsIndex])/\(self.news!.attachment[newsIndex].joined())"
            senderIsNews = true
            performSegue(withIdentifier: "News Attachment", sender: self)
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
        
        if self.news != nil {
            
            attachmentsButton.title = "Attachments"
            if self.news!.attachment[newsIndex].isEmpty {
                attachmentsButton.tintColor = UIColor.lightGray
                attachmentsButton.isEnabled = false
            } else {
                if self.news!.attachment[newsIndex].count == 1 {
                    attachmentsButton.title = "Attachment"
                }
                attachmentsButton.tintColor = UIColor(red: 51/255, green: 120/255, blue: 246/255, alpha: 1)
                attachmentsButton.isEnabled = true
            }
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
        
        let jsonURL = "https://www.dbs.edu.hk/dbsapp/newsapp.txt"
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
                        if var data = data {
                            
//                            let dataString = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\"\"", with: "[]")
//                            print("\n\(dataString)\n")
//                            data = dataString.data(using: .utf8)!
                            
//                            data = """
//{"title":["Results of Sports for All Programme","DBS 150 Run","Speech Day Photos","Second Term of Sports for All"],"date":["1550466480","1550199960","1548823927","1547570700"],"content":["<p>Sports have always been an integral part of our school programme and we are still recruiting students to join this programme.&nbsp;&nbsp;Those who are interested please complete and submit the attached reply slip along with a cheque made payable to&nbsp;<i>&ldquo;Diocesan Boys&rsquo; School&rdquo;</i>&nbsp;to the Sports Office immediately.<br />\r\n<br />\r\nWe hope students can take this opportunity to enjoy the fun in playing sports.<br />\r\n<br />\r\nFor enquiries, please contact Sport Office, Ms. Anne Cheng at 2192 0937.</p>","<p>All students, old boys, parents and teachers&nbsp;are invited to&nbsp;join the DBS 150 Run event. For details, please refer to the attachment.</p>","<p>Congratulations to all prize winners and the graduating class of 2019! Official photos are available through the following link.</p>\r\n\r\n<p><a href=\"https://photos.app.goo.gl/1fW7ew6ZyqXjLdCG6\" target=\"_blank\">https://photos.app.goo.gl/1fW7ew6ZyqXjLdCG6</a></p>","<p>Please refer to the attachment.</p>"],"id":["1382","1380","1378","1375"],"ext_content":["","","",""],"sticky":["0","1","1","0"],"attachment":[[],[],[],[]],"image":[null, null, null, null]}
//""".data(using: .utf8)!
                            print("\n"+String(data: data, encoding: .utf8)!+"\n")
                            self.news = try JSONDecoder().decode(newsDetails.self, from: data)
                            
                            DispatchQueue.main.async {
                                spinner.stopAnimating()
                                self.updateData()
                                self.newsImage.image = #imageLiteral(resourceName: "newsImage")
                                self.newsImage.clipsToBounds = true
                                if self.news!.image[newsIndex] != nil {
                                    self.getImage("https://www.dbs.edu.hk/datafiles/image/\(self.news!.id[newsIndex])/\(self.news!.image[newsIndex]!)", self.newsImage)
                                }
                            }
                        }
                    } catch {
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
        attachmentsButton.tintColor = UIColor.lightGray
        attachmentsButton.isEnabled = false
        
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
        slider.tintColor = UIColor.black
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        sliderView.addSubview(slider)
        
        //        let sliderTitle = UILabel()
        //        sliderTitle.frame = CGRect(x: 0, y:0, width: self.view.frame.width, height: 65)
        //        sliderTitle.text = "Adjust Font Size"
        //        sliderTitle.textAlignment = .center
        //        sliderTitle.font = UIFont(name: "Helvetica Bold", size: 30)
        //        sliderView.addSubview(sliderTitle)
        let smallA = UILabel(frame: CGRect(x: self.view.frame.width*0.15, y:0, width: self.view.frame.width/10, height: 50))
        smallA.text = "A"
        smallA.font = UIFont(name: "Helvetica Bold", size: 9)
        sliderView.addSubview(smallA)
        let bigA = UILabel(frame: CGRect(x: self.view.frame.width*0.85, y:0, width: self.view.frame.width/10, height: 50))
        bigA.text = "A"
        bigA.font = UIFont(name: "Helvetica Bold", size: 30)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        senderIsNews = true
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
                        imageView.clipsToBounds = true
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

extension UIImageView {
    func getImage(_ urlString: String) {
        let url = URL(string: urlString.replacingOccurrences(of: " ", with: "%20"))!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil {
                let image = UIImage(data: data!)
                if image != nil {
                    DispatchQueue.main.async(execute: {
                        self.image = image
                    })
                }
            }
        })
        task.resume()
    }
}
