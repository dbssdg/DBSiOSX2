//
//  photoViewerViewController.swift
//  DBS
//
//  Created by SDG on 22/1/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit

class photoViewerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImagePreviewFullViewCell.self, forCellWithReuseIdentifier: "viewerCell")
        collectionView.isPagingEnabled = true
        
        self.view.addSubview(collectionView)
        
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: [0, photoSelected], at: .left, animated: false)
        }
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.sharePhoto))
        self.navigationItem.rightBarButtonItem = shareButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: [0, photoSelected], at: .left, animated: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewerCell", for: indexPath) as! ImagePreviewFullViewCell
        DispatchQueue.main.async {
            
            
            let image = imageArray[indexPath.row]
            
            var scale = CGFloat(1)
            if image != nil{
                scale = (image?.size.width)! / self.view.frame.width
            }
            
            cell.imgView.frame.size = CGSize(width: self.view.frame.width, height: (image?.size.height)! / scale)
            cell.imgView.center = self.view.center
            
            cell.imgView.contentMode = .scaleAspectFit
            cell.imgView.image = image
            
            let downGest = UISwipeGestureRecognizer(target: self, action: #selector(self.back(recognizer:)))
            downGest.direction = .down
            cell.addGestureRecognizer(downGest)
            let shrinkGest = UIPinchGestureRecognizer(target: self, action: #selector(self.back(recognizer:)))
            shrinkGest.scale = 0.8
            cell.addGestureRecognizer(shrinkGest)
            
            if cell.imgView.frame.height == self.view.frame.height{
                print("reload")
                cell.reloadInputViews()
            }
            
            
        }
        return cell
    }
    
    func back(recognizer: UIGestureRecognizer) {
        navigationController?.popViewController(animated: false)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        photoSelected = (collectionView.indexPath(for: collectionView.visibleCells[0])?.item)!
        
//        for i in 0..<imageArray.count {
//            if let scroll = (collectionView.cellForItem(at: [0,i]) as? ImagePreviewFullViewCell)?.scrollImg {
//                if scroll.zoomScale != 1 && photoSelected != i {
//                    scroll.setZoomScale(1, animated: true)
//                }
//            }
//        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.itemSize = collectionView.frame.size
        flowLayout.invalidateLayout()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let offset = collectionView.contentOffset
        let width  = collectionView.bounds.size.width
        
        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        
        collectionView.setContentOffset(newOffset, animated: false)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.collectionView.reloadData()
            self.collectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
    }
    
    func sharePhoto() {
        let activityViewController = UIActivityViewController(
            activityItems: [(collectionView.cellForItem(at: [0, photoSelected]) as! ImagePreviewFullViewCell).imgView.image as Any], applicationActivities: nil)
        
////              This line is for the popover you need to show in iPad
//                activityViewController.popoverPresentationController?.sourceView = navigationItem.rightBarButtonItem
////              This line remove the arrow of the popover to show in iPad
//                activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection
        
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        activityViewController.excludedActivityTypes = []
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func down(_ sender: Any) {
//        print("@IBAction func down")
//        if scrollView.zoomScale == 1 {
//            self.navigationController?.popViewController(animated: true)
//        }
    }
    
}


class ImagePreviewFullViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    var scrollImg: UIScrollView!
    var imgView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        scrollImg = UIScrollView()
        scrollImg.delegate = self
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = false
        scrollImg.flashScrollIndicators()
        
        scrollImg.minimumZoomScale = 1
        scrollImg.maximumZoomScale = 8
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollImg.addGestureRecognizer(doubleTapGest)
        
        self.addSubview(scrollImg)
        
        imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = #imageLiteral(resourceName: "Home Logo")
        scrollImg.addSubview(imgView!)
        imgView.clipsToBounds = true
        
    }
    
    func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollImg.zoomScale <= 1 {
            scrollImg.zoom(to: zoomRectForScale(scale: scrollImg.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollImg.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imgView.frame.size.height / scale
        zoomRect.size.width  = imgView.frame.size.width  / scale
        let newCenter = imgView.convert(center, from: scrollImg)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale < 0.8 {
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        let imgHeight = (imgView.image?.size.height)! * (self.bounds.width / (imgView.image?.size.width)!)
//        scrollImg.frame = CGRect(x: 0, y: 187.5, width: self.bounds.width, height: imgHeight)
//        imgView.frame = scrollImg.frame
        
        scrollImg.frame = self.bounds
        imgView.frame = self.bounds
        
//        print(scrollImg.frame, imgView.frame, (imgView.image?.size)!, self.bounds)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollImg.setZoomScale(1, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
