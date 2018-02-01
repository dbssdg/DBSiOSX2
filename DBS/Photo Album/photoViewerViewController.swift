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
        
        print(photoSelected)
        print(self.view.frame.width * CGFloat(photoSelected))
        scrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(photoSelected), y: 0), animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        navigationController?.popViewController(animated: false)
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
