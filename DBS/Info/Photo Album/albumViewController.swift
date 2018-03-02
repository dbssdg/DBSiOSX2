//
//  albumViewController.swift
//  DBS
//
//  Created by SDG on 11/1/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit
import TwicketSegmentedControl
import SystemConfiguration

struct Token : Decodable {
    let access_token : String
}

struct AlbumCollection : Decodable {
    let data : [[String : String]]
}

struct Thumbnail : Decodable {
    let url : String
}
struct Snippet : Decodable {
    let publishedAt : String
    let channelId : String
    let title : String
    let description : String
    let thumbnails : [String: Thumbnail]
    let channelTitle : String
    let resourceId : [String: String]
}
struct Item : Decodable {
    let snippet : Snippet
}
struct VideoCollection : Decodable {
    let items : [Item]
}

var albumSelected = 0

var photoToken = String()
var albumAlbum : AlbumCollection?

class albumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UIViewControllerPreviewingDelegate, TwicketSegmentedControlDelegate {

    var selectedSegment = 0
    @IBOutlet weak var videoTable: UITableView!
    @IBOutlet weak var albumCollection: UICollectionView!
    
    let photoBaseURL = URL(string: "http://cl.dbs.edu.hk/iphone/links/photo.txt")!
    let photoTokenURL = URL(string: "https://graph.facebook.com/oauth/access_token?client_id=568467823184139&client_secret=44ec4ab138f887ee547ee335ec476a8e&grant_type=client_credentials")!
    
    var base : String?
    var token : Token?
    
    let videoURL = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=20&playlistId=UUdqRwSotQRLAiz50Vi2BqQg&key=AIzaSyDLsMzZr2mcU5Uksnwo5goqTaqE5sIzcnE")!
    var videoCollection : VideoCollection?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        albumSelected = 0
        photoToken = ""
        albumAlbum = nil
        
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        spinner.activityIndicatorViewStyle = .gray
        spinner.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        self.view.addSubview(spinner)
        
        if isInternetAvailable() {
        
            if let url = URL(string: "http://cl.dbs.edu.hk/iphone/links/photo.txt") {
                do {
                    self.base = try String(contentsOf: url)
                    print(self.base)
                    
                    DispatchQueue.main.async {
                        
                        URLSession.shared.dataTask(with: self.photoTokenURL) { (data, response, error) in
                            do {
                                self.token = try JSONDecoder().decode(Token?.self, from: data!)
                                photoToken = String(describing: self.token!.access_token)
                                photoToken = photoToken.replacingOccurrences(of: "|", with: "%7C")
                                
                                DispatchQueue.main.async {
                                    URLSession.shared.dataTask(with: URL(string: "\(self.base!)?access_token=\(photoToken)")!) { (data, response, error) in
                                        do {
                                            print("\(self.base)?access_token=\(photoToken)")
                                            albumAlbum = try JSONDecoder().decode(AlbumCollection?.self, from: data!)
                                            print(albumAlbum?.data)
                                            for i in (albumAlbum?.data)! {
                                                print(i)
                                            }
                                            
                                            DispatchQueue.main.async {
                                                self.albumCollection.reloadData()
                                                spinner.stopAnimating()
                                            }
                                            
                                        } catch {
                                            print("ERROR PHOTO")
                                        }
                                    }.resume()
                                }
                                
                            } catch {
                                print("ERROR TOKEN")
                            }
                        }.resume()
                        
                    }
                    
                } catch {
                    let networkAlert = UIAlertController(title: "ERROR", message: "Please check your network availability.", preferredStyle: .alert)
                    func backToChoosePage(action: UIAlertAction) { navigationController?.popViewController(animated: true) }
                    networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: backToChoosePage))
                    present(networkAlert, animated: true)
                    print("ERROR BASE")
                }
            }
            
            URLSession.shared.dataTask(with: videoURL) { (data, response, error) in
                do {
                    self.videoCollection = try JSONDecoder().decode(VideoCollection?.self, from: data!)
                    for i in (self.videoCollection?.items)! {
                        print((i.snippet.thumbnails["high"]?.url)!, (i.snippet.title))
                    }
                    
                    DispatchQueue.main.async {
                        self.videoTable.reloadData()
                    }
                    
                } catch {
                    print("ERROR VIDEO")
                }
            }.resume()
        
        } else {
            let networkAlert = UIAlertController(title: "ERROR", message: "Please check your network availability.", preferredStyle: .alert)
            func backToChoosePage(action: UIAlertAction) { navigationController?.popViewController(animated: true) }
            networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: backToChoosePage))
            present(networkAlert, animated: true)
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (self.view.frame.width-2)/2, height: (self.view.frame.width-2)/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        albumCollection!.collectionViewLayout = layout
        
        self.registerForPreviewing(with: self, sourceView: albumCollection)
        self.registerForPreviewing(with: self, sourceView: videoTable)
        
        didSelect(0)
        setUpSegmentedControl()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        imageArray.removeAll()
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if albumAlbum?.data == nil {
            return 0
        }
        return (albumAlbum?.data)!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCell", for: indexPath) as! albumCollectionViewCell
        getImage("http://graph.facebook.com/\((albumAlbum?.data[indexPath.row]["id"])!)/picture", cell.image)
        cell.albumDescription.text = albumAlbum?.data[indexPath.row]["name"]
        cell.albumDescription.numberOfLines = 0
        cell.albumDescription.adjustsFontSizeToFitWidth = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        albumSelected = indexPath.row
        performSegue(withIdentifier: "Photo Segue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.videoCollection?.items == nil {
            return 0
        }
        return (self.videoCollection?.items)!.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell") as! videoTableViewCell
        getImage((self.videoCollection?.items[indexPath.row].snippet.thumbnails["medium"]?.url)!, cell.thumbnail)
        cell.videoTitle?.text = self.videoCollection?.items[indexPath.row].snippet.title
        cell.videoTitle?.adjustsFontSizeToFitWidth = true
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = NSURL(string: "http://www.youtube.com/watch?v=\((self.videoCollection?.items[indexPath.row].snippet.resourceId["videoId"])!)/") {
            print(url)
            UIApplication.shared.open(url as URL)
        }
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        tableView.cellForRow(at: indexPath)?.selectionStyle = .default
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell") as! videoTableViewCell
        return cell.thumbnail.frame.height + 16
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if previewingContext.sourceView == albumCollection {
            guard let indexPath = videoTable.indexPathForRow(at: location) else {
                return nil
            }
            albumSelected = indexPath.row
            let destViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Photo Collection") as! photoCollectionViewController
            return destViewController
        } else if previewingContext.sourceView == videoTable {
            guard let indexPath = videoTable.indexPathForRow(at: location) else {
                return nil
            }
            let url = NSURL(string: "http://www.youtube.com/watch?v=\((self.videoCollection?.items[indexPath.row].snippet.resourceId["videoId"])!)/")
            let webView = UIWebView()
            let webVC = UIViewController()
            webVC.view.frame = self.view.frame
            webView.frame = webVC.view.frame
            webView.scalesPageToFit = true
            webView.loadRequest(URLRequest(url: url as! URL))
            webVC.view.addSubview(webView)
            return webVC
        }
        return nil
    }
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if previewingContext.sourceView == albumCollection {
            navigationController?.pushViewController(viewControllerToCommit, animated: true)
        }
    }
    
    func didSelect(_ segmentIndex: Int) {
        selectedSegment = segmentIndex
        videoTable.reloadData()
        if selectedSegment == 0 {
            albumCollection.isHidden = false
            albumCollection.isUserInteractionEnabled = true
            videoTable.isHidden = true
            videoTable.isUserInteractionEnabled = false
        } else if selectedSegment == 1 {
            albumCollection.isHidden = true
            albumCollection.isUserInteractionEnabled = false
            videoTable.isHidden = false
            videoTable.isUserInteractionEnabled = true
        }
    }
    
    func getImage(_ urlString: String, _ imageView: UIImageView) {
        
        let spinner = UIActivityIndicatorView()
        spinner.frame = imageView.frame
        spinner.activityIndicatorViewStyle = .white
        spinner.center = CGPoint(x: imageView.frame.size.width / 2, y: imageView.frame.size.height / 2)
        spinner.backgroundColor = UIColor.gray
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        spinner.layer.zPosition = 100000
        imageView.addSubview(spinner)
        
        let url : URL = URL(string: urlString)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil {
                let image = UIImage(data: data!)
                if image != nil {
                    DispatchQueue.main.async(execute: {
                        imageView.image = image
                        spinner.stopAnimating()
                    })
                }
            }
        })
        task.resume()
    }
    
    func setUpSegmentedControl() {
        let titles = ["Photos", "Videos"]

        let frame = CGRect(x: self.view.frame.width / 2 - self.view.frame.width * 0.45 , y: self.view.frame.height * 0.85, width: self.view.frame.width * 0.9, height: 40)
        
        let segmentedControl = TwicketSegmentedControl(frame: frame)
        segmentedControl.setSegmentItems(titles)
        segmentedControl.delegate = self as? TwicketSegmentedControlDelegate
        segmentedControl.tag = 1
        view.addSubview(segmentedControl)
        
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
