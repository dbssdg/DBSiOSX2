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

class photoCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource , UIViewControllerPreviewingDelegate{
   
    
    

    @IBOutlet weak var photoCollection: UICollectionView!
    var photoAlbum : PhotoCollection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageArray.removeAll()
        photoSelected = 0
        print(imageArray.isEmpty)
//        if !imageArray.isEmpty {
//            imageArray.removeAll()
//        }
        
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
                        self.photoCollection.scrollToItem(at: [0,(self.photoAlbum?.data)!.count-1], at: .bottom, animated: false)
                        self.photoCollection.scrollToItem(at: [0,0], at: .top, animated: false)
                        
//                        for i in 0..<(self.photoAlbum?.data)!.count {
//                            imageArray += [(self.photoCollection.cellForItem(at: [0, i]) as! photoCollectionViewCell).image.image!]
//                        }
                        for i in (self.photoAlbum?.data)! {
                            imageArray += [nil]
                        }
                    }
                    
                } catch {
                    print("ERROR")
                }
            }.resume()
            
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.text = "\((albumAlbum?.data[albumSelected]["name"]!)!)"
        self.navigationItem.titleView = label
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (self.view.frame.width-3)/3, height: (self.view.frame.width-3)/3)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        photoCollection!.collectionViewLayout = layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photoAlbum?.data == nil {
            return 0
        }
        return (photoAlbum!.data).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! photoCollectionViewCell
        getImage("http://graph.facebook.com/\((photoAlbum?.data[indexPath.row]["id"])!)/picture", cell.image, indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if imageArray[photoSelected] != nil {
            photoSelected = indexPath.row
            performSegue(withIdentifier: "Photo Viewer", sender: self)
        }
    }
    
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//        guard let indexPath = photoCollection.indexPathForItem(at: location) else {
//            return nil
//        }
//        let detailViewController = ViewController()
//        let imageView = UIImageView()
//        if let x = (photoCollection.cellForItem(at: indexPath) as! photoCollectionViewCell).image.image {
//            imageView.image = x
//        } else {
//            photoCollection.reloadData()
//        }
//        imageView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
//        detailViewController.view.addSubview(imageView)
//        return detailViewController
//    }
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//        navigationController?.pushViewController(viewControllerToCommit, animated: true)
//    }
    
    func getImage(_ urlString: String, _ imageView: UIImageView, _ index: Int){
        let url : URL = URL(string: urlString)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil {
                let imageOut = UIImage(data: data!)
                if imageOut != nil {
                    DispatchQueue.main.async(execute: {
                        imageView.image = imageOut
                        imageArray[index] = imageOut
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
        
        
        
        if imageArray[photoSelected] != nil {
            photoSelected = indexPath.row
            //return imageArray[photoSelected]!
        }
        
        
        let destViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "photoCollectionView") as! ContributionsViewController
    
        return destViewController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        <#code#>
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
