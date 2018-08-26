//
//  photoCollectionViewController.swift
//  DBS
//
//  Created by SDG on 22/1/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit
import SystemConfiguration

struct PhotoCollection : Decodable {
    let data : [[String : String]]
}

var photoSelected = 0
var imageArray = [UIImage?]()

class photoCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerPreviewingDelegate {
    
    
    @IBOutlet weak var photoCollection: UICollectionView!
    var photoAlbum : PhotoCollection?
    let titleView = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageArray.removeAll()
        photoSelected = 0
        print(imageArray.isEmpty)
        //        if !imageArray.isEmpty {
        //            imageArray.removeAll()
        //        }
        photoCollection.setContentOffset(CGPoint(x:0, y:0), animated: false)
        if isInternetAvailable() {
            
            URLSession.shared.dataTask(with: URL(string: "https://graph.facebook.com/\((albumAlbum?.data[albumSelected]["id"])!)/photos?limit=1000&access_token=\(photoToken)")!) { (data, response, error) in
                do {
                    
                    self.photoAlbum = (try JSONDecoder().decode(PhotoCollection?.self, from: data!))!
                    
                    DispatchQueue.main.async {
                        self.photoCollection.reloadData()
                        //                        usleep(50000)
                        //                        for i in 0..<(self.photoAlbum?.data.count)!-1 {
                        //                            self.photoCollection.scrollToItem(at: [0,i], at: .bottom, animated: false)
                        //                        }
                        
                        for i in 0..<self.collectionView(self.photoCollection, numberOfItemsInSection: 0) {
                            let iv = UIImageView()
                            self.getImage("http://graph.facebook.com/\((self.photoAlbum?.data[i]["id"])!)/picture", iv, i)
                        }
                        self.photoCollection.scrollToItem(at: [0,0], at: .top, animated: false)
                        
                        //                        for i in 0..<(self.photoAlbum?.data)!.count {
                        //                            imageArray += [(self.photoCollection.cellForItem(at: [0, i]) as! photoCollectionViewCell).image.image!]
                        //                        }
                        for _ in (self.photoAlbum?.data)! {
                            imageArray += [nil]
                        }
                    }
                    
                } catch {
                    print("ERROR")
                }
                }.resume()
            
        }
        
        titleView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        titleView.backgroundColor = .clear
        titleView.numberOfLines = 0
        titleView.textAlignment = .center
        titleView.font = UIFont.boldSystemFont(ofSize: 14.0)
        titleView.text = "\((albumAlbum?.data[albumSelected]["name"]!)!)"
        
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(updateTitle), userInfo: nil, repeats: true)
        
        self.navigationItem.titleView = titleView
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (self.view.frame.width-3)/3, height: (self.view.frame.width-3)/3)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        photoCollection!.collectionViewLayout = layout
        
        self.registerForPreviewing(with: self, sourceView: photoCollection!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateTitle() {
        if titleView.text == albumAlbum?.data[albumSelected]["name"] {
            var date = albumAlbum?.data[albumSelected]["created_time"]
            date?.removeLast(14)
            if let x = date {
                titleView.text = "Date: \(x)"
            }
        } else {
            titleView.text = "\((albumAlbum?.data[albumSelected]["name"]!)!)"
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoAlbum?.data == nil {
            return 0
        }
        return (photoAlbum!.data).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! photoCollectionViewCell
        //        getImage("http://graph.facebook.com/\((photoAlbum?.data[indexPath.row]["id"])!)/picture", cell.image, indexPath.row)
        cell.backgroundColor = .gray
        cell.image.image = imageArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photoSelected = indexPath.row
        if imageArray[photoSelected] != nil {
            photoSelected = indexPath.row
            performSegue(withIdentifier: "Photo Viewer", sender: self)
        }
    }
    
    
    func getImage(_ urlString: String, _ imageView: UIImageView, _ index: Int) {
        
        //        let spinner = UIActivityIndicatorView()
        //        spinner.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/3, height: self.view.frame.width/3)
        //        spinner.activityIndicatorViewStyle = .white
        //        spinner.center = CGPoint(x: spinner.frame.size.width / 2, y: spinner.frame.size.height / 2)
        //        spinner.backgroundColor = UIColor.gray
        //        spinner.startAnimating()
        //        spinner.hidesWhenStopped = true
        //        spinner.layer.zPosition = 100000
        //        imageView.addSubview(spinner)
        
        let url : URL = URL(string: urlString)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil {
                let imageOut = UIImage(data: data!)
                if imageOut != nil {
                    DispatchQueue.main.async(execute: {
                        imageView.image = imageOut
                        print(index, imageArray.count)
                        if imageArray.count > index {
                            imageArray[index] = imageOut
                        }
                        self.photoCollection.reloadData()
                        //                        spinner.stopAnimating()
                    })
                }
            } else {
                let networkAlert = UIAlertController(title: "ERROR", message: "Please check your network availability.", preferredStyle: .alert)
                func back(action: UIAlertAction) { self.navigationController?.popViewController(animated: true) }
                networkAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: back))
                self.present(networkAlert, animated: true)
            }
        })
        task.resume()
    }
    
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = photoCollection.indexPathForItem(at: location) else{
            return nil
        }
        
        previewingContext.sourceRect = photoCollection.cellForItem(at: indexPath)!.frame
        
        photoSelected = indexPath.row
        print(location, indexPath)
        if imageArray[photoSelected] != nil {
            
            let destViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "photoCollectionView") as! photoViewerViewController
            
            let scale = (imageArray[photoSelected]?.size.width)! / photoCollection!.frame.width
            //previewingContext.sourceRect = CGRect(x: 0, y: (self.view.frame.height * 0.5 - ((imageArray[photoSelected]?.size.height)! / scale) * 0.5), width: self.view.frame.width, height: (imageArray[photoSelected]?.size.height)! / scale))
            
            destViewController.preferredContentSize = CGSize(width: self.view.frame.width * 0.9, height: (imageArray[photoSelected]?.size.height)! / scale * 0.9)
            
            if let collection = destViewController.collectionView{
                DispatchQueue.main.async {
                    collection.scrollToItem(at: [0, photoSelected], at: .left, animated: false)
                }
                print("scrolled to item")
            }
            
            return destViewController
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
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
