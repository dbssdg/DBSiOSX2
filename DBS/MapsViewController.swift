//
//  MapsViewController.swift
//  DBS
//
//  Created by SDG on 18/10/2017.
//  Copyright © 2017 DBSSDG. All rights reserved.
//

import UIKit

class MapsViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var MapImage: UIImageView!
    @IBOutlet weak var ScrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.title = "Maps"
        self.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        ScrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        MapImage.frame = ScrollView.frame
        
        ScrollView.maximumZoomScale = 10.0
        ScrollView.minimumZoomScale = 1.0
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var zoomRect = CGRect()
        zoomRect.size.height = scrollView.frame.size.height / scrollView.zoomScale
        zoomRect.size.width  = scrollView.frame.size.width  / scrollView.zoomScale
//        zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
//        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.MapImage
    }
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
     
    }/*
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
 */
    
    override var shouldAutorotate: Bool{return true}

    /*- (CGRect)zoomRectForScrollView:(UIScrollView *)scrollView withScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // The zoom rect is in the content view's coordinates.
    // At a zoom scale of 1.0, it would be the size of the
    // imageScrollView's bounds.
    // As the zoom scale decreases, so more content is visible,
    // the size of the rect grows.
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  
    
 
}
