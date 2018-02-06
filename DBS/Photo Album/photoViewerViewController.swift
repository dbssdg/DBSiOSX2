//
//  photoViewerViewController.swift
//  DBS
//
//  Created by SDG on 22/1/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit

class photoViewerViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        scrollView.frame = view.frame
        print(imageArray)
        
        for i in 0..<imageArray.count {
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: self.view.frame.width*CGFloat(i), y: -50, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i+1)
            scrollView.addSubview(imageView)
        }
        
        scrollView.maximumZoomScale = 10
        scrollView.minimumZoomScale = 0.5
        scrollView.isUserInteractionEnabled = true
        
        print(self.view.frame.width * CGFloat(photoSelected))
        scrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(photoSelected), y: 0), animated: false)
        
        let shareButton = UIBarButtonItem(image: #imageLiteral(resourceName: "share-arrow"), style: .plain, target: self, action: #selector(self.sharePhoto))
        self.navigationItem.rightBarButtonItem = shareButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sharePhoto() {
        let activityViewController = UIActivityViewController(
            activityItems: [scrollView.subviews[photoSelected].asImage()], applicationActivities: nil)
        
////              This line is for the popover you need to show in iPad
//                activityViewController.popoverPresentationController?.sourceView = navigationItem.rightBarButtonItem
////              This line remove the arrow of the popover to show in iPad
//                activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        activityViewController.excludedActivityTypes = []
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func doubleTapped(_ sender: Any) {
//
//        func handleDoubleTap(recognizer: UITapGestureRecognizer) {
//            if scrollView.zoomScale > 1 {
//                scrollView.setZoomScale(1, animated: true)
//            } else {
//                scrollView.setZoomScale(5, animated: true)
//            }
//        }
//        handleDoubleTap(recognizer: sender as! UITapGestureRecognizer)
    }

    @IBAction func down(_ sender: Any) {
        if scrollView.zoomScale == 1 {
            navigationController?.popViewController(animated: true)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        photoSelected = Int(scrollView.contentOffset.x / self.view.frame.width)
        print(photoSelected)
//        viewForZooming(in: scrollView)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
//
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        viewForZooming(in: scrollView)
//        if scrollView.zoomScale < 0.75 {
//            navigationController?.popViewController(animated: true)
//        }
//    }
//    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return scrollView.subviews[photoSelected]
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
