//
//  photoViewerViewController.swift
//  DBS
//
//  Created by SDG on 22/1/2018.
//  Copyright © 2018 DBSSDG. All rights reserved.
//

import UIKit

class photoViewerViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    var myCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.white
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(ImagePreviewFullViewCell.self, forCellWithReuseIdentifier: "viewerCell")
        myCollectionView.isPagingEnabled = true
        
        self.view.addSubview(myCollectionView)
        
        myCollectionView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        DispatchQueue.main.async {
            self.myCollectionView.scrollToItem(at: [0, photoSelected], at: .left, animated: false)
        }
        
        let shareButton = UIBarButtonItem(image: #imageLiteral(resourceName: "share-arrow"), style: .plain, target: self, action: #selector(self.sharePhoto))
        self.navigationItem.rightBarButtonItem = shareButton
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewerCell", for: indexPath) as! ImagePreviewFullViewCell
        cell.imgView.image = imageArray[indexPath.row]
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        photoSelected = (myCollectionView.indexPath(for: myCollectionView.visibleCells[0])?.item)!
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.itemSize = myCollectionView.frame.size
        flowLayout.invalidateLayout()
        myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let offset = myCollectionView.contentOffset
        let width  = myCollectionView.bounds.size.width
        
        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        
        myCollectionView.setContentOffset(newOffset, animated: false)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.myCollectionView.reloadData()
            self.myCollectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
    }
    
    func sharePhoto() {
        let activityViewController = UIActivityViewController(
            activityItems: [myCollectionView.cellForItem(at: [0, photoSelected])?.asImage()], applicationActivities: nil)
        
////              This line is for the popover you need to show in iPad
//                activityViewController.popoverPresentationController?.sourceView = navigationItem.rightBarButtonItem
////              This line remove the arrow of the popover to show in iPad
//                activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection
        
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        activityViewController.excludedActivityTypes = []
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func down(_ sender: Any) {
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
        imgView.image = UIImage(named: "user3")
        scrollImg.addSubview(imgView!)
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
    }
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollImg.frame = self.bounds
        imgView.frame = self.bounds
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
